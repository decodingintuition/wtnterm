return {
  "folke/zen-mode.nvim",
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", mode = "n", desc = "Toggle Zen Mode" },
  },
  opts = {
    window = {
      width = 80,
      options = {
        signcolumn = "no",
        number = false,
        relativenumber = false,
        cursorline = false,
        cursorcolumn = false,
        foldcolumn = "0",
        list = false,
      },
    },
    on_open = function()
      local explorer = Snacks.picker.get({ source = "explorer" })[1]
      if explorer then
        explorer:close()
      end
      vim.opt_local.wrap = true
      -- zen-mode.nvim uses \b as OSC terminator which is wrong; send correct sequence manually
      local stdout = vim.loop.new_tty(1, false)
      stdout:write(
        ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=ZEN_MODE=%s\x07\x1b\\"):format(
          vim.fn.system({ "base64" }, "5")
        )
      )
    end,
    on_close = function()
      vim.opt_local.wrap = false
      local stdout = vim.loop.new_tty(1, false)
      stdout:write(
        ("\x1bPtmux;\x1b\x1b]1337;SetUserVar=ZEN_MODE=%s\x07\x1b\\"):format(
          vim.fn.system({ "base64" }, "0")
        )
      )
    end,
    plugins = {
      options = {
        enabled = true,
        ruler = false,
      },
      wezterm = {
        enabled = false,
      },
    },
  }
}
