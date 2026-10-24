return {
  "folke/todo-comments.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim"
  },

  opts = {
    keywords = {
      FIX = {
        color = "error",
        alt = { "FIXME" }
      },
      TODO = { color = "info" },
      HACK = { color = "warning" },
      WARN = { color = "warning", alt = { "XXX" } },
      NOTE = { color = "hint", alt = { "NOTE" } },
    }
  }

}
