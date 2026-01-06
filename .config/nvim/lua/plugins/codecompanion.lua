return {
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    { "MeanderingProgrammer/render-markdown.nvim", ft = { "codecompanion", "markdown" } },
  },
  keys = {
    { "<leader>aa", "<cmd>CodeCompanionActions<cr>", mode = { "n", "v" }, desc = "AI Actions" },
    { "<leader>ac", "<cmd>CodeCompanionChat Toggle<cr>", mode = { "n", "v" }, desc = "AI Chat" },
    { "ga", "<cmd>CodeCompanionChat Add<cr>", mode = "v", desc = "Add to AI Chat" },
  },
  config = function()
    require("codecompanion").setup({
      strategies = {
        chat = { adapter = "copilot" },
        inline = {
          adapter = "copilot",
          keymaps = {
            accept_change = {
              modes = { n = "ga" }, -- 'ga' to accept
              index = 1,
              callback = "keymaps.accept_change",
              description = "Accept the diff",
            },
            reject_change = {
              modes = { n = "gr" }, -- 'gr' to reject
              index = 2,
              callback = "keymaps.reject_change",
              description = "Reject the diff",
            },
          },
        },
      },
      display = {
        diff = {
          provider = "mini_diff", -- This tells it to use mini.diff
        },
      },
      prompt_library = {
        markdown = {
          dirs = { "~/.config/nvim/codecompanion_prompts" },
        },
      },
    })
  end,
}
