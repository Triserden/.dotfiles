{lib, ...}:
{
  programs.hypridle = {
    enable = true;
    settings = {
  general = {
    after_sleep_cmd = "hyprctl dispatch dpms on";
    ignore_dbus_inhibit = false;
    lock_cmd = "hyprlock";
  };

  listener = [
    {
      timeout = 150;                                # 2.5min.
      on-timeout = "brightnessctl -s set 10";         # set monitor backlight to minimum, avoid 0 on OLED monitor.
      on-resume = "brightnessctl -r";                 # monitor backlight restore.
}
    {
      timeout = 900;
      on-timeout = "hyprlock";
    }
    {
      timeout = 1200;
      on-timeout = "hyprctl dispatch dpms off";
      on-resume = "hyprctl dispatch dpms on";
    }
    {
      timeout = 1800;                                # 30min
      on-timeout = "systemctl suspend";                # suspend pc
    }
  ];
};
  };


  programs.hyprlock = {
    settings = {
      general = {
  general = {
    hide_cursor = true;
    ignore_empty_input = true;
  };

  animations = {
    enabled = true;
    fade_in = {
      duration = 300;
      bezier = "easeOutQuint";
    };
    fade_out = {
      duration = 300;
      bezier = "easeOutQuint";
    };
  };

  background = [
    {
      path = lib.custom.relativeToRoot wallpapers/wallhaven-1qk5pv_2560x1440.png;
      blur_passes = 3;
      blur_size = 8;
    }
  ];

  input-field = [
    {
      size = "200, 50";
      position = "0, -80";
      monitor = "";
      dots_center = true;
      fade_on_empty = false;
      font_color = "rgb(202, 211, 245)";
      inner_color = "rgb(91, 96, 120)";
      outer_color = "rgb(24, 25, 38)";
      outline_thickness = 5;
      shadow_passes = 2;
    }
  ];
};
  };
  };
}
