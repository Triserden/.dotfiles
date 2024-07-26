{config, ...}:
{
  sops.secrets.spcuser = {};
  sops.secrets.spcemail = {};
  sops.secrets.spcgpgkey = {};

  programs.git = {
    enable = true;
    lfs.enable = true;
    userName = "Triserden";
    userEmail = "triserden@gmail.com";
    
    includes = [{
      condition = "gitdir:~/Code/spc/"; # Trailing slash is important!
      contents = {
        user.name = config.sops.secrets.spcuser;
        user.email = config.sops.secrets.spcemail;
        user.signingkey = config.sops.secrets.spcgpgkey;
  };
}];

    extraConfig = {
      commit.gpgsign = true;
      user.signingkey = "46CC369C9264F713";
    };
  };
}
