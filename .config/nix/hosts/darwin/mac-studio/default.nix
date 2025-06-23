{ ... }:
{
  imports = [
    ../shared/configuration.nix
    ./software.nix
  ];
  nixpkgs.hostPlatform = "aarch64-darwin";
  system.primaryUser = "seleneblok";
  networking.knownNetworkServices = [
    "Ethernet"
    "Thunderbolt Bridge"
    "Wi-Fi"
  ];
}