{lib, pkgs, config, ...}: 
{
  options = {
    cli.enable = lib.mkEnableOption "Enable default CLI packages and options.";
  };
  
  config = lib.mkIf config.cli.enable {
    environment.systemPackages = [
      # NVIM stuff
      pkgs.neovim 
    
      # Required for nvim plugins
      pkgs.gcc_multi
      pkgs.cargo
      pkgs.unzip
      pkgs.nodejs_22
    ];
    programs.npm.enable = true;
  };
}
