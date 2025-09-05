{inputs, lib, ...}:
{
  imports = lib.flatten [
    # --- Hardware ---
    inputs.hardware.nixosModules.lenovo-ideapad-15ach6
    ./hardware-configuration.nix
    
    # --- Disko ---
    # TODO: Disko config for megumi

  ];
  system.StateVersion = "25.05";
}
