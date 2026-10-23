-- TODO: not works in Windows Terminal when using nvim in remote servers
local function make_bg_transparent()
  local groups_to_clear = {
    "Normal",
    "NormalNC",
    "NormalFloat",
    "SignColumn",
    "EndOfBuffer",
    "StatusLine",
    "StatusLineNC"
  }

  for _, group in ipairs(groups_to_clear) do
    vim.api.nvim_set_hl(0, group, { bg = "NONE", ctermbg = "NONE", guibg = "NONE" })
  end
end

vim.api.nvim_create_autocmd("ColorScheme", {
  callback = make_bg_transparent,
})
