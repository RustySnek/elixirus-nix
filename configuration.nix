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
  
    extraConfig = builtins.concatStringsSep "\n" [''
    ClientAliveCountMax 5
    ClientAliveInterval 30
    ''
    ];
  };

  services.fail2ban = {
    enable = true;
  };

  users.users."root".openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDa9pvV1c7pT3D9ylcJ/5aMID8Ksxe4MDLDBhwnXvtOv1OY28tBUHq7wCdA9iw+iH07mn5F9u09QxFZxp8PPOrMhOeL/2EAppfrSFgulh/qKMyy7AwHwTvlEXGJcy/95IIJbDfkd+r/ZOh3gd1qbI6414xwKZ5jRLnSWVdKut52VkpVixG5BsmHWMwNOX0HiGarhYXP1kcFx4khzx1OqO52gT/8or7rz5G2IXebDYiBcOxsBJdLyGO4HZcgopriT63wuOj3exGo6QjtvUgQc39/3zIBlyYDMRClw5OTE5WLlL4R30U9D7VKY5+xSiLGObfTrYDgNnuhc/WT/JBPlonHa+dFvct5n/iqWzJho3ToFHdNFAh4OalZlj2eNAgQbgvrBGUIdwHI/Uyx/FPJCACIcEY9t+UpV2YUIidG9E9syZyWNkvU77wb28P4+NYaUllYn4M3qryNPbTXlFKCd2yCrQHMPvR6mmNx0lj6+NS6zfhThIfWOI967ZKQMtrn2Pc= q@stein"
 ];
 users.users."elixirus_tunnel" = {
isNormalUser = true;
    createHome = true;
    home = "/home/elixirus_tunnel";
shell = "/bin/sh";
};
users.users."elixirus_tunnel".openssh.authorizedKeys.keys = [
 "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDUbYWpmEjinPusFY62EAGsj+RR/R/r36NgvJaURmzWQzk2Wq5WlQfbow275xRavKxutzsF8HEA0Vuv3oGmrpuIFr1Uccipjmu1NixlkG/NDejsanoPgtl2N37iTgHfTJvQMI2q0DObAjag0sKdAv927tJEKMx9fRIgvDs1yhlTSN1Is+tbMmJzwbV4YPP7v7FkNYzAtEz/eSmkr/DE+6IZajW4F5zDqx7WUDgZ8MqTIdRhKJf/RwZuw0LMSoNoI8TXYLg9zhWiP7yoAt2pZpPLs+aNLmseUbj4y7x8XMcjgbvvmgtGkOjB1KLErO+up29Xd08j29dcd62Ffsja4PizBLRRTSHKo5ipxqwOEMhG/F3ULfw5Fd2dLsBjldFflwEQDm23203LPRe3mPZg6CdYkARpE840VP9K9BlUatEcpmopNzOg7zRupj//4jKEOAetiNnYp+HrQqSshglD8fbo/Ez8t/0OFvo5vrBElPkiCIyPH62H1CRhSfjXM2xDgmc= root@samsung-klte" ];

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
