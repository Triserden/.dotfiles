{config, pkgs, ...}:
{
  environment.systemPackages = [ pkgs.tailscale  ];
  sops.secrets.tailscale-oauth-key = {};
  services.tailscale = {
    enable = true;
    openFirewall = false;
    authKeyFile = config.sops.secrets."tailscale-oauth-key".path;
    extraUpFlags = ["--ssh" "--advertise-tags=tag:end-user"];
  };
}
