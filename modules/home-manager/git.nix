
{
  programs.git = {
    enable = true;
    userName = "Triserden";
    userEmail = "triserden@gmail.com";

    extraConfig = {
      commit.gpgsign = true;
      user.signingkey = "2422C7EE03C629FD998BF923FD5CD86B6562D6B7";
    };
  };
}
