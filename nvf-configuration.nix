{
  config,
  lib,
  pkgs,
  ...
}:

{
  config.vim = {
    enableLuaLoader = true;
    theme.name = "everforest";
    globals = {
      loaded_netrw = 1;
      loaded_netrwPlugin = 1;
      mapleader = " ";
    };
    viAlias = true;
    vimAlias = true;
    lsp = {
      enable = true;
    };
    # git.neogit.enable = true;
    treesitter.enable = true;
    clipboard.enable = true;
    clipboard.providers.wl-copy.enable = true;
    clipboard.registers = "unnamedplus";

    options = {
      updatetime = 1000;
      ignorecase = true;
      smartcase = false;
      scrolloff = 50;
    };

    lazy = {
      enable = true;
      plugins = {
        "yanky.nvim" = {
          package = pkgs.vimPlugins.yanky-nvim;
          event = "TextYankPost";
          setupModule = "yanky";
          setupOpts = {
            ring.storage = "shada";
            mapping = {
              prev = "<c-p>";
              next = "<c-n>";
            };
          };
        };
        "toggleterm.nvim" = {
          package = pkgs.vimPlugins.toggleterm-nvim;
          cmd = [ "ToggleTerm" ];
          keys = [
            {
              key = "<c-\\>";
              mode = [
                "n"
                "i"
                "t"
              ];
              action = "<cmd>silent! write | ToggleTerm<CR>";
              noremap = true;
              silent = true;
              desc = "Save & Toggle Terminal";
            }
          ];
          setupModule = "toggleterm";
          setupOpts = {
            direction = "float";
            persist_size = true;
            shade_terminals = true;
            float_opts = {
              border = "single";
            };
          };
        };
        "which-key.nvim" = {
          package = pkgs.vimPlugins.which-key-nvim;
          event = "VimEnter";
          setupModule = "which-key";
          setupOpts = { };
        };
        "cheatsheet.nvim" = {
          package = pkgs.vimPlugins.cheatsheet-nvim;
          cmd = [ "Cheatsheet" ];
        };
        "highlight-undo.nvim" = {
          package = pkgs.vimPlugins.highlight-undo-nvim;
          event = "BufReadPre";
        };
        "nvim-cursorline" = {
          package = pkgs.vimPlugins.nvim-cursorline;
          event = "BufReadPre";
          setupModule = "nvim-cursorline";
        };
        "rainbow-delimiters.nvim" = {
          package = pkgs.vimPlugins.rainbow-delimiters-nvim;
          event = "BufReadPre";
          after = ''require('rainbow-delimiters.setup').setup({}) '';
        };
        "nvim-surround" = {
          package = pkgs.vimPlugins.nvim-surround;
          event = "BufReadPre";
          setupModule = "nvim-surround";
          setupOpts = { };
        };
        "conform.nvim" = {
          package = pkgs.vimPlugins.conform-nvim;
          event = [
            "BufWritePre"
            "BufNewFile"
            "FileType"
          ];
          setupModule = "conform";
          setupOpts = {
            format_on_save = {
              lsp_format = "fallback";
              timeout_ms = 500;
            };
            formatters_by_ft = {
              lua = [ "stylua" ];
              nix = [ "nixpkgs-fmt" ];
              python = [
                "isort"
                "black"
              ];
              rust = [ "rustfmt" ];
              zig = [ "zigfmt" ];
            };
          };
        };
        "gitsigns.nvim" = {
          package = pkgs.vimPlugins.gitsigns-nvim;
          event = [
            "BufReadPost"
            "BufNewFile"
          ];
          setupModule = "gitsigns";
          setupOpts = { };
        };
      };
    };

    telescope = {
      enable = true;
      mappings = {
        # === Telescope direct common actions ===
        findFiles = "<leader>f"; # Find files
        liveGrep = "<leader>g"; # Live grep

        # === Other Telescope actions under <leader>t prefix (2 keystrokes) ===
        buffers = "<leader>tb"; # Buffers
        helpTags = "<leader>th"; # Help tags
        diagnostics = "<leader>td"; # Diagnostics (Workspace)
        resume = "<leader>ts"; # Resume (Session)

        gitBranches = "<leader>tB"; # Git Branches (B for branches)
        gitStatus = "<leader>tS"; # Git Status (S for status)

        lspReferences = "<leader>tr"; # LSP References (r for references)
        lspDefinitions = "<leader>tD"; # LSP Definitions (D for definitions)
        lspImplementations = "<leader>ti"; # LSP Implementations (i for implementations)
        lspDocumentSymbols = "<leader>to"; # LSP Document Symbols (o for outline/symbols)
        lspWorkspaceSymbols = "<leader>tw"; # LSP Workspace Symbols (w for workspace)
        lspTypeDefinitions = "<leader>tT"; # LSP Type Definitions (T for Type)

        # === Disable unwanted default mappings from the nvf module ===
        open = null;
        findProjects = null;
        gitCommits = null;
        gitBufferCommits = null;
        gitStash = null;
        treesitter = null;
      };
    };

    keymaps = [
      # Non-leader specific utility maps
      {
        key = "<C-S>";
        mode = [ "n" ];
        action = "<cmd>execute 'normal! ' . float2nr(winheight(0)/2) . '<C-d>'<CR>";
        silent = true;
        desc = "Scroll half page down";
      }

      # ===== LSP Global Keybinds (Non-Leader, strong conventions) =====
      {
        key = "K";
        mode = [ "n" ];
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: Hover";
      }
      {
        key = "gd";
        mode = [ "n" ];
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: Go to definition";
      }

      # ===== LSP Leader Keybinds (all under <leader>l) =====
      {
        key = "<leader>la";
        mode = [
          "n"
          "v"
        ];
        action = "<cmd>lua vim.lsp.buf.code_action()<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: Code Action";
      }
      {
        key = "<leader>ld";
        mode = "n";
        action = "<cmd>lua vim.lsp.buf.definition()<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: Definition";
      }
      {
        key = "<leader>lf";
        mode = [
          "n"
          "v"
        ];
        action = "<cmd>lua vim.lsp.buf.format({ async = true })<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: Format";
      }
      {
        key = "<leader>lh";
        mode = "n";
        action = "<cmd>lua vim.lsp.buf.hover()<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: Hover";
      }
      {
        key = "<leader>li";
        mode = "n";
        action = "<cmd>lua vim.lsp.buf.implementation()<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: Implementation";
      }
      {
        key = "<leader>lk";
        mode = [ "n" ];
        action = "<cmd>lua vim.diagnostic.open_float()<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: Line Diagnostics";
      }
      {
        key = "<leader>ln";
        mode = [ "n" ];
        action = "<cmd>lua vim.diagnostic.goto_next({wrap=false})<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: Next Diagnostic";
      }
      {
        key = "<leader>lp";
        mode = [ "n" ];
        action = "<cmd>lua vim.diagnostic.goto_prev({wrap=false})<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: Previous Diagnostic";
      }
      {
        key = "<leader>lR";
        mode = "n";
        action = "<cmd>lua vim.lsp.buf.references()<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: References";
      }
      {
        key = "<leader>lr";
        mode = "n";
        action = "<cmd>lua vim.lsp.buf.rename()<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: Rename";
      }
      {
        key = "<leader>ls";
        mode = "n";
        action = "<cmd>lua vim.lsp.buf.document_symbol()<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: Document Symbols";
      }
      {
        key = "<leader>lt";
        mode = "n";
        action = "<cmd>lua vim.lsp.buf.type_definition()<CR>";
        noremap = true;
        silent = true;
        desc = "LSP: Type Definition";
      }

      # ===== Disable conflicting/unwanted NVF default mappings =====
      {
        key = "gO";
        mode = "n";
        action = "noop";
        silent = true;
        desc = "NVF gO (LSP Doc Symbols, disabled)";
      }
      {
        key = "gri";
        mode = "n";
        action = "noop";
        silent = true;
        desc = "NVF gri (LSP Implementations, disabled)";
      }
      {
        key = "grr";
        mode = "n";
        action = "noop";
        silent = true;
        desc = "NVF grr (LSP References, disabled)";
      }
      {
        key = "gra";
        mode = [
          "n"
          "x"
        ];
        action = "noop";
        silent = true;
        desc = "NVF gra (LSP Code Action, disabled)";
      } # Matches n and x (visual) modes from map output

      {
        key = "[d";
        mode = "n";
        action = "noop";
        silent = true;
        desc = "NVF [d diagnostic nav (disabled)";
      }
      {
        key = "]d";
        mode = "n";
        action = "noop";
        silent = true;
        desc = "NVF ]d diagnostic nav (disabled)";
      }
    ];

    autocmds = [
      {
        event = [ "FocusLost" ];
        pattern = [ "*" ];
        callback = lib.generators.mkLuaInline ''function() if vim.bo.modifiable and vim.bo.modified and vim.fn.filereadable(vim.fn.expand('%:p')) == 1 then vim.cmd('silent! wall') end end '';
        desc = "Auto-save on focus lost";
      }
      {
        event = [
          "CursorHold"
          "CursorHoldI"
        ];
        pattern = [ "*" ];
        callback = lib.generators.mkLuaInline ''
          function()
            if vim.bo.modifiable and vim.bo.modified and vim.fn.filereadable(vim.fn.expand('%:p')) == 1 then
              vim.cmd('silent! wall')
            end
          end
        '';
        desc = "Auto-save on inactivity";
      }
      {
        event = [ "FileType" ];
        pattern = [ "nix" ];
        command = "setlocal shiftwidth=2 tabstop=2 expandtab";
        desc = "Set Nix indentation to 2 spaces";
      }
      {
        event = [ "FileType" ];
        pattern = [ "markdown" ];
        command = "if &spell | setlocal spell spelllang=en,de | endif";
        desc = "Enable spellcheck for Markdown (if enabled)";
      }
    ];

    languages.typst = {
      enable = true;
      extensions.typst-preview-nvim = {
        enable = true;
        # setupOpts.open_cmd = "chromium --guest %s";
        setupOpts.open_cmd = "librewolf %s";
      };
    };
  };
}
