{config, pkgs, ...}:
{
  environment.systemPackages = [ pkgs.tailscale  ];
  sops.secrets.tailscale-oauth-key = {};
  services.tailscale = {
    enable = true;
    openFirewall = false;
    authKeyFile = config.sops.secrets."tailscale-oauth-key".path;
    authKeyParameters = {
      ephemeral = false;
    };
    extraUpFlags = ["--ssh" "--advertise-tags=tag:end-devices"];
  };
  systemd.services.tailscaled-autoconnect = {
    wants = ["network-online.target"];
    after = ["network-online.target"];
    serviceConfig = {
      Restart = "on-failure";
      RestartSec = "15";
    };
  };
}
