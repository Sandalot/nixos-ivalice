{ config, pkgs, ... }:
{
  # Neovim
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
    
    extraPackages = with pkgs; [
      wl-clipboard
    ];

    plugins = with pkgs.vimPlugins; [
      nvim-web-devicons
      nvim-tree-lua
      nvim-autopairs
      nvim-treesitter
      gitsigns-nvim
    ];

    initLua = ''
      vim.opt.number = true
      vim.opt.relativenumber = false
      vim.opt.termguicolors = false
      vim.opt.fillchars = { eob = " " }
      vim.opt.clipboard = "unnamedplus"

      require("nvim-autopairs").setup()
      require("gitsigns").setup()

      vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

      vim.api.nvim_create_autocmd("BufReadPost", { callback = function()
        local mark = vim.api.nvim_buf_get_mark(0, '"')
        if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
          vim.api.nvim_win_set_cursor(0, mark)
        end
      end })

      require("nvim-tree").setup({ view = { width = 30 } })
      vim.api.nvim_create_autocmd("VimEnter", { callback = function()
        require("nvim-tree.api").tree.open()
      end })
    '';
  };
}
