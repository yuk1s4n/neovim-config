require("yuk1s4n")
-- require("yuk1s4n.lazy")
-- require("yuk1s4n.lsp")

-- Normal line numbers
vim.api.nvim_set_hl(0, "LineNr", { fg = "#5eacd3" })

-- Current line number (where your cursor is)
vim.api.nvim_set_hl(0, "LineNrAbove", { fg = "#ff6b6b" })
vim.api.nvim_set_hl(0, "LineNrBelow", { fg = "#ff6b6b" })

-- CursorLineNr = the actual current line number
-- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#ffffff", bold = true })

vim.opt.cursorline = true
vim.api.nvim_set_hl(0, "CursorLine", { underline = true, sp = "#ffffff" })
-- vim.api.nvim_set_hl(0, "CursorLine", { bg = "#2a2a2a" })   -- the line background
-- vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#FFD700", bold = true })  -- the line number
-- vim.api.nvim_create_autocmd("ColorScheme", {
--     pattern = "*",
--     callback = function()
--         vim.cmd("syntax off")
--     end,
-- })

vim.cmd("syntax off")
