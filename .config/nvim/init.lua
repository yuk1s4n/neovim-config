-- This is the config of LamCuToLacLoi
require("yuk1s4n")
-- require("yuk1s4n.lazy")
-- require("yuk1s4n.lsp")

-- Normal line numbers
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5eacd3" })

-- Current line number (where your cursor is)
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#ff6b6b" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#ff6b6b" })


vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", { underline = true, bg = "#DFD2EE", sp = "#000000" })

vim.opt.colorcolumn = "120"

vim.api.nvim_set_hl(0, "ColorColumn", {
    bg = "#ff5c57",
    fg = "#ff5c57",
})

vim.api.nvim_set_hl(0, "NonText", {
    fg = "#ff5c57",
})

-- vim.treesitter.stop()

vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#00ff00" })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#ff69b4" })

vim.api.nvim_set_hl(0, "GitSignsAddStaged", { fg = "#00ff00" })
vim.api.nvim_set_hl(0, "GitSignsChangeStaged", { fg = "#ff69b4" })

vim.opt.laststatus = 3
