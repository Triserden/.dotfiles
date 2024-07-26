{config, ...}:
{
  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Triserden";
    userEmail = "triserden@gmail.com";
    
    includes = [{
      condition = "gitdir:~/Code/spc/"; # Trailing slash is important!
      contents = {
        user.name = config.sops.spcUser;
        user.email = config.sops.spcEmail;
        user.signingkey = config.sops.spcGPGKey;
  };
}];

    extraConfig = {
      commit.gpgsign = true;
      user.signingkey = "46CC369C9264F713";
    };
  };
}
