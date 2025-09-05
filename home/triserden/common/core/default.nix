{lib, hostSpec, ...}:
{
  imports = lib.flatten [
    (lib.custom.scanPaths ./.)
    (map lib.custom.relativeToRoot [
      "helpers"
    ])
  ];
  
  inherit hostSpec;
  programs.home-manager.enable = true;
}
