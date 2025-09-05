{inputs, config, ...}:
let
  secretsFolder = builtins.toString inputs.secrets + "/sops";
in {
sops = {
    defaultSopsFile = "${secretsFolder}/${config.hostSpec.hostName}.yaml";
    age = {
      sshKeyPath = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };
    secrets = {
    };
  };
}
