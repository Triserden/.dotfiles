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
      path = "./config/gitusers";
}];

    extraConfig = {
      commit.gpgsign = true;
      user.signingkey = "46CC369C9264F713";
    };
  };
}
