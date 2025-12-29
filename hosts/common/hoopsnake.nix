{ inputs, pkgs, config, lib, ... }: {
  imports = [ inputs.hoopsnake.nixosModules.default ];

  boot.initrd = {
    network = { enable = true; };
    systemd.extraBin.ping = "${pkgs.iputils}/bin/ping";
    systemd = { enable = true; };
  };

  boot.initrd.systemd.services.hoopsnake = {
    wants = [ "network-online.target" ];
  };

  sops.secrets = {
    "hoopsnake/privateHostKey" = { };
    "hoopsnake/clientId" = { };
    "hoopsnake/clientSecret" = { };
  };
  boot.initrd.network.hoopsnake = {
    enable = true;
    systemd-credentials = {
      privateHostKey.file = config.sops.secrets."hoopsnake/privateHostKey".path;
      privateHostKey.encrypted = false;

      clientId.file = config.sops.secrets."hoopsnake/clientId".path;
      clientId.encrypted = false;
      clientSecret.file = config.sops.secrets."hoopsnake/clientSecret".path;
      clientSecret.encrypted = false;
    };
    ssh = {
      authorizedKeysFile = pkgs.writeText "authorized_keys"
        ("ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxqr4QFoAlWRMtrH7TGTQxwLFqLVDHVsttqrkUHJGuw triserden@megumi");
    };
    tailscale = {
      name = "${config.networking.hostName}-unlock";
      tags = [ "tag:hoopsnake" ];
    };
  };

  boot.initrd.availableKernelModules = [ "xhci_pci" ];
}
