{ inputs, config, pkgs, lib, ... }:
{
  imports = [
    ../shared/configuration.nix
  ];
  nixpkgs.hostPlatform = "x86_64-darwin";
  system.primaryUser = "seleneblok";
  system.security.pam.services.sudo_local.touchIdAuth = true;
  networking.knownNetworkServices = [
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];
}