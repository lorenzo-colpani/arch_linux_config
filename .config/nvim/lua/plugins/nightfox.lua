return {
  {
    "EdenEast/nightfox.nvim",
    lazy = false, -- Load during startup
    priority = 1000, -- Ensure it loads before other plugins
    config = function()
      -- This line actually applies the theme
      vim.cmd([[colorscheme duskfox]])
    end,
  },

  -- Configure LazyVim to use it as the default
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "duskfox",
    },
  },
}
