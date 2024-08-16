{pkgs, ...}:

{
  environment.systemPackages = [
    pkgs.neovim 
    
    # Required for nvim plugins
    pkgs.gcc_multi
    pkgs.cargo
    pkgs.unzip
    pkgs.nodejs_22
  
    pkgs.eza
    pkgs.bat
  ];

  
  # Install programs
  programs.npm.enable = true;
}
