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
    brews = [ "openssl" ];
    taps = [ "homebrew/cask-fonts" ];
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

      "font-cousine-nerd-font"
    ];
    masApps = {
      "Things 3" = 904280696;
    };
  };

  programs.nixvim = {
    enable = true;
    options = {
      number = true;
      relativenumber = true;

      tabstop = 2;
      shiftwidth = 2;
      expandtab = true;
    };

    colorschemes.catppuccin = {
      enable = true;
      flavour = "frappe";
    };

    extraPlugins = with pkgs.vimPlugins; [
      vim-abolish
      vim-dispatch
      vim-repeat
      vim-sensible

      vim-rhubarb
      vim-sort-motion
      vim-textobj-user

      nerdtree
    ];

    plugins = {
      surround.enable = true;
      commentary.enable = true;

      fugitive.enable = true;

      tmux-navigator.enable = true;

      lsp = {
        enable = true;
        servers = {
          elixirls.enable = true;
          tsserver.enable = true;
          nil_ls.enable = true;
        };
      };

      telescope = {
        enable = true;
        defaults = { preview = false; };
        extensions.fzf-native.enable = true;
      };

      cmp = {
        enable = true;
        autoEnableSources = true;
        settings = {
          mapping.__raw = "cmp.mapping.preset.insert({})";
          sources = [
            { name = "nvim_lsp"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
        };
        cmdline = {
          ":" = {
            mapping = { __raw = "cmp.mapping.preset.cmdline()"; };
            sources = [
              { name = "path"; }
              { name = "cmdline"; }
            ];
          };
        };
      };

      treesitter = {
        enable = true;
        indent = true;
      };
    };

    plugins.which-key = {
      enable = true;
      keyLabels = {
        "<space>" = "SPC";
        "<cr>" = "RET";
        "<tab>" = "TAB";
      };
      registrations = {
        "<leader>g" = "Git";
        "<leader>f" = "Files";
      };
    };

    globals.mapleader = " ";

    keymaps = [
      { key = ";"; action = ":"; }
      { key = "q;"; action = "q:"; }

      { key = "<leader>y"; action = "\"+y"; }
      { key = "<leader>Y"; action = "\"+Y"; }
      { key = "<leader>p"; action = "\"+p"; }
      { key = "<leader>P"; action = "\"+P"; }

      { key = "<leader>w"; action = "<cmd>w<cr>"; }
      { key = "<leader>q"; action = "<cmd>q<cr>"; }
      { key = "<esc>"; action = "<cmd>nohlsearch<cr>"; mode = "n"; }

      # root level leader commands
      {
        key = "<leader><space>";
        action = "<cmd>Telescope find_files<cr>"; 
        options = { desc = "Find files in project"; };
      }
      {
        key = "<leader>/";
        action = "<cmd>Telescope live_grep<cr>"; 
        options = { desc = "Search project"; };
      }
      {
        key = "<leader><tab>";
        action = "<cmd>NERDTreeToggle<cr>"; 
        options = { desc = "Toggle NERDTree"; };
      }

      # file commands
      {
        key = "<leader>fl";
        action = "<cmd>NERDTreeFind<cr>";
        options = { desc = "Locate file"; };
      }

      # git
      {
        key = "<leader>gs";
        action = "<cmd>Git<cr>"; 
        options = { desc = "Status"; };
      }
      {
        key = "<leader>gp";
        action = "<cmd>Git push<cr>"; 
        options = { desc = "Push"; };
      }
      {
        key = "<leader>gP";
        action = "<cmd>Git push --force-with-lease<cr>"; 
        options = { desc = "Push (force with lease)"; };
      }
      {
        key = "<leader>gf";
        action = "<cmd>Git fetch<cr>"; 
        options = { desc = "Fetch"; };
      }
      # git rebase
      {
        key = "<leader>gro";
        action = "<cmd>Git rebase origin/main<cr>"; 
        options = { desc = "origin/main"; };
      }
      {
        
        key = "<leader>grO";
        action = "<cmd>Git rebase --interactive origin/main<cr>"; 
        options = { desc = "-i origin/main"; };
      }
      {
        
        key = "<leader>grm";
        action = "<cmd>Git rebase origin/master<cr>"; 
        options = { desc = "origin/master"; };
      }
      {
        key = "<leader>grM";
        action = "<cmd>Git rebase --interactive origin/master<cr>"; 
        options = { desc = "-i origin/master"; };
      }
    ];

    # TODO: move this into Nix
    extraConfigLuaPost = ''
    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
      end,
    })
    '';
  };

  system.defaults = {
    dock = {
      orientation = "bottom";
      autohide = true;
      autohide-delay = 0.1;
      show-recents = false;
    };
  };
}
