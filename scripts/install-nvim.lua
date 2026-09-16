local function install()
  assert(vim.fn.has("nvim-0.12") == 1, "Neovim 0.12 or newer is required")
  local config = vim.fn.stdpath("config")
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not vim.uv.fs_stat(lazypath) then
    local result = vim.system({
      "git", "clone", "--filter=blob:none", "--branch=stable",
      "https://github.com/folke/lazy.nvim.git", lazypath,
    }, { text = true }):wait()
    assert(result.code == 0, result.stderr)
  end

  vim.g.wtnterm_install = true
  vim.opt.loadplugins = true
  vim.opt.runtimepath:prepend(config)
  dofile(config .. "/init.lua")
  require("lazy").restore({ wait = true, show = false })
  for name, plugin in pairs(require("lazy.core.config").plugins) do
    assert(plugin._.installed, "Plugin not installed: " .. name)
    for _, task in ipairs(plugin._.tasks or {}) do
      assert(not task:has_errors(), "Plugin installation failed: " .. name)
    end
  end
  local success = require("nvim-treesitter").install(require("config.parsers")):wait(300000)
  assert(success, "Tree-sitter parser installation failed")
  assert(vim.v.errmsg == "", vim.v.errmsg)
  io.stdout:write("Neovim plugins and parsers installed\n")
  io.stdout:flush()
end

local ok, err = xpcall(install, debug.traceback)
if not ok then
  io.stderr:write(err .. "\n")
  vim.cmd("cquit 1")
end
vim.cmd("qa!")
