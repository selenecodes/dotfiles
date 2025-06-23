{
  description = "Zenful Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    mac-app-util.url = "github:hraban/mac-app-util";
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nix-homebrew, nixpkgs, mac-app-util }:
  let
    mkConfiguration = { platform, primaryUser }: { pkgs, ... }: {
      nixpkgs.config.allowUnfree = true;
      nixpkgs.hostPlatform = platform;

      system = {
        # Set Git commit hash for darwin-version.
        configurationRevision = self.rev or self.dirtyRev or null;
        # Used for backwards compatibility, please read the changelog before changing.
        # $ darwin-rebuild changelog
        stateVersion = 6;
        primaryUser = primaryUser;
        defaults = {
          dock = {
            autohide = true;
            tilesize = 60;
            # Whether to make hidden apps translucent
            showhidden = true;
            # Group expose apps by application
            expose-group-apps = true;
            # Hot corners (1 is disabled)
            wvous-bl-corner = 1;
            wvous-br-corner = 1;
            wvous-tl-corner = 1;
            wvous-tr-corner = 1;
          };
          finder = {
            ShowRemovableMediaOnDesktop = false;
            ShowMountedServersOnDesktop = false;
            ShowHardDrivesOnDesktop = false;
            ShowExternalHardDrivesOnDesktop = false;
            # Search in same folder by default (instead of "this mac")
            FXDefaultSearchScope = "SCcf";
            AppleShowAllFiles = true;
            AppleShowAllExtensions = true;
          };
          menuExtraClock = {
            Show24Hour = true;
            ShowSeconds = true;
            ShowDate = 1;
          };
          spaces = {
            # MacOS spaces are configured on a per-monitor basis
            # I would prefer to span accross all monitors but this breaks
            # fullscreen apps (e.g. all screens turn black when entering fullscreen)
            # except for the main screen
            spans-displays = false;
          };
          trackpad = {
            # Enable lookup & data detectors on triple tap
            TrackpadThreeFingerTapGesture = 2;
            TrackpadThreeFingerDrag = true;
            # Medium firmness for clicks (0 is light, 1 is medium, 2 is firm)
            FirstClickThreshold = 1;
            SecondClickThreshold = 1;
          };
          WindowManager = {
            EnableTiledWindowMargins = false;
          };
        };
      };

      networking = {
        knownNetworkServices = [
          "Ethernet"
          "Thunderbolt Bridge"
          "Wi-Fi"
        ];
        dns = [
          "1.1.1.1"
          "1.0.0.1"
          "2606:4700:4700::1111"
          "2606:4700:4700::1001"
        ];
      };

      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages =
        [
          # Terminal
          pkgs.neovim
          pkgs.tmux
          pkgs.fzf
          pkgs.stow
          pkgs.tree
          pkgs.zoxide
          pkgs.docker
          # Git
          pkgs.git
          pkgs.git-lfs
          # Node.js
          pkgs.fnm
          pkgs.bun
          # Apps
          pkgs.arc-browser
          pkgs.vscode
          pkgs.iina       
        ];

      homebrew = {
        enable = true;
        brews = [
          "asimov"
          "mas"
        ];
        caskArgs.no_quarantine = true;
        casks = [
          "logitune"
          "mp3tag"
          "audiobook-builder"
          "musicbrainz-picard"
          "plex"
          "plexamp"
          "raycast"
          "affine"
          "lm-studio"
          "ollama"
          # Mac fixes
          "cleanshot"
          "ghostty"
          "linearmouse"
          "monitorcontrol"
          "soundsource"
          "daisydisk"
          "git-credential-manager"
          # VPN
          "tailscale"
          "protonvpn"
          # Messaging
          "discord"
          "signal"
          "whatsapp"
          "microsoft-teams"
          "slack"
          # Gaming
          "virtualhereserver"
          "moonlight"
          "nvidia-geforce-now"
          "steam"
          "prismlauncher"
        ];
        masApps = {
          "Amphetamine" = 937984704;
          "Infuse" = 1136220934;
          "1Password for Safari" = 1569813296;
          "Manet" = 6470928235;
          "Xcode" = 497799835;
          # TODO: fix prologue issue
          "Prologue" = 1459223267;
        };
        onActivation.cleanup = "zap";
        onActivation.autoUpdate = true;
        onActivation.upgrade = true;
      };

      fonts.packages = [
        pkgs.nerd-fonts.jetbrains-mono
      ];

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;
      programs.zsh.enable = true;
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations = {
      studio = nix-darwin.lib.darwinSystem {
        modules = [
          (mkConfiguration { platform = "aarch64-darwin"; primaryUser = "seleneblok"; })
          mac-app-util.darwinModules.default
          nix-homebrew.darwinModules.nix-homebrew
          {
              nix-homebrew = {
                enable = true;
                # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
                enableRosetta = true;
                # User owning the Homebrew prefix
                user = "seleneblok";
                # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
                # mutableTaps = false;
              };
          }
        ];
      };

      work = nix-darwin.lib.darwinSystem {
        modules = [
          (mkConfiguration { platform = "x86_64-darwin"; primaryUser = "seleneblok"; })
          mac-app-util.darwinModules.default
          nix-homebrew.darwinModules.nix-homebrew
          {
              nix-homebrew = {
                enable = true;
                user = "seleneblok";
                mutableTaps = false;
              };
          }
        ];
      };
    };
  };
}
