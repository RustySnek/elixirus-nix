{
  description = "elixirus nixos config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";
  };

  outputs = inputs @ {
    nixpkgs,
    ...
  }: {
    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
        };
      };

      rustysnek = {
        nixpkgs.system = "aarch64-linux";
        deployment.targetHost = "49.13.84.245";
        deployment.buildOnTarget = true;
        deployment.keys."elixirus.env.secret" = {
          keyCommand = ["pass" "elixirus/elixirus.env"];
        };
        deployment.keys."service-account.env" = {
          keyCommand = ["pass" "elixirus/service-account"];
        };
       #deployment.keys."private-key" = {
       #  keyCommand = ["pass" "elixirus/protonwire"];
       #};

        virtualisation.oci-containers.backend = "podman";
        networking.firewall.allowedTCPPorts = [80 443];
        services.caddy = {
          enable = true;
          virtualHosts."rustysnek.xyz".extraConfig = ''
            respond "Hello, world!"
          '';
        };

        imports = [
          ./configuration.nix
          ./elixirus.nix
        ];
      };
    };
  };
}
