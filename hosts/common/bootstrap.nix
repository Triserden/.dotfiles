{
  services.openssh = {
   enable = true;
   settings.PasswordAuthentication = false;
   settings.KbdInteractiveAuthentication = false;
   openFirewall = true;
  };
  
  users.users."triserden".openssh.authorizedKeys.keys = [
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICCG7lTuHjzSp57sgrVz/dbGP5zHC5isZx9gcEI+ZlgW triserden" # content of authorized_keys file
  # note: ssh-copy-id will add user@your-machine after the public key
  # but we can remove the "@your-machine" part
];
}
