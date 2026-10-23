return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "Pheon-Dev/pigeon"
  },
  config = function()
    require("lualine").setup({
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },


        lualine_x = {
          function()
            return require("pigeon.ram").ram()
          end,
          "encoding",
          "fileformat",
          "filetype",
        },

        lualine_y = { "progess" },
        lualine_z = { "location" }
        
      }
    })
  end
}
