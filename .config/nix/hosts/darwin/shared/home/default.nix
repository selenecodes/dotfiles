{ pkgs, lib, ... }: {
  imports = [
    ./bun.nix
    # ./ghostty.nix
    ./git.nix
    ./git-cliff.nix
    ./vscode.nix
    ./zoxide.nix
  ];
}
