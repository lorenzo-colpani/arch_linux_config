return {
  "chrisgrieser/nvim-spider",
  keys = {
    {
      "e",
      "<cmd>lua require('spider').motion('e')<cr>",
      mode = { "x" }, -- "x" is Visual Mode only
      desc = "Spider-e (Visual Mode)",
    },
  },
}
