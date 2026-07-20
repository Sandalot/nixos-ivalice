{ config, pkgs, lib, ... }:
{
  options.modules.neovim.enable = lib.mkEnableOption "neovim";

  config = lib.mkIf config.modules.neovim.enable {

    # Clipboard Support
    home.packages = with pkgs; [
      wl-clipboard
    ];

    # Neovim
    programs.neovim = {
      enable = true;
      defaultEditor = true;
      viAlias = true;
      vimAlias = true;

      plugins = with pkgs.vimPlugins; [
        nvim-web-devicons
        nvim-tree-lua
        nvim-autopairs
        (nvim-treesitter.withPlugins (p: with p; [
          nix
          lua
          python
          javascript
          typescript
          tsx
          json
          yaml
          toml
          bash
          c
          cpp
          rust
          go
          html
          css
          markdown
          markdown_inline
        ]))

        indent-blankline-nvim
        gitsigns-nvim
        nvim-lspconfig
        nvim-cmp
        cmp-nvim-lsp
        cmp-buffer
        cmp-path
        luasnip
        cmp_luasnip
        telescope-nvim
        plenary-nvim
        lualine-nvim
        which-key-nvim
        bufferline-nvim

        # Coloring using base16-nvim
        base16-nvim
      ];

      initLua = ''
        -- ── Sync Neovim highlights with Terminal ANSI Colors (Matugen) ─────────
        local function get_ansi(color_num, fallback)
          local val = vim.g["terminal_color_" .. color_num]
          return val and val or fallback
        end

        require('base16-colorscheme').setup({
          base00 = get_ansi(0, '#121212'), -- Background
          base01 = get_ansi(18, '#1f1f1f'),
          base02 = get_ansi(19, '#2a2a2a'),
          base03 = get_ansi(8, '#444444'),  -- Comments
          base04 = get_ansi(20, '#666666'),
          base05 = get_ansi(7, '#e0e0e0'),  -- Foreground / Text
          base06 = get_ansi(21, '#efefef'),
          base07 = get_ansi(15, '#ffffff'),
          base08 = get_ansi(1, '#b6666d'),  -- Red
          base09 = get_ansi(16, '#de935f'), -- Orange
          base0A = get_ansi(3, '#f0c674'),  -- Yellow
          base0B = get_ansi(2, '#b5bd68'),  -- Green
          base0C = get_ansi(6, '#8abeb7'),  -- Cyan
          base0D = get_ansi(4, '#81a2be'),  -- Blue
          base0E = get_ansi(5, '#c594c5'),  -- Purple
          base0F = get_ansi(17, '#a3685a')  -- Brown
        })

        -- ── Force Transparent Background (Inherit Matugen Terminal) ───────────
        local bg_groups = { 
          "Normal", 
          "NormalNC", 
          "SignColumn", 
          "FoldColumn", 
          "LineNr", 
          "CursorLineNr" 
        }
        for _, group in ipairs(bg_groups) do
          vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
        end
        -- ── Options ────────────────────────────────────────────────────────────
        vim.opt.number         = true
        vim.opt.relativenumber = false
        vim.opt.termguicolors  = true          -- needed for indent-blankline colours
        vim.opt.fillchars      = { eob = " " }
        vim.opt.clipboard      = "unnamedplus"
        vim.opt.expandtab      = true
        vim.opt.shiftwidth     = 2
        vim.opt.tabstop        = 2
        vim.opt.scrolloff      = 8             -- keep cursor centred-ish
        vim.opt.signcolumn     = "yes"         -- stop layout shifting on diagnostics
        vim.opt.swapfile       = false

        -- ── Bufferline Configuration ──────────────────────────────────────────
        require("bufferline").setup({
          options = {
            mode = "buffers",
            separator_style = "thick",
            offsets = {
              {
                filetype = "NvimTree",
                text = "File Explorer",
                text_align = "center",
                separator = true
              }
            },
            diagnostics = "nvim_lsp",
            groups = {
              items = {} 
            }
          },
          highlights = {
            fill = { bg = "none" },
            background = { bg = "none" },
            buffer_selected = { bg = "none", bold = true, italic = true },
            buffer_visible = { bg = "none" },
            separator = { bg = "none" },
            separator_selected = { bg = "none" },
            separator_visible = { bg = "none" }
          }
        })
        -- ── Updated Keymaps (bufferline specific) ──────────────────────────────
        vim.keymap.set("n", "<C-l>", "<cmd>BufferLineCycleNext<CR>", { desc = "Next buffer" })
        vim.keymap.set("n", "<C-h>", "<cmd>BufferLineCyclePrev<CR>", { desc = "Prev buffer" })
        vim.keymap.set("n", "<C-w>", "<cmd>bdelete<CR>", { desc = "Close buffer" })
        
        -- ── Treesitter ─────────────────────────────────────────────────────────
        require("nvim-treesitter.config").setup({
          highlight    = { enable = true },
          indent       = { enable = true },
        })

        -- ── Indent-blankline (scope lines) ─────────────────────────────────────
        require("ibl").setup({
          indent = { char = "│" },
          scope  = {
            enabled   = true,
            char = "│",
            show_start = true,
            show_end   = false,
            -- scope highlight uses treesitter, so termguicolors must be true
          },
        })

        -- ── Autopairs ──────────────────────────────────────────────────────────
        require("nvim-autopairs").setup()

        -- ── Gitsigns ───────────────────────────────────────────────────────────
        require("gitsigns").setup({
          signs = {
            add          = { text = "▎" },
            change       = { text = "▎" },
            delete       = { text = "" },
            topdelete    = { text = "" },
            changedelete = { text = "▎" },
          },
        })

        -- ── Lualine ────────────────────────────────────────────────────────────
        require("lualine").setup({
          options = {
            icons_enabled        = true,
            theme                = "auto",
            component_separators = { left = "", right = "" },
            section_separators   = { left = "", right = "" },
          },
        })

        -- ── Which-key ──────────────────────────────────────────────────────────
        require("which-key").setup()

        -- ── LSP ────────────────────────────────────────────────────────────────
        local capabilities = require("cmp_nvim_lsp").default_capabilities()
        local servers = { "nixd", "lua_ls", "pyright", "ts_ls", "rust_analyzer" }
        for _, server in ipairs(servers) do
          vim.lsp.config(server, {
            capabilities = capabilities,
          })
          vim.lsp.enable(server)
        end

        vim.keymap.set("n", "[d", vim.diagnostic.goto_prev,  { desc = "Prev diagnostic" })
        vim.keymap.set("n", "]d", vim.diagnostic.goto_next,  { desc = "Next diagnostic" })
        vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show diagnostic" })

        vim.api.nvim_create_autocmd("LspAttach", {
          callback = function(ev)
            local opts = function(desc) return { buffer = ev.buf, desc = desc } end
            vim.keymap.set("n", "gd",         vim.lsp.buf.definition,     opts("Go to definition"))
            vim.keymap.set("n", "K",          vim.lsp.buf.hover,           opts("Hover docs"))
            vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename,          opts("Rename symbol"))
            vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action,      opts("Code action"))
            vim.keymap.set("n", "gr",         vim.lsp.buf.references,      opts("References"))
          end,
        })

        -- ── nvim-cmp (autocompletion) ──────────────────────────────────────────
        local cmp     = require("cmp")
        local luasnip = require("luasnip")

        cmp.setup({
          snippet = {
            expand = function(args) luasnip.lsp_expand(args.body) end,
          },
          mapping = cmp.mapping.preset.insert({
            ["<C-Space>"] = cmp.mapping.complete(),
            ["<CR>"]      = cmp.mapping.confirm({ select = true }),
            ["<Tab>"]     = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_next_item()
              elseif luasnip.expand_or_jumpable() then luasnip.expand_or_jump()
              else fallback() end
            end, { "i", "s" }),
            ["<S-Tab>"]   = cmp.mapping(function(fallback)
              if cmp.visible() then cmp.select_prev_item()
              elseif luasnip.jumpable(-1) then luasnip.jump(-1)
              else fallback() end
            end, { "i", "s" }),
          }),
          sources = cmp.config.sources({
            { name = "nvim_lsp" },
            { name = "luasnip" },
            { name = "buffer" },
            { name = "path" },
          }),
        })

        -- ── Telescope ──────────────────────────────────────────────────────────
        require("telescope").setup()
        local tb = require("telescope.builtin")
        vim.keymap.set("n", "<leader>ff", tb.find_files,  { desc = "Find files" })
        vim.keymap.set("n", "<leader>fg", tb.live_grep,   { desc = "Live grep" })
        vim.keymap.set("n", "<leader>fb", tb.buffers,     { desc = "Buffers" })
        vim.keymap.set("n", "<leader>fh", tb.help_tags,   { desc = "Help tags" })

        -- ── Nvim-tree ──────────────────────────────────────────────────────────
        require("nvim-tree").setup({ view = { width = 30 } })
        vim.keymap.set("n", "<leader>t", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
        vim.api.nvim_create_autocmd("VimEnter", {
          callback = function() require("nvim-tree.api").tree.open() end,
        })

        -- ── Misc keymaps ───────────────────────────────────────────────────────
        vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

        -- Restore last cursor position on file open
        vim.api.nvim_create_autocmd("BufReadPost", {
          callback = function()
            local mark = vim.api.nvim_buf_get_mark(0, '"')
            if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
              vim.api.nvim_win_set_cursor(0, mark)
            end
          end,
        })
      '';
    };
  };
}
