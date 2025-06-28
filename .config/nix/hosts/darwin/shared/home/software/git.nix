{ pkgs, ... }: {
  programs.git = {
    enable = true;
    userName = "Selene Blok";
    userEmail = "selene.blok@gmail.com";
    # signing = {
    #   format = "ssh";
    #   signByDefault = true;
    #   signer = 
    # };
  };
}
