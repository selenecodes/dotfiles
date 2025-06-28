{ pkgs, lib, ... }: {
  imports = [
    ./software/bun.nix
    # ./software/ghostty.nix
    ./software/git.nix
    ./software/git-cliff.nix
    ./software/vscode.nix
    ./software/zoxide.nix
  ];

  home = {
    file.".config/linearmouse/linearmouse.json".source = "${./files/linearmouse.json}"; 
    file.".p10k.zsh".source = "${./files/.p10k.zsh}";
    file.".zshrc".source = "${./files/.zshrc}";
  };
}
