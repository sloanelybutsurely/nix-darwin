{ self, pkgs, ... }:
{
  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    fish
    git
    curl
    tmux
  ];

  environment.shells = [ pkgs.fish ];

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # nix.package = pkgs.nix;

  # Necessary for using flakes on this system.
  nix.settings.experimental-features = "nix-command flakes";

  # Create /etc/zshrc that loads the nix-darwin environment.
  programs.zsh.enable = true;  # default shell on catalina
  programs.fish.enable = true;


  # Used for backwards compatibility, please read the changelog before changing.
  # $ darwin-rebuild changelog
  system.stateVersion = 4;

  # The platform the configuration will be used on.
  nixpkgs.hostPlatform = "aarch64-darwin";

  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
    };
    autoUpdate = true;
    casks = [
      "1password"
      "alfred"
      "discord"
      "fantastical"
      "firefox"
      "karabiner-elements"
      "keepingyouawake"
      "kitty"
      "obsidian"
      "postgres-unofficial"
      "postico"
      "syncthing"
      "tailscale"
      "unnaturalscrollwheels"
    ];
  };
}
