-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")
vim.api.nvim_create_autocmd("BufWritePost", {
  group = vim.api.nvim_create_augroup("VibeMap", { clear = true }),
  callback = function()
    local root = vim.fs.root(0, ".git")
    if not root then
      return
    end

    -- Renamed to ARCHITECTURE.md as requested
    local cmd = string.format(
      "echo '# Project Architecture' > %s/ARCHITECTURE.md && tree -I 'node_modules|.git|dist' %s >> %s/ARCHITECTURE.md",
      root,
      root,
      root
    )
    vim.fn.jobstart({ "sh", "-c", cmd })
  end,
})
