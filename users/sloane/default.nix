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
      yadm
    ];

    sessionVariables = {
      EDITOR = "nvim";
    };
  };

  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      fish_vi_key_bindings
      zoxide init fish | source
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
      vim = "nvim";

      # git
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

  programs.git = {
    enable = true;
    userName = "sloane";
    userEmail = "1699281+sloanelybutsurely@users.noreply.github.com";
    signing = {
      signByDefault = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID0TH2GezEx8+zlKBqUb7rBsbmghnd1u4nX6YpQr28Zw";
    };
    extraConfig = {
      init.defaultBranch = "main";
      push.autoSetupRemote = true;
      gpg = {
        format = "ssh";
        ssh.program = "/Applications/1Password.app/Contents/MacOS/op-ssh-sign";
      };
    };
  };

  programs.ssh = {
    enable = true;
    matchBlocks = {
      "*" = {
        extraOptions.IdentityAgent = ''"~/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"'';
      };
    };
  };

  programs.tmux = {
    enable = true;
    keyMode = "vi";
    shortcut = "a";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      prefix-highlight
      vim-tmux-navigator
      {
        plugin = catppuccin;
        extraConfig = "set -g @catppuccin_flavour 'frappe'";
      }
    ];
  };

  programs.kitty = {
    enable = true;
    font = {
      name = "Cousine Nerd Font Mono Regular";
      size = 18;
    };
    shellIntegration = {
      enableFishIntegration = true;
    };
    theme = "Catppuccin-Frappe";
  };
}
