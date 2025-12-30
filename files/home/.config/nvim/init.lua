-- omubuntu Neovim configuration (user stub)
-- omubuntu-managed defaults live at: ~/.config/omubuntu/nvim/init.lua
-- This file is safe to edit; managed defaults may be updated automatically.

local managed = vim.fn.expand("~/.config/omubuntu/nvim/init.lua")
if vim.fn.filereadable(managed) == 1 then
  dofile(managed)
end