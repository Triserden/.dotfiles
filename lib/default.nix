{lib, ...}:
{
  # Note: using this function with a string does not work for some ongodly reason??? Pass an array with a singular string and put map in front of it.
  relativeToRoot = path: builtins.trace "Getting rooted path of ${builtins.toString path}"  lib.path.append ../. path;
  #  appendToAll = 
  #    {prefix, paths}: builtins.map (path: (lib.custom.relativeToRoot(prefix)+paths)) paths;
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
