local lspconfig_setup = {
}

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/nvim-cmp"
  },

  config = function()
    require("mason").setup()
    require("mason-lspconfig").setup(lspconfig_setup)

    vim.lsp.config("*", require("cmp_nvim_lsp").default_capabilities())

    vim.lsp.config("clangd", {
      root_markers = { "compile_commands.json", "compile_flags.txt", ".clangd", ".git", "CMakeLists.txt" },
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--header-insertion=iwyu",
        "--completion-style=detailed",
        "--function-arg-placeholders",
        "--fallback-style=llvm"
      }
    })

    vim.lsp.enable({ "clangd" })
  end
}
