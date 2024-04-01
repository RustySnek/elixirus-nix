{pkgs, ...}: {
  services.caddy.virtualHosts."elixirus.rustysnek.xyz".extraConfig = ''
    reverse_proxy :4000
  '';
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.oci-containers.containers.elixirus = {
    image = "ghcr.io/rustysnek/elixirus:latest";
    ports = ["4000:4000"];
    environmentFiles = ["/run/keys/elixirus.env.secret"];
  };

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
