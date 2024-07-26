{config, ...}:
{
  sops.secrets.spcUser = {};
  sops.secrets.spcEmail = {};
  sops.secrets.spcGPGKey = {};

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Triserden";
    userEmail = "triserden@gmail.com";
    
    includes = [{
      condition = "gitdir:~/Code/spc/"; # Trailing slash is important!
      contents = {
        user.name = config.sops.secrets.spcUser;
        user.email = config.sops.secrets.spcEmail;
        user.signingkey = config.sops.secrets.spcGPGKey;
  };
}];

    extraConfig = {
      commit.gpgsign = true;
      user.signingkey = "46CC369C9264F713";
    };
  };
}
