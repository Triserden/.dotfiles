{i config,  ... }: {
  services.borgbackup.jobs.ninym = {
    paths = [
      "/home/"
      "/data/"
    ];
    exclude = [
        "/home/*/.cache"
        "/data/*/.cache"
    ];
    encryption = {
      mode = "repokey";
      passCommand = "cat ${config.sops.secrets.borg_password.path}";
    };
    environment.BORG_RSH = "ssh -i ${config.sops.secrets.borg_id_ed25519.path}";
    repo = "ssh://u512443-sub2@u512443-sub2.your-storagebox.de:23/./ninym";
    compression = "auto,zstd";
    startAt = "daily";
    persistentTimer = true;
  };

  # Rewrite to Borgmatic and build in monitoring
  #  services.prometheus.exporters.borgmatic = {
  #   enable = true;
  #  };
}
