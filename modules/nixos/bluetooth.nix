{
  hardware.bluetooth.enable = true;
  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };
  hardware.bluetooth.powerOnBoot = true;

  services.blueman.enable = true;
}
