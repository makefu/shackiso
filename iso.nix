{ config, pkgs, lib, ... }:
let
  cfg = ./config.nix;
  partitions = pkgs.writeText "partitions" ''
    clearpart --all --initlabel --drives=sda
    part swap --size=512 --ondisk=sda
    part / --fstype=ext4 --label=root --grow --ondisk=sda
  '';
in {
  services.openssh.permitRootLogin = lib.mkForce "yes";
  users.extraUsers.root.initialPassword = lib.mkForce "shackit";
  systemd.services.inception = {
    description = "Self-bootstrap a NixOS installation";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" "polkit.service" ];
    # TODO: submit a patch for blivet upstream to unhardcode kmod/e2fsprogs/utillinux
    path = [ "/run/current-system/sw/" ];
    script = with pkgs; ''
      sleep 5
      ${pythonPackages.nixpart0}/bin/nixpart ${partitions}
      mkdir -p /mnt/etc/nixos/
      cp ${cfg} /mnt/etc/nixos/configuration.nix
      ${config.system.build.nixos-install}/bin/nixos-install -j 4
      ${systemd}/bin/shutdown -r now
    '';
    environment = {
      SSL_CERT_FILE = "${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt";
      HOME = "/root";
    };
    serviceConfig = {
      Type = "oneshot";
    };
  };
}
