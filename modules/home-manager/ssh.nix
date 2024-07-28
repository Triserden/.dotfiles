{config, pkgs, ...}:

{
  programs.ssh = {
    enable = true;

    matchBlocks = {
      "github.com" = {
        identityFile = "~/.ssh/id_ed25519";
      };
      "spc.github.com" = {
        identityFile = "~/.ssh/spc_id_ed25519";
      };
    };
  };
}
