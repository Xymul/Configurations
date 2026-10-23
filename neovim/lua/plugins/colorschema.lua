return {
  "ayu-theme/ayu-vim",
  lazy = false,
  priority = 1000,
  opts = {},
  config = function()
    vim.opt.termguicolors = true
    vim.g.ayucolor = "dark"
    vim.cmd([[colorscheme ayu]])
  end
}
