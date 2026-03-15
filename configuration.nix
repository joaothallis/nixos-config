{
  modulesPath,
  lib,
  pkgs,
  ...
} @ args:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    ./disk-config.nix
  ];
  boot.loader.grub = {
    # no need to set devices, disko will add all devices that have a EF02 partition to the list already
    # devices = [ ];
    efiSupport = true;
    efiInstallAsRemovable = true;
  };
  services.openssh.enable = true;
  services.openssh.settings.PasswordAuthentication = false;

  services.tailscale.enable = true;

  users.groups.media = {};

  services.jellyfin = {
    enable = true;
    group = "media";
    openFirewall = true;
  };

  services.radarr = {
    enable = true;
    group = "media";
    openFirewall = true;
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

   services.qbittorrent = {
    enable = true;
    group = "media";
    openFirewall = true;
  };

  systemd.tmpfiles.rules = [
    "d /srv/media 2775 root media -"
    "d /srv/media/movies 2775 root media -"
    "d /srv/media/tv 2775 root media -"
    "d /srv/media/music 2775 root media -"
    "d /srv/media/downloads 2775 root media -"
  ];

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.gitMinimal
    pkgs.jellyfin
    pkgs.jellyfin-web
    pkgs.jellyfin-ffmpeg
  ];

  users.users.root.openssh.authorizedKeys.keys =
  [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ8qXHy5C/9jorjd8l7TrcSQx6YeMG5G7wJTD8vO/Mg9"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAM6HLJh0uCHKTrOezHaS8ov6K66Fq5USYjqrL3X64cO joaothallis.developer@gmail.com"
  ] ++ (args.extraPublicKeys or []); # this is used for unit-testing this module and can be removed if not needed

  system.stateVersion = "25.11";
}
