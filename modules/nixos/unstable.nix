{lib, inputs, config, ...}: 
{
  options = {
    unstable.enable = lib.mkEnableOption "Enable pkgs.unstable";
  };
  
  config = lib.mkIf config.unstable.enable {
    nixpkgs.overlays = [
    (final: _: {
      # this allows you to access `pkgs.unstable` anywhere in your config
      unstable = import inputs.nixpkgs-unstable {
        inherit (final.stdenv.hostPlatform) system;
        inherit (final) config;
      };
    })
  ];
  };
}