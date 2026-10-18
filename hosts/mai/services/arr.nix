{inputs, config, ...}:
  let secretsFolder = builtins.toString inputs.secrets;
  in {
    virtualisation.oci-containers.compose-containers."arr" = {
    path = ./compose-files/arr-stack.yml;
    convertOptions = {
      sops_file = "${secretsFolder}/sops/${config.host.hostname}/services/arr.yaml"; 
      runtime = "docker";
    };
  };
}
