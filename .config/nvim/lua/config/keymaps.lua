-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

vim.keymap.set("n", "<leader>rc", function()
  vim.cmd("write")
  local file = vim.fn.expand("%")

  -- We use 'zsh -ic' (interactive) so it loads your .zshrc functions
  require("lazyvim.util").terminal.open({ "zsh", "-ic", "rc " .. file .. "; exec zsh" }, {
    cwd = vim.fn.getcwd(),
    ctrl_hjkl = false,
  })
end, { desc = "Compile and Run C via Zsh Function" })
