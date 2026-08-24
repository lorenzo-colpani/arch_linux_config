-- Markdown rendering + inline mermaid diagrams (kitty graphics protocol).
-- Mermaid blocks convert via mmdc (pacman: mermaid-cli).
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-tree/nvim-web-devicons" },
    ft = { "markdown" },
    opts = {},
  },
  {
    "folke/snacks.nvim",
    opts = {
      image = {},
    },
  },
}
