{ pkgs ? import <nixpkgs> {}, }: let
  nvf = builtins.getFlake
  "github:NotAShelf/nvf/7e53fc47243448fdd01adf2a5b780831853c5dca";
in (nvf.lib.neovimConfiguration { inherit pkgs; modules = [
(_: { config.vim = {
/*--------------------------------------------------------------*/

# format, undohist, localai

  enableLuaLoader = false;
  useSystemClipboard = true;
  preventJunkFiles = true;

  globals = {
    editorconfig = true;
    mapleader = " ";
    maplocalleader = ",";
  };

  options = {
    guifont = "Source Code Pro:h10";
    relativenumber = true;
    shiftwidth = 2;
    mouse = "";
  };
  
  keymaps = [
    { key = "<c-h>"; action = "<cmd>wincmd h<CR>"; mode = ["n"]; }
    { key = "<c-j>"; action = "<cmd>wincmd j<CR>"; mode = ["n"]; }
    { key = "<c-k>"; action = "<cmd>wincmd k<CR>"; mode = ["n"]; }
    { key = "<c-l>"; action = "<cmd>wincmd l<CR>"; mode = ["n"]; }
    { key = "<Left>"; action = "<Nop>"; mode = ["v" "n" "i"]; }
    { key = "<Right>"; action = "<Nop>"; mode = ["v" "n" "i"]; }
    { key = "<Up>"; action = "<Nop>"; mode = ["v" "n" "i"]; }
    { key = "<Down>"; action = "<Nop>"; mode = ["v" "n" "i"]; }
  ];

  telescope = {
    enable = true;
    mappings = {
      findFiles = "<leader>f";
      liveGrep = "<leader>g";
      buffers = "<leader>b";
    };
  };

  spellcheck = {
    enable = true;
    programmingWordlist.enable = true;
    languages = ["en"];
  };

  autopairs.nvim-autopairs = {
    enable = true;
    setupOpts = {
      map_c_h = false;
      map_c_w = false;
    };
  };
  
  autocomplete.nvim-cmp = {
    enable = true;
    mappings = {
      next = "<Tab>";
      previous = "<S-Tab>";
    };
  };

  # https://github.com/yetone/avante.nvim
  # lazy.plugins."avante.nvim" = {
  #   package = pkgs.vimPlugins.avante-nvim;
  #   setupModule = "avante";
  #   setupOpts = {
  #     option_name = true;
  #   };
  #   after = ''
  #     -- custom lua code to run after plugin is loaded
  #     print('aerial loaded')
  #   '';
  #   lazy = true; /*mark plugin as lazy, NOT NEEDED IF YOU DEFINE ON OF TRIGGER EVENTS BELOW*/
  #   cmd = ["AerialOpen"]; /*load on command*/
  #   event = ["BufEnter"]; /*load on event*/
  #   keys = [ /*load on keymap*/
  #     {
  #       key = "<leader>a";
  #       action = ":AerialToggle<CR>";
  #     }
  #   ];
  # };

  debugger.nvim-dap = {
    enable = true;
    ui = {
      enable = true;
      autoStart = false;
      setupOpts = {
        floating = {
          max_height = 50;
          max_width = 20;
          border = "single";
        };
      };
    };
    mappings = {
      runLast = "<leader>d";
      toggleDapUI = "<leader>do";
      toggleBreakpoint = "<leader>db";
      toggleRepl = "<leader>dr";
      hover = "<leader>dh";
      terminate = "<leader>dq";
      restart = "<leader>drs";
      runToCursor = "<leader>drc";
      stepInto = "<leader>dso";
      stepBack = "<leader>dsk";
      stepOut = "<leader>dst";
      stepOver = "<leader>dsr";
      goUp = "<leader>dgu";
      goDown = "<leader>dgd";
    };
  };

  formatter.conform-nvim = {
    enable = true;
    setupOpts.formatters_by_ft = {
      hs = ["${pkgs.fourmolu}/bin/fourmolu"];
      lua = ["${pkgs.stylua}/bin/stylua"];
    };
  };

  languages = {
    enableLSP = true;
    enableTreesitter = true; 
    markdown = { enable = true; };
    nix = { enable = true; };
    haskell = { enable = true; };
    bash = { enable = true; };
    assembly = { enable = true; };
    java = { enable = true; };
    kotlin = { enable = true; };
    scala = { enable = true; };
    clang = { enable = true; };
    elixir = { enable = true; };
    go = { enable = true; };
    rust = { enable = true; };
    zig = { enable = true; };
    html = { enable = true; };
    css = { enable = true; };
    ts = { enable = true; };
    python = { enable = true; };
    ruby = { enable = true; };
  };

  presence.neocord = {
    enable = true;
    setupOpts = {
      enable_line_number = true;
      auto_update = true;
      show_time = true;
      blacklist = ["js"];
      logo = "https://files.catbox.moe/ytspyv.png"; # must be url in this string
      main_image = "language";
      logo_tooltip = "Hey! Don't stalk me! Buh...";
      editing_text = "glorping the %s file...";
      file_explorer_text = "guh... browsing %s...";
      git_commit_text = "glorping to the cloud!";
      line_number_text = "glorp %s out of %s line";
      plugin_manager_text = "glopple dopping the plugins...";
      reading_text = "reading %s... man! glorp this!";
      terminal_text = "glorping away at the terminal...";
      workspace_text = "cooking up a fat glorp!";
    };
  };

  theme = {
    enable = true;
    transparent = true;
    name = "base16";
    base16-colors = {
      base00 = "#121212"; # background
      base05 = "#d4cdcd"; # most text 
      base0B = "#f5c4e1"; # strings & quotes
      base03 = "#919091"; # comments
      base04 = "#d6c1d0"; # line-numbers
      base09 = "#bdc6ff"; # booleans & numbers
      base01 = "#665b51"; # text-highlight & completion 
      base02 = "#9e6c6c"; # visual-highlight & status-line
      base0F = "#bca3bf"; # symbols (commas, semicolons, carrots)
      base0E = "#a8718e"; # expressions (let, do, type)
      base08 = "#41a38c"; # modules (in let-in, after import)
      base0D = "#a2b3a1"; # core (import, #include, main)
      base0A = "#bf846d"; # misc (builtins, IO, void)
      base0C = "#a1d1f0"; # telescope search/string
      base07 = "#020030"; # ugly-dark-blue
      base06 = "#1f001e"; # ugly-dark-purple
    };
  };

  luaConfigPost = ''
    vim.api.nvim_create_user_command("Format", function(args)
      local range = nil
      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end
      require("conform").format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
  '';

/*--------------------------------------------------------------*/
};})];}).neovim
