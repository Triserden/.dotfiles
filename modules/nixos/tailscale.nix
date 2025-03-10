{lib, config, pkgs, ...}: 
{
  options = {
    tailscale.enable = lib.mkEnableOption "Enable tailscale";
    tailscale.authkey = lib.mkOption {
      type = lib.types.path;
      description = "Tailscale auth keyfile from sops-nix or other secrets provider";
    };
  };
  
  config = lib.mkIf config.tailscale.enable {
    environment.systemPackages = [ pkgs.tailscale ];
    services.tailscale.enable = true;
  
    networking.firewall = {
      enable = true;

      trustedInterfaces = [" tailscale0 "];

      allowedUDPPorts = [ config.services.tailscale.port ];
    };

    boot.kernel.sysctl = {
        "net.ipv4.ip_forward" = 1;
        "net.ipv6.conf.all.forwarding" = 1;
      };

    systemd.services.tailscale-autoconnect = {
      description = "Automatic connection to Tailscale";

      # make sure tailscale is running before trying to connect to tailscale
      after = [ "network-pre.target" "tailscale.service" ];
      wants = [ "network-pre.target" "tailscale.service" ];
      wantedBy = [ "multi-user.target" ];

      # set this service as a oneshot job
      serviceConfig.Type = "oneshot";

      # have the job run this shell script
      script = with pkgs; ''
        # wait for tailscaled to settle
        sleep 2

        # check if we are already authenticated to tailscale
        status="$(${tailscale}/bin/tailscale status -json | ${jq}/bin/jq -r .BackendState)"
        if [ $status = "Running" ]; then # if so, then do nothing
          exit 0
        fi

        # Check if key is almost expired
        if (( $(date --date $(${tailscale}/bin/tailscale status --json | ${jq}/bin/jq '.Self.KeyExpiry' | tr -d '"') +'%s') > $(date --date "30 days ago" +'%s') ))
        then
          ${tailscale}/bin/tailscale up --force-reauth --authkey=$(cat "${config.tailscale.authkey}") --ssh 
          exit 0
        fi

        # otherwise authenticate with tailscale
        ${tailscale}/bin/tailscale up --authkey=$(cat "${config.tailscale.authkey}") --ssh
      '';
    };

  };
}
