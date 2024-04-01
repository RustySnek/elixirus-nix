{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix
  ];

  boot.loader.grub.configurationLimit = 1;
  nix.gc.automatic = true;
  #boot.loader.generic-extlinux-compatible.enable = true;

  networking.nameservers = [
    "1.1.1.1"
  ];
  networking.hostName = "rustysnek"; # Define your hostname.
 #systemd.network.enable = true;
 #systemd.network.networks."10-wan" = {
 #  matchConfig.Name = "eth0";
 #  networkConfig.DHCP = "ipv4";
 #};

  time.timeZone = "Europe/Warsaw";
  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
    logLevel = "VERBOSE";
  };

  services.fail2ban = {
    enable = true;
  };

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDa9pvV1c7pT3D9ylcJ/5aMID8Ksxe4MDLDBhwnXvtOv1OY28tBUHq7wCdA9iw+iH07mn5F9u09QxFZxp8PPOrMhOeL/2EAppfrSFgulh/qKMyy7AwHwTvlEXGJcy/95IIJbDfkd+r/ZOh3gd1qbI6414xwKZ5jRLnSWVdKut52VkpVixG5BsmHWMwNOX0HiGarhYXP1kcFx4khzx1OqO52gT/8or7rz5G2IXebDYiBcOxsBJdLyGO4HZcgopriT63wuOj3exGo6QjtvUgQc39/3zIBlyYDMRClw5OTE5WLlL4R30U9D7VKY5+xSiLGObfTrYDgNnuhc/WT/JBPlonHa+dFvct5n/iqWzJho3ToFHdNFAh4OalZlj2eNAgQbgvrBGUIdwHI/Uyx/FPJCACIcEY9t+UpV2YUIidG9E9syZyWNkvU77wb28P4+NYaUllYn4M3qryNPbTXlFKCd2yCrQHMPvR6mmNx0lj6+NS6zfhThIfWOI967ZKQMtrn2Pc= q@stein"
  ];

  environment.variables = {
    EDITOR = "nvim";
  };

  environment.defaultPackages = [];

  environment.systemPackages = with pkgs; [
    neovim
    podman-compose
    git
  ];

  system.stateVersion = "23.11"; # Did you read the comment? yes I did
}
