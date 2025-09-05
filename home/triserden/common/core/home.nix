{config, ...}:
{
  home = {
    username = config.hostSpec.username;
    homeDirectory = config.hostSpec.home;
    stateVersion = config.hostSpec.stateVersion;
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
