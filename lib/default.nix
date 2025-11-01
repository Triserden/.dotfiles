{lib, ...}:
{
  # Note: using this function with a string does not work for some ongodly reason??? Pass an array with a singular string and put map in front of it.
  relativeToRoot = lib.path.append ../.;
    appendToAll = 
      {prefix, paths}: builtins.map (path: (map lib.custom.relativeToRoot(prefix)+paths)) paths;
  scanPaths =
    path:
    builtins.map (f: (path + "/${f}")) (
      builtins.attrNames (
        lib.attrsets.filterAttrs (
          path: _type:
          (_type == "directory") # include directories
          || (
            (path != "default.nix") # ignore default.nix
            && (lib.strings.hasSuffix ".nix" path) # include .nix files
          )
        ) (builtins.readDir path)
      )
    );
}
