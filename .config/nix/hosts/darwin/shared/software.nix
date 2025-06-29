# Applications that should be installed on all devices. Please note that
# applications which are configured through home-manager go in the
# ./home/{appname}.nix folder and will be installed from there. DO NOT DUPLICATE
# THESE APPS HERE!
{ pkgs, ... }: {
  fonts.packages = [
    pkgs.nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    # Terminal
    neovim
    tmux
    fzf
    stow
    tree
    docker
    # Git
    git-lfs
    # Node.js
    fnm
    vscode
  ];

  homebrew = {
    enable = true;
    # disabling quarantine would mean no stupid macOS do-you-really-want-to-open dialogs
    caskArgs.no_quarantine = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      # zap is a more thorough uninstall, ref: https://docs.brew.sh/Cask-Cookbook#stanza-zap
      cleanup = "zap";
      extraFlags = [ "--verbose" ];
    };

    # `brew list <>` can help pinpoint package name
    # for both ordinary packages and casks
    brews = [
      "mas"
    ];

    casks = [
      "arc"
      "iina"
      "logitune"
      "plexamp"
      "raycast"
      "affine"
      "obsidian"
      "lm-studio"
      "ollama-app"
      # Mac fixes
      "cleanshot"
      # Remove ghostty and enable ./home/ghostty once the pkg is no longer broken
      "ghostty"
      "linearmouse"
      "monitorcontrol"
      "soundsource"
      "git-credential-manager"
      # Messaging
      "microsoft-teams"
      "slack"
    ];

    # `mas search <>` can help pinpoint package name
    masApps = {
      "Amphetamine" = 937984704;
      "1Password for Safari" = 1569813296;
      "Tailscale" = 1475387142;
    };
  };
}
