{config, ...}:
{
  home = {
    username = config.hostSpec.primaryUser;
    homeDirectory = config.hostSpec.home;
    stateVersion = builtins.trace "setting stateversion" config.hostSpec.stateVersion;
    sessionVariables = {
      FLAKE = "$HOME/.dotfiles/";
      SHELL = "bash";
      TERM = "foot";
      TERMINAL = "foot";
      VISUAL = "nvim";
      EDITOR = "nvim";
    };
    preferXdgDirectories = true;
  };
}
