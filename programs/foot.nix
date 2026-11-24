{...}: {
  programs.foot = {
    enable = true;
    enableBashIntegration = true;
    settings = {
      main = {
        font = "JetbrainsMono:size=12";
      };
    };
  };
}
