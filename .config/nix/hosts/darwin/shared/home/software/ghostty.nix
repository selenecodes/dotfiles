{ pkgs, ... }:
# Add ghostty mock since we're managing it through homebrew and the
# pkgs.ghostty is marked as broken on macos.
# Problem: https://github.com/NixOS/nixpkgs/issues/388984#issuecomment-2715508998
# Solution: https://github.com/nix-community/home-manager/issues/6295
let
  ghostty-mock = pkgs.writeShellScriptBin "gostty-mock" ''
    true
    '';
in {  
  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    package = ghostty-mock;
    settings = {
      theme = "catppuccin-mocha";
      adjust-cell-height = "10%";
      command = "/bin/zsh -c \"tmux new -A -s work\"";
      copy-on-select = true;
      font-family = "Jetbrains Mono";
      font-size = 16;
      font-thicken = true;
      mouse-hide-while-typing = true;
      macos-non-native-fullscreen="visible-menu";
      macos-option-as-alt = true;
      macos-titlebar-style = "hidden";
      window-decoration=false;
      window-padding-y = 0;
      window-padding-x = 0;
      window-padding-color = "extend";
      window-padding-balance = true;
      window-save-state = "always";
      keybind = [
        ## TMUX - https://gist.github.com/oca159/5124a22012b1887bbf2b6e2cc1f9e574
        # To delete from the current position to the start of the line
        "super+backspace=esc:w"

        # TMUX integration considering that my leader key is ctrl + b

        # Go to the N window in tmux in tmux it is Ctrl+b+number
        "super+one=text:\x02\x31"
        "super+two=text:\x02\x32"
        "super+three=text:\x02\x33"
        "super+four=text:\x02\x34"
        "super+five=text:\x02\x35"
        "super+six=text:\x02\x36"
        "super+seven=text:\x02\x37"
        "super+eight=text:\x02\x38"
        "super+nine=text:\x02\x39"

        # New tmux window on Cmd+t in tmux it is Ctrl+b+c
        "super+t=text:\x02\x63"

        # Close tmux pane on Cmd+w in tmux it is Ctrl+b+x (it is using a custom keybind in tmux to kill the pane)
        "super+w=text:\x02\x78"

        # Switch to a window using tmux-fzf on Cmd+p in tmux it is Ctrl+b+w
        "super+p=text:\x02\x77"

        # Rename a tmux window on Cmd+r in tmux it is Ctrl+b+,
        "super+r=text:\x02\x2c"

        # Go to the previous tmux window on Cmd+h in tmux it is Ctrl+b+p
        "super+h=text:\x02\x70"

        # Go to te next tmux window on Cmd+l in tmux it is Ctrl+b+n
        "super+l=text:\x02\x6e"

        # Split the window horizontally on Cmd+minus in tmux it is Ctrl+b+" (For me it is horizontal split but in tmux it is considered vertical split)
        "super+minus=text:\x02\x22"

        # Split the window vertically on Cmd+backslash in tmux it is Ctrl+b+% (For me it is vertical split but in tmux it is considered horizontal split)
        # TODO: I want to change it Cmd+pipe but looks like ghostty doesn't support that key for now
        "super+backslash=text:\x02\x25"

        # Toggle pane zoom on Cmd+z in tmux it is Ctrl+b+z
        "super+z=text:\x02\x7a"

        # Move tmux window to left on Cmd+i in tmux it is M-i (alt+i it is a custom keybind)
        "super+i=text:\x1bi"

        #Move tmux window to right on Cmd+o in tmux it is M-o (alt+o it is a custom keybind)
        "super+o=text:\x1bo"
      ];
    };
  };
}
