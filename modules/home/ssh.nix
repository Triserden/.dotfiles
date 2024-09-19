{lib, config, ...}: 
{
  options = {
    ssh.enable = lib.mkEnableOption "Enable SSH";
  };
  
  config = lib.mkIf config.ssh.enable {
    programs.ssh = {
      enable = true;

      matchBlocks = {
        "github.com" = {
          identityFile = "~/.ssh/id_ed25519";
        };
      };
    };
  }; 
}
