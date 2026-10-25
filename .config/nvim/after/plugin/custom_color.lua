vim.api.nvim_set_hl(0, "Normal", { fg = "#000000" })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#000000" })
vim.api.nvim_set_hl(0, "GitSignsAdd", { fg = "#00ff00" })
vim.api.nvim_set_hl(0, "GitSignsChange", { fg = "#ff69b4" })

vim.api.nvim_set_hl(0, "GitSignsAddStaged", { fg = "#00ff00" })
vim.api.nvim_set_hl(0, "GitSignsChangeStaged", { fg = "#ff69b4" })
-- Custom Git diff colors for a white terminal background
local function set_diff_colors()
	-- Added lines: dark green on light green
	vim.api.nvim_set_hl(0, "DiffAdd", {
		fg = "#166534",
		bg = "#e8f5e9",
	})

	-- Deleted lines: dark red on light red
	vim.api.nvim_set_hl(0, "DiffDelete", {
		fg = "#991b1b",
		bg = "#fde8e7",
	})

	-- Modified lines: dark amber on light yellow
	vim.api.nvim_set_hl(0, "DiffChange", {
		fg = "#854d0e",
		bg = "#fff7d6",
	})

	-- Exact text differences within changed lines
	vim.api.nvim_set_hl(0, "DiffText", {
		fg = "#713f12",
		bg = "#fde68a",
		bold = true,
	})

	-- Syntax highlight groups used by diff text
	vim.api.nvim_set_hl(0, "diffAdded", {
		fg = "#166534",
		bg = "#e8f5e9",
	})

	vim.api.nvim_set_hl(0, "diffRemoved", {
		fg = "#991b1b",
		bg = "#fde8e7",
	})

	vim.api.nvim_set_hl(0, "diffChanged", {
		fg = "#854d0e",
		bg = "#fff7d6",
	})
end

-- Custom foreground colors
local function set_normal_colors()
	vim.api.nvim_set_hl(0, "Normal", {
		fg = "#000000",
	})

	vim.api.nvim_set_hl(0, "NormalFloat", {
		fg = "#000000",
	})
end

-- Purple border for floating windows
local function set_float_border_color()
	vim.api.nvim_set_hl(0, "FloatBorder", {
		fg = "#A855F7",
		bg = "NONE",
	})

	-- Neovim versions that support the newer LSP highlight groups
	vim.api.nvim_set_hl(0, "LspFloatWinBorder", {
		fg = "#A855F7",
		bg = "NONE",
	})
end

-- Apply all custom highlights
local function set_custom_colors()
	set_diff_colors()
	set_normal_colors()
	set_float_border_color()
	-- -- Highlight the column under the cursor.
	-- vim.api.nvim_set_hl(0, "CursorColumn", {
	--     bg = "#E6DDF0",
	-- })
end

set_custom_colors()

-- Reapply after a colorscheme changes highlight groups
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("UserCustomHighlights", { clear = true }),
	callback = set_custom_colors,
})
