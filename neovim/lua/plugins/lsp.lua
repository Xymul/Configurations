-- TODO: set&config ensure installs: luals, clangd, gopls, typescript-lsp, basepyright
local lspconfig_setup = {
  ensure_installed = { "lua_ls" }
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

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    -- FIXME: it doesn't work
    local on_attach = function(client, bufnr)
      local opts = { buffer = bufnr, silent = true, remap = false, nowait = true }
      vim.keymap.set("n", "<leader>gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "<leader>gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "<leader>gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "<leader>gI", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "<leader>gy", vim.lsp.buf.type_definition, opts)
    end

    vim.lsp.config("*", {
      capabilities = capabilities,
      on_attach = on_attach
    })

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

    -- FIXME: .luarc.json doesn't work
    vim.lsp.config("lua_ls", {
      root_markers = { ".luarc.json", ".luarc.jsonc", ".git" },
      settings = {
        Lua = {
          runtime = "Lua 5.1"
        },

        diagnostics = { globals = { "vim" }, },

        workspace = {
          checkThirdParty = false,
          library = vim.env.VIMRUNTIME
        }
      }
    })

    vim.lsp.config("gopls", {
      root_markers = { "go.work", "go.mod", ".git" },
      cmd = { "gopls" },
      settings = {
        gopls = {
          analyses = {
            unusedparams = true,
          }
        },
        staticcheck = true,
        gofumpt = true,
      }
    })

    vim.lsp.enable({ "clangd", "lua_ls", "gopls" })
  end,
}
