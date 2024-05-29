{pkgs, ...}: {
  services.caddy.virtualHosts."elixirus.rustysnek.xyz".extraConfig = ''
    reverse_proxy :4000
  '';
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.oci-containers.containers.elixirus = {
    image = "ghcr.io/rustysnek/elixirus:latest";
    ports = ["4000:4000"];
    extraOptions=[
    "--network=host"
    # "--network=container:protonwire" # Looks like librus blocks popular VPNs xdddd
    ];
   
    environmentFiles = ["/run/keys/elixirus.env.secret"];
  };

# virtualisation.oci-containers.containers.protonwire = {
#   image ="ghcr.io/tprasadtp/protonwire:7";
#   ports = ["4000:4000"];
#   extraOptions=[
#   "--cap-add=NET_ADMIN"
#   "--sysctl=net.ipv4.conf.all.rp_filter=2"
#   "--sysctl=net.ipv6.conf.all.disable_ipv6=1"
#   ];
#   environmentFiles = ["/run/keys/private-key"];
#   environment = {
#     PROTONVPN_SERVER = "185.107.56.117"; 
#   };
# };
  systemd.timers."elixirus-update" = {
    wantedBy = ["timers.target"];
    timerConfig = {
      Unit = "elixirus-update.service";
      OnCalendar = "weekly";
      Persistent = true;
    };
  };

  systemd.services."elixirus-update" = {
    script = ''
      set -eu
      ${pkgs.podman}/bin/podman pull ghcr.io/rustysnek/elixirus:latest
      ${pkgs.systemd}/bin/systemctl restart podman-elixirus
    '';
    serviceConfig = {
      Type = "oneshot";
      User = "root";
    };
  };
}
