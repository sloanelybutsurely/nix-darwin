{ pkgs, ... }:
{
  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  homebrew = {
    casks = [
      "discord"
      "postgres-unofficial"
      "postico"
      "syncthing"
      "tailscale"
    ];
  };
}
