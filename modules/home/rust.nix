{lib, config, ...}: 
{
  options = {
    rust.enable = lib.mkEnableOption "Enable the rust development environment";
  };
  
  config = lib.mkIf config.rust.enable {
    home.file.rust = {
      source = ./config/rust;
      target = "Code/Rust";
    };
  }; 
}
