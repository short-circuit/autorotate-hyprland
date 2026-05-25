{
  description = "Automatic display rotation for Hyprland based on accelerometer input";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      forAllSystems = nixpkgs.lib.genAttrs nixpkgs.lib.platforms.linux;

      mkPkg = system:
        let pkgs = import nixpkgs { inherit system; }; in
        pkgs.stdenvNoCC.mkDerivation {
          pname = "autorotate-hyprland";
          version = "0-unstable-${self.lastModifiedDate or "1970-01-01"}";
          dontBuild = true;
          dontUnpack = true;
          nativeBuildInputs = [ pkgs.makeWrapper ];
          installPhase = ''
            mkdir -p $out/bin
            cp ${./rotate-screen.sh} $out/bin/.rotate-screen-raw
            cp ${./toggle-rotation.sh} $out/bin/.toggle-rotation-raw
            chmod +x $out/bin/.rotate-screen-raw $out/bin/.toggle-rotation-raw
          '';
          postFixup = ''
            wrapProgram $out/bin/.rotate-screen-raw \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.iio-sensor-proxy pkgs.hyprland ]}
            mv $out/bin/.rotate-screen-raw $out/bin/rotate-screen

            wrapProgram $out/bin/.toggle-rotation-raw \
              --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.libnotify ]}
            mv $out/bin/.toggle-rotation-raw $out/bin/toggle-rotation
          '';
          meta = with pkgs.lib; {
            description = "Automatic display rotation for Hyprland";
            longDescription = ''
              Automatic display rotation for Hyprland based on accelerometer input.
              Perfect for tablets and convertible laptops.
            '';
            license = licenses.bsd3;
            homepage = "https://github.com/short-circuit/autorotate-hyprland";
            maintainers = [ ];
            platforms = platforms.linux;
            mainProgram = "rotate-screen";
          };
        };

      mkNixosModule = self: { config, lib, pkgs, ... }:
        let
          cfg = config.programs.autorotate-hyprland;
        in {
          options.programs.autorotate-hyprland = {
            enable = lib.mkEnableOption "autorotate-hyprland - automatic display rotation for Hyprland";

            package = lib.mkOption {
              type = lib.types.package;
              default = self.packages.${pkgs.system}.default;
              defaultText = lib.literalExpression "pkgs.autorotate-hyprland";
              description = "The autorotate-hyprland package to use.";
            };

            settings = {
              monitor = lib.mkOption {
                type = lib.types.str;
                default = "eDP-1";
                description = "Monitor to rotate.";
              };
              mode = lib.mkOption {
                type = lib.types.str;
                default = "preferred";
                description = "Display mode (e.g. preferred, 1920x1080, ...).";
              };
              position = lib.mkOption {
                type = lib.types.str;
                default = "auto";
                description = "Display position (e.g. auto, 0x0, ...).";
              };
              scale = lib.mkOption {
                type = lib.types.str;
                default = "1";
                description = "Display scale factor.";
              };
            };
          };

          config = lib.mkIf cfg.enable {
            environment.systemPackages = [ cfg.package ];

            systemd.user.services.autorotate-hyprland = {
              description = "Autorotate Hyprland display";
              documentation = [ "https://github.com/short-circuit/autorotate-hyprland" ];
              wantedBy = [ "graphical-session.target" ];
              partOf = [ "graphical-session.target" ];
              serviceConfig = {
                Type = "simple";
                ExecStart = "${cfg.package}/bin/rotate-screen";
                Restart = "on-failure";
                RestartSec = "5s";
              };
              environment = {
                MONITOR = cfg.settings.monitor;
                MODE = cfg.settings.mode;
                POSITION = cfg.settings.position;
                SCALE = cfg.settings.scale;
              };
            };
          };
        };

      mkHmModule = self: { config, lib, pkgs, ... }:
        let
          cfg = config.programs.autorotate-hyprland;
        in {
          options.programs.autorotate-hyprland = {
            enable = lib.mkEnableOption "autorotate-hyprland - automatic display rotation for Hyprland";

            package = lib.mkOption {
              type = lib.types.package;
              default = self.packages.${pkgs.system}.default;
              defaultText = lib.literalExpression "pkgs.autorotate-hyprland";
              description = "The autorotate-hyprland package to use.";
            };

            settings = {
              monitor = lib.mkOption {
                type = lib.types.str;
                default = "eDP-1";
                description = "Monitor to rotate.";
              };
              mode = lib.mkOption {
                type = lib.types.str;
                default = "preferred";
                description = "Display mode (e.g. preferred, 1920x1080, ...).";
              };
              position = lib.mkOption {
                type = lib.types.str;
                default = "auto";
                description = "Display position (e.g. auto, 0x0, ...).";
              };
              scale = lib.mkOption {
                type = lib.types.str;
                default = "1";
                description = "Display scale factor.";
              };
            };
          };

          config = lib.mkIf cfg.enable {
            home.packages = [ cfg.package ];

            systemd.user.services.autorotate-hyprland = {
              description = "Autorotate Hyprland display";
              documentation = [ "https://github.com/short-circuit/autorotate-hyprland" ];
              wantedBy = [ "graphical-session.target" ];
              partOf = [ "graphical-session.target" ];
              serviceConfig = {
                Type = "simple";
                ExecStart = "${cfg.package}/bin/rotate-screen";
                Restart = "on-failure";
                RestartSec = "5s";
              };
              environment = {
                MONITOR = cfg.settings.monitor;
                MODE = cfg.settings.mode;
                POSITION = cfg.settings.position;
                SCALE = cfg.settings.scale;
              };
            };
          };
        };

    in {
      packages = forAllSystems (system: {
        default = mkPkg system;
        autorotate-hyprland = mkPkg system;
      });

      nixosModules.default = mkNixosModule self;
      homeManagerModules.default = mkHmModule self;

      overlays.default = final: prev: {
        autorotate-hyprland = mkPkg final.system;
      };
    };
}
