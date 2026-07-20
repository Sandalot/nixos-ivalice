{ ... }:
{
  # Fish Shell
  programs.fish.enable = true;

  # Shell Aliases
  environment.shellAliases = {
    ls  = "eza --icons";
    ll  = "eza -l --icons";
    la  = "eza -a --icons";
    lla = "eza -la --icons";
  };

  # Nvim config for root
  environment.etc."xdg/nvim/init.lua".text = ''
    vim.opt.number = true
    vim.opt.relativenumber = true
    vim.opt.cursorline = true
    vim.opt.tabstop = 2
    vim.opt.shiftwidth = 2
    vim.opt.expandtab = true
  '';
}
