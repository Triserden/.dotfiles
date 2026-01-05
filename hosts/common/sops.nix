{ inputs, config, ... }:
let secretsFolder = builtins.toString inputs.secrets;
in {
  sops = {
    defaultSopsFile =
      "${secretsFolder}/sops/${config.host.hostname}/secrets.yaml";
    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = { "passwords/${config.host.user}" = { neededForUsers = true; }; };
  };
}
