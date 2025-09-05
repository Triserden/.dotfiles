{config, pkgs, ...}:
{
  environment.systemPackages = [ pkgs.tailscale  ];
  sops.secrets.tailscale-oauth-key = {};
  services.tailscale = {
    enable = true;
    openFirewall = false;
    extraUpFlags = [ "--ssh" ];
    authKeyFile = config.sops."tailscale-oauth-key".path;
    authKeyParameters = "--advertise-tags=tag:end-user";
  };
}
