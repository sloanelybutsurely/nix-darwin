{ pkgs, ... }:
{
  home = {
    stateVersion = "23.11";
    packages = with pkgs; [
      ripgrep
      jq
      gh
      eza
      zoxide
    ];
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_vi_key_bindings
      if not set -q TMUX
        set -g TMUX tmux new-session -d -s default
        eval $TMUX
        tmux attach-session -d -t default
      end
    '';
    plugins = [
      {
        name = "hydro";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "hydro";
          rev = "41b46a05c84a15fe391b9d43ecb71c7a243b5703";
          hash = "sha256-zmEa/GJ9jtjzeyJUWVNSz/wYrU2FtqhcHdgxzi6ANHg=";
        };
      }
    ];
    shellAbbrs = {
      g    = "git";
      ga   = "git add";
      gb   = "git branch";
      gc   = "git commit";
      gcb  = "git checkout -b";
      gco  = "git checkout";
      gd   = "git diff";
      gf   = "git fetch";
      gp   = "git push";
      gP   = "git push --force-with-lease";
      gpl  = "git pull";
      gplr = "git pull --rebase ";
      gr   = "git rebase";
      grr  = "git rebase --continue";
      gst  = "git status";
      gca  = "git commit -a";
    };
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shortcut = "a";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      prefix-highlight
      catppuccin
      vim-tmux-navigator
    ];
  };
}
