-- Spider subword motions (camelCase, snake_case, ...). OFF by default.
-- <leader>ws toggles w/e/b/ge in normal and visual mode.
return {
  "chrisgrieser/nvim-spider",
  keys = {
    {
      "<leader>ws",
      function()
        vim.g.spider_enabled = not (vim.g.spider_enabled or false)

        for _, motion in ipairs({ "w", "e", "b", "ge" }) do
          if vim.g.spider_enabled then
            vim.keymap.set({ "n", "x" }, motion, function()
              require("spider").motion(motion)
            end, { desc = "Spider-" .. motion })
          else
            pcall(vim.keymap.del, { "n", "x" }, motion)
          end
        end

        vim.notify("Spider motions: " .. (vim.g.spider_enabled and "ON" or "OFF"))
      end,
      desc = "Toggle spider subword motions",
    },
  },
}
