{ pkgs, ...}:

{
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."luke" = {
    isNormalUser = true;
    description = "Luke";
    extraGroups = [ "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINXDCjc6y8O8IdgJPImpFSFibZ42ZDgXp5M5sWgCVWoi"];
  };
}