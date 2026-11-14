{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    withUWSM = true; # recommended for most users
    xwayland.enable = true; # Xwayland can be disabled.

    wayland.windowManager.hyprland.systemd.enable = false;
    wayland.windowManager.hyprland.enable = true;

    wayland.windowManager.hyprland.extraLuaFiles = {
      "noctalia" = {
        content = ./noctalia.lua;
      };
    };
    nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
    xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [ xdg-desktop-portal-hyprland ];
  };
  };
}
