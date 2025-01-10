{ pkgs, ... }: {

  # conform-nvim, telescope, treesitter, git

  home-manager.users.hatosu.programs = {

    nixvim = {

      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      package = pkgs.neovim-unwrapped;

      globals.mapleader = "\\";

      opts = {
        guifont = "Source Code Pro:h10";
        relativenumber = true;
        shiftwidth = 2;
        mouse = "";
      };

      performance = {
        combinePlugins = { enable = true; };
        byteCompileLua.enable = true;
      };

      clipboard = {
        register = "unnamedplus";
        providers.wl-copy.enable = true;
      };

      autoCmd = [{
        event = [ "BufEnter" "BufWinEnter" ];
        pattern = [ "*.c" "*.h" ];
        command = "echo 'Entering a C/C++ file";
      }];

      keymaps = [
        {key = "<leader>e"; action = "<cmd>NvimTreeToggle<CR>"; mode = ["n"]; options.noremap = true;}
        {key = "<leader>h"; action = "<cmd>UndotreeToggle<CR>"; mode = ["n"]; options.noremap = true;}
        {key = "<c-h>"; action = "<cmd>wincmd h<CR>"; mode = ["n"];}
        {key = "<c-j>"; action = "<cmd>wincmd j<CR>"; mode = ["n"];}
        {key = "<c-k>"; action = "<cmd>wincmd k<CR>"; mode = ["n"];}
        {key = "<c-l>"; action = "<cmd>wincmd l<CR>"; mode = ["n"];}
        {key = "<Left>"; action = "<Nop>"; mode = ["v" "n" "i"]; options.noremap = true;}
        {key = "<Right>"; action = "<Nop>"; mode = ["v" "n" "i"]; options.noremap = true;}
        {key = "<Up>"; action = "<Nop>"; mode = ["v" "n" "i"]; options.noremap = true;}
        {key = "<Down>"; action = "<Nop>"; mode = ["v" "n" "i"]; options.noremap = true;}
      ];

      plugins = {

        nix.enable = true;

        treesitter.enable = true;

        web-devicons.enable = true;

        lsp = {
          enable = true;
          servers = {

            nil_ls = { enable = true; };

            clangd = { enable = true; };

            rust_analyzer = {
              enable = true;
              installCargo = true;
              installRustc = true;
            };

            gopls = { enable = true; };

            zls = { enable = true; };

            lua_ls = {
              enable = true;
              settings = { telemetry.enable = false; };
            };

            bashls = { enable = true; };

            html = { enable = true; };

            marksman = { enable = true; };

            hls = {
              enable = true;
              installGhc = true;
            };

            typos_lsp = {
              enable = true;
              extraOptions.init_options.diagnosticSeverity = "Hint";
            };

          };
        };

        luasnip = {
          enable = true;
          settings = {
            enable_autosnippets = true;
            store_selection_keys = "<Tab>";
          };
        };

        lint = {
          enable = true;
          lintersByFt = {
            rst = [ "vale" ];
            text = [ "vale" ];
            c = [ "clangtidy" ];
            cpp = [ "clangtidy" ];
            haskell = [ "hlint" ];
            json = [ "jsonlint" ];
            bash = [ "shellcheck" ];
            shell = [ "shellcheck" ];
            clojure = [ "clj-kondo" ];
            nix = [ "nix" ];
            dockerfile = [ "hadolint" ];
            markdown = [ "markdownlint" ];
          };
        };

        cmp = {
          enable = true;
          autoEnableSources = true;
          settings = {
            autocomplete = true;
            sources = [{ name = "nvim_lsp"; }];
            performance = {
              debounce = 200;
              throttle = 200;
              maxViewEntries = 5;
            };
            snippet.expand = ''
              function(args)
                require('luasnip').lsp_expand(args.body)
              end
            '';
            mapping = {
              "<Tab>" =
                "cmp.mapping(cmp.mapping.select_next_item(), {'i', 's'})";
              "<S-Tab>" =
                "cmp.mapping(cmp.mapping.select_prev_item(), {'i', 's'})";
              "<C-j>" = "cmp.mapping.select_next_item()";
              "<C-k>" = "cmp.mapping.select_prev_item()";
              "<C-e>" = "cmp.mapping.abort()";
              "<C-b>" = "cmp.mapping.scroll_docs(-4)";
              "<C-f>" = "cmp.mapping.scroll_docs(4)";
              "<C-Space>" = "cmp.mapping.complete()";
              "<CR>" = "cmp.mapping.confirm({ select = false })";
              "<S-CR>" =
                "cmp.mapping.confirm({ behavior = cmp.ConfirmBehavior.Replace, select = true })";
            };
            window = {
              completion.scrollbar = true;
              documentation.border = "single";
            };
          };
        };

        telescope = {
          enable = true;
          keymaps = {
            "<leader>g" = "live_grep";
            "<leader>b" = "buffers";
            "<leader>f" = "find_files";
          };
        };

        conform-nvim = {
          enable = true;
          settings = {
            luaConfig.post = ''
              vim.keymap.set({ "n", "v" }, "<leader>mp", function()
                conform.format({
                  lsp_fallback = true,
                  async = false,
                  timeout_ms = 500
                })
              end)
            '';
            lsp_fallback = true;
            formatters_by_ft = {
              "_" = [ "trim_whitespace" ];
              nix = [ "nixfmt" ];
              haskell = [ "ormolu" ];
              rust = [ "rustfmt" ];
              c = [ "clang-format" ];
              cpp = [ "clang-format" ];
              lua = [ "stylua" ];
              python = [ "black" ];
              sh = [ "shellcheck" "shellharden" "shfmt" ];
              yaml = [ "prettierd" ];
              html = [ "prettierd" ];
              json = [ "prettierd" ];
              css = [ "prettierd" ];
            };
            formatters = {
              nixfmt.command = "${pkgs.nixfmt-rfc-style}/bin/nixfmt";
              "clang-format".command = "${pkgs.clang-tools}/bin/clang-format";
              prettierd.command = "${pkgs.prettierd}/bin/prettierd";
              ormolu.command = "${pkgs.ormolu}/bin/ormolu";
              rustfmt.command = "${pkgs.rustfmt}/bin/rustfmt";
              stylua.command = "${pkgs.stylua}/bin/stylua";
              black.command = "${pkgs.black}/bin/black";
              shellcheck.command = "${pkgs.shellcheck}/bin/shellcheck";
              shellharden.command = "${pkgs.shellharden}/bin/shellharden";
              shfmt.command = "${pkgs.shfmt}/bin/shfmt";
            };
          };
        };

        nvim-tree = {
          enable = true;
          autoReloadOnWrite = true;
          sortBy = "name";
        };

        undotree = {
          enable = true;
          settings = {
            CursorLine = true;
            DiffAutoOpen = true;
            DiffCommand = "diff";
            DiffpanelHeight = 10;
            HelpLine = true;
            HighlightChangedText = true;
            HighlightChangedWithSign = true;
            HighlightSyntaxAdd = "DiffAdd";
            HighlightSyntaxChange = "DiffChange";
            HighlightSyntaxDel = "DiffDelete";
            RelativeTimestamp = true;
            SetFocusWhenToggle = true;
            ShortIndicators = false;
            SplitWidth = 40;
            TreeNodeShape = "*";
            TreeReturnShape = "\\";
            TreeSplitShape = "/";
            TreeVertShape = "|";
            WindowLayout = 4;
          };
        };

        presence-nvim = {
          enable = true;
          neovimImageText = "buh...";
          extraOptions.main_image = "https://files.catbox.moe/ytspyv.png";
          package = pkgs.vimPlugins.presence-nvim.overrideAttrs (oldAttrs: {
            src = pkgs.fetchFromGitHub {
              owner = "andweeb";
              repo = "presence.nvim";
              rev = "0dbcdebb2f1feeecdad7a6286a50575bf07d7533";
              sha256 = "sha256-ajiA/2zVJ/aRBW69DDmNT/c/S09moE5bl8ziZQ+9OBs=";
            };
          });
        };

      };

      extraPlugins = with pkgs.vimPlugins; [

        {
          plugin = comment-nvim;
          config = ''lua require("Comment").setup()'';
        }

        { plugin = supertab; }

      ];

      colorschemes.palette = let

        palette = {
          base00 = "#1C1C1B"; # background
          base07 = "#FFFFFD"; # most text
          base0F = "#EB7757"; # numbers
          base01 = "#3C3836"; # highlight row & scrollbar
          base03 = "#665C54"; # comments
          base04 = "#72837C"; # line numbers
          base05 = "#BDAE93"; # operators & delimiters
          base08 = "#FBF1C7"; # functions
          base09 = "#B2DBC7"; # illuminate
          base0A = "#A7D6AA"; # ! or booleans
          base06 = "#D5C4A1"; # idk
          base0B = "#A3CFC4"; # idk
          base0C = "#8BCCA5"; # idk
          base0D = "#DA9B58"; # idk
          base0E = "#93C2AB"; # idk
          base02 = "#504945"; # idk
        };

      in {

        enable = true;
        settings = {
          palettes = {
            main = "main_tempest";
            accent = "accent_tempest";
            state = "state_tempest";
          };
          custom_palettes = {
            main = {
              main_tempest = {
                color0 = "${palette.base00}";
                color1 = "${palette.base01}";
                color2 = "${palette.base0A}";
                color3 = "${palette.base04}";
                color4 = "${palette.base05}";
                color5 = "${palette.base06}";
                color6 = "${palette.base03}";
                color7 = "${palette.base08}";
                color8 = "${palette.base07}";
              };
            };
            accent = {
              accent_tempest = {
                accent0 = "${palette.base0F}";
                accent1 = "${palette.base09}";
                accent2 = "${palette.base0E}";
                accent3 = "${palette.base0D}";
                accent4 = "${palette.base0A}";
                accent5 = "${palette.base0B}";
                accent6 = "${palette.base0C}";
              };
            };
            state = {
              state_tempest = {
                hint = "${palette.base0C}";
                info = "${palette.base0D}";
                ok = "${palette.base0B}";
                warning = "${palette.base0A}";
                error = "${palette.base0F}";
              };
            };
          };
        };

        luaConfig.post = ''
          local colors = require("palette.theme")
          require("palette").setup({
            custom_highlight_group = "Corrections",
            custom_highlight_groups = {
              Corrections = {
          	{
          	  "@tag.builtin.tsx",
          	  colors.accent.accent5,
          	},
          	{
          	  "@tag.tsx",
          	  colors.accent.accent6,
          	},
          	{
          	  "@tag.attribute.tsx",
          	  colors.accent.accent2,
          	},
          	{
          	  "Search",
          	  colors.accent.accent3,
          	},
          	{
          	  "Keyword",
          	  colors.accent.accent2,
          	},
          	{
          	  "VisualMode",
          	  colors.accent.accent2,
          	},
          	{
          	  "Directory",
          	  colors.accent.accent2,
          	},
          	{
          	  "Special",
          	  colors.main.color5,
          	},
          	{
          	  "SpecialChar",
          	  colors.main.color5,
          	},
          	{
          	  "Type",
          	  colors.accent.accent5,
          	},
          	{
          	  "String",
          	  colors.main.color4,
          	},
          	{
          	  "@variable",
          	  colors.accent.accent4,
          	},
              },
            },
          })
          vim.cmd([[colorscheme palette]])
        '';

      };
    };
  };
}
