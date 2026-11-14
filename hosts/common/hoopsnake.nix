{ inputs, pkgs, config, lib, ... }: let
hoopsnakeModule = import (
    builtins.toFile "hoopsnake-module.nix" (
      lib.replaceStrings [ "config.boot.initrd.systemd.enable" ] [ "true" ] (
        builtins.readFile "${inputs.hoopsnake}/nixos/module.nix"
      )
    )
  ) {
    # The upstream module takes flake-parts' `withSystem` only to default its
    # `package` option to the input's own build.
    withSystem =
      _system: f:
      f {
        config.packages.default = inputs.hoopsnake.packages.${pkgs.stdenv.hostPlatform.system}.default;
      };
  };
  in {
  imports = [ hoopsnakeModule ];

  boot.initrd = {
    network = { enable = true; };
    systemd.extraBin.ping = "${pkgs.iputils}/bin/ping";
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
        ("ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIjFWIdB23LyQW7rDaLJd2tnWPXqYjMjhgEqD/+WVaAQ triserden@megumi");
    };
    tailscale = {
      name = "${config.networking.hostName}-unlock";
      tags = [ "tag:hoopsnake" ];
    };
  };

  boot.initrd.availableKernelModules = [ "xhci_pci" ];
}
