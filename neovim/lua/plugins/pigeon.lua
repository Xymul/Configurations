return {
  "Pheon-Dev/pigeon",
  event = "VeryLazy",
  config = function()
    require("pigeon").setup({
      enabled = true,
      os = "linux",
      plugin_manager = "lazy",
    })
  end,
}
