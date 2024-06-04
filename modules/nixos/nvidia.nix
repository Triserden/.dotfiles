{config, ...}:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  # NVIDIA drivers are unfree.  
  services.xserver.videoDrivers = [ "nvidia" "amdgpu" ]; # TODO: Separate amdgpu to it's own file

  hardware.opengl = {  
    enable = true;  
    driSupport = true;  
    driSupport32Bit = true;  
  };

  hardware.nvidia = {
    # Enable modesetting for Wayland compositors (hyprland)
    modesetting.enable = true;
    # Use the open source version of the kernel module (for driver 515.43.04+)
    open = true;

    powerManagement.finegrained = true;
    # Enable the Nvidia settings menu
    nvidiaSettings = true;
    # Select the appropriate driver version for your specific GPU
    package = config.boot.kernelPackages.nvidiaPackages.production;
  };

  #TODO: Move to dedicated hybrid file?
  hardware.nvidia.prime = {
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    amdgpuBusId = "PCI:6:0:0";

    nvidiaBusId = "PCI:1:0:0";
  };
}
