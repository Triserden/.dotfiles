{lib, config, ...}: 
{
  options.hyprland.enable = lib.mkEnableOption "Enable hyprland and configure";
  config = lib.mkIf config.hyprland.enable {
    services.playerctld.enable = true;
    wayland.windowManager.hyprland = {
      enable = true; # enable Hyprland
      settings = {
        # Monitors
        #TODO: Make specialization for vertical/horizontal monitor?
        monitor = [ 
          "eDP-1,1920x1080@120.002,auto,1"
          "desc:RTD Display 0x01010101, highres, auto-up, auto"
          ",preferred,auto,auto"
        ];

        xwayland = {
          force_zero_scaling = true;
        };

        "$terminal" = "foot";
        "$fileManager" = "nemo";
        "$menu" = "fuzzel";

        exec-once = [
          "swww-daemon"
          "arrpc"
          "clipse -listen"
        ];

        env = [
          "XCURSOR_SIZE,24"
        ];
        
        input = {
          kb_layout = "us";
          kb_variant = "";
          kb_model = "";
          kb_options = "";
          kb_rules = "";

          follow_mouse = true;

          touchpad =  {
             natural_scroll = true;
          };

          sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
        };

        general = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

          gaps_in = 5;
          gaps_out = 20; 
          border_size = 2;
          "col.active_border" = "rgba(33ccffee) rgba(00ff99ee) 45deg";
          "col.inactive_border" = "rgba(595959aa)";

          layout = "dwindle";

          # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
          allow_tearing = false;
        };

        decoration = {
        # See https://wiki.hyprland.org/Configuring/Variables/ for more

          rounding = 10;

          blur = {
            enabled = true;
            size = 3;
            passes = 1;
          };

          shadow = {
            enabled = true;
            range = 4;
            render_power = 3;
            color = "rgba(1a1a1aee)";
          };
        };

        workspace = [
          "w[tv1], gapsout:0, gapsin:0"
          "f[1], gapsout:0, gapsin:0"
          ];
        windowrulev2 = [ 
          "bordersize 0, floating:0, onworkspace:w[tv1]"
          "rounding 0, floating:0, onworkspace:w[tv1]"
          "bordersize 0, floating:0, onworkspace:f[1]"
          "rounding 0, floating:0, onworkspace:f[1]"
          "float,class:(foot),title:(clipse)"
          "size 622 622,class:(foot),title:(clipse)"
          ];

        animations = {
          enabled = true;

          # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

          bezier = "myBezier, 0.05, 0.9, 0.1, 1.05";

          animation = [ 
            "windows, 1, 7, myBezier"
            "windowsOut, 1, 7, default, popin 80%"
            "border, 1, 10, default"
            "borderangle, 1, 8, default"
            "fade, 1, 7, default"
            "workspaces, 1, 6, default"
          ];
        };

        dwindle = {
          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          pseudotile = true; # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
          preserve_split = true; # you probably want this
        };

        master = {
            # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
            new_status = "master";
        };



        gestures = {
            # See https://wiki.hyprland.org/Configuring/Variables/ for more
            workspace_swipe = false;
        };

        misc = {
           # See https://wiki.hyprland.org/Configuring/Variables/ for more
          force_default_wallpaper = -1; # Set to 0 to disable the anime mascot wallpapers
        };

        
# See https://wiki.hyprland.org/Configuring/Keywords/ for more
"$mainMod" = "SUPER";

bindl = [
        # Requires playerctl
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
];
bindel = [
        # Laptop multimedia keys for volume and LCD brightness
        ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ",XF86MonBrightnessUp, exec, brightnessctl s 10%+"
        ",XF86MonBrightnessDown, exec, brightnessctl s 10%-"
];
binde = [
"$mainMod SHIFT, right, resizeactive, 10 0"
"$mainMod SHIFT, left, resizeactive, -10 0"
"$mainMod SHIFT, up, resizeactive, 0 -10"
"$mainMod SHIFT, down, resizeactive, 0 10"
];
# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
# Bind flags at https://wiki.hyprland.org/Configuring/Binds/#bind-flags
bind = [", Print, exec, exec grimblast --notify copy area"
        "$mainMod, Q, exec, $terminal"
        "$mainMod, C, killactive,"
        "$mainMod, M, exit,"
        "$mainMod, E, exec, $fileManager"
        "$mainMod, F, togglefloating,"
        "$mainMod, R, exec, fuzzel"
        "$mainMod, P, pseudo,"
        "$mainMod, J, togglesplit,"
        "$mainMod, left, movefocus, l"
        "$mainMod, right, movefocus, r"
        "$mainMod, up, movefocus, u"
        "$mainMod, down, movefocus, d"
        "$mainMod, mouse_down, workspace, e+1"
        "$mainMod, mouse_up, workspace, e-1"
        "$mainMod, V, exec, $terminal -T clipse -e 'clipse'"
        ] ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (builtins.genList (i:
            let ws = i + 1;
            in [
              "$mainMod, code:1${toString i}, workspace, ${toString ws}"
              "$mainMod SHIFT, code:1${toString i}, movetoworkspace, ${toString ws}"
            ]
          )
          9)
      );
      # Move/resize windows with mainMod + LMB/RMB and dragging
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      };
    };
  }; 
}
