# This nix-config is for secondary drives or other custom hardware configurations
{ config, ... }:

{
# Mount secondary disk
  fileSystems."/home/luke/storage" = {
    device = "/dev/disk/by-uuid/87d3c5ad-69a0-4dad-b6c5-d2f784ee97c8";
    fsType = "ext4";
    options = [ "nofail" ];
  };
}