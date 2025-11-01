{ inputs, pkgs, config, lib, ... }:
let hostSpec = config.hostSpec;
in {
  users = {
    mutableUsers = false;
    users = (lib.mergeAttrsList (map (user: {
      "${user}" = let
        platformPath =
          lib.custom.relativeToRoot "hosts/common/users/${user}/nixos.nix";
      in  import platformPath { inherit config lib user; };}) hostSpec.users)) // {
      root = {
        hashedPasswordFile =
          config.users.users.${config.hostSpec.primaryUser}.hashedPasswordFile;
        hashedPassword = lib.mkForce
          config.users.users.${config.hostSpec.primaryUser}.hashedPassword;
      };
    };
  };

  home-manager = let
    fullPathIfExists = path:
      let fullPath = lib.custom.relativeToRoot path;
      in lib.optional (lib.pathExists fullPath) fullPath;
  in {
    extraSpecialArgs = {
      inherit pkgs inputs;
      hostSpec = config.hostSpec;
    };
    users = (lib.mergeAttrsList (map (user: {
      "${user}" = {
        imports = lib.flatten [
          (map (fullPathIfExists) [
            "home/${user}/${hostSpec.hostname}.nix" 
          ])
        ];
        home.stateVersion = hostSpec.stateVersion;
      };
    }) hostSpec.users)) // {
      root = { home.stateVersion = hostSpec.stateVersion; };
    };
  };
}
