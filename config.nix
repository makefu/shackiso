{ config, pkgs, lib, ... }:
{
  boot.loader.grub.enable = true;
  boot.loader.grub.devices = [ "/dev/sda" ];
  boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "ehci_pci" "usbhid" "usb_storage" "sd_mod" "sr_mod" ];
  services.openssh.enable = true;
  services.openssh.permitRootLogin = "yes";
  users.extraUsers.root.initialPassword = lib.mkForce "shackit";
  # this is set for install not to ask for password
  users.mutableUsers = false;
  fileSystems = [
    { mountPoint = "/"; fsType = "ext4"; label = "root"; }
  ];
}
