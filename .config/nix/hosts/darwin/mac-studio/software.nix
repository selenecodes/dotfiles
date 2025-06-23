{ pkgs, lib, ... }: {
  imports = [
    ../shared/software.nix
  ];

  environment.systemPackages = lib.mkAfter (with pkgs; []);

  # `brew list <>` can help pinpoint package name
  # for both ordinary packages and casks
  homebrew.brews = lib.mkAfter [
    "asimov"
  ];

  homebrew.casks = lib.mkAfter [
    # Shared apps
    "mp3tag"
    "audiobook-builder"
    "musicbrainz-picard"
    "plex"
    # Mac fixes
    "daisydisk"
    # VPN
    "protonvpn"
    # Messaging
    "discord"
    "signal"
    "whatsapp"
    # Gaming
    "virtualhereserver"
    "moonlight"
    "nvidia-geforce-now"
    "steam"
    "prismlauncher"
  ];

  # `mas search <>` can help pinpoint package name
  homebrew.masApps = lib.mkAfter{
    "Infuse" = 1136220934;
    "Manet" = 6470928235;
    # TODO: fix prologue issue
    "Prologue" = 1459223267;
  };
}