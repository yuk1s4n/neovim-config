-- =========================================
-- Line numbers
-- =========================================

vim.opt.cursorline = true

local function set_line_number_colors()
	-- Normal line numbers
	vim.api.nvim_set_hl(0, "LineNr", {
		fg = "#6272A4",
	})

	-- Line numbers above and below the cursor
	vim.api.nvim_set_hl(0, "LineNrAbove", {
		fg = "#6272A4",
	})

	vim.api.nvim_set_hl(0, "LineNrBelow", {
		fg = "#6272A4",
	})

	-- Current line number
	vim.api.nvim_set_hl(0, "CursorLineNr", {
		fg = "#F1FA8C",
		bold = true,
	})
end

-- =========================================
-- Cursor line
-- =========================================

local function set_cursorline_colors()
	vim.api.nvim_set_hl(0, "CursorLine", {
		bg = "#383838",
		underline = true,
		sp = "#B0B0B0",
	})
end

-- =========================================
-- Normal text and UI
-- =========================================

local function set_normal_colors()
	-- Keep the terminal background visible
	vim.api.nvim_set_hl(0, "Normal", {
		fg = "#F8F8F2",
		bg = "NONE",
	})

	-- Floating windows: dark background for readability
	vim.api.nvim_set_hl(0, "NormalFloat", {
		fg = "#F8F8F2",
		bg = "#111018",
	})

	-- End-of-line markers and other non-text characters
	vim.api.nvim_set_hl(0, "NonText", {
		fg = "#FF5C57",
	})
end

-- =========================================
-- Git signs
-- =========================================

local function set_git_colors()
	-- Added lines
	vim.api.nvim_set_hl(0, "GitSignsAdd", {
		fg = "#50FA7B",
	})

	-- Modified lines
	vim.api.nvim_set_hl(0, "GitSignsChange", {
		fg = "#FF79C6",
	})

	-- Staged additions
	vim.api.nvim_set_hl(0, "GitSignsAddStaged", {
		fg = "#50FA7B",
	})

	-- Staged modifications
	vim.api.nvim_set_hl(0, "GitSignsChangeStaged", {
		fg = "#FF79C6",
	})
end

-- =========================================
-- Git diff colors
-- =========================================

local function set_diff_colors()
	-- Added lines
	vim.api.nvim_set_hl(0, "DiffAdd", {
		fg = "#8BE9A0",
		bg = "#173B2C",
	})

	-- Deleted lines
	vim.api.nvim_set_hl(0, "DiffDelete", {
		fg = "#FF8B8B",
		bg = "#48202A",
	})

	-- Modified lines
	vim.api.nvim_set_hl(0, "DiffChange", {
		fg = "#F1FA8C",
		bg = "#3D3517",
	})

	-- Exact changes within modified lines
	vim.api.nvim_set_hl(0, "DiffText", {
		fg = "#FFFFFF",
		bg = "#66501B",
		bold = true,
	})

	-- Syntax highlight groups used by diff views
	vim.api.nvim_set_hl(0, "diffAdded", {
		fg = "#8BE9A0",
		bg = "#173B2C",
	})

	vim.api.nvim_set_hl(0, "diffRemoved", {
		fg = "#FF8B8B",
		bg = "#48202A",
	})

	vim.api.nvim_set_hl(0, "diffChanged", {
		fg = "#F1FA8C",
		bg = "#3D3517",
	})
end

-- =========================================
-- Floating window borders
-- =========================================

local function set_float_border_color()
	vim.api.nvim_set_hl(0, "FloatBorder", {
		fg = "#BD93F9",
		bg = "NONE",
	})

	vim.api.nvim_set_hl(0, "LspFloatWinBorder", {
		fg = "#BD93F9",
		bg = "NONE",
	})
end

-- =========================================
-- Apply all custom highlights
-- =========================================

local function set_custom_colors()
	set_line_number_colors()
	set_cursorline_colors()
	set_normal_colors()
	set_git_colors()
	set_diff_colors()
	set_float_border_color()
end

set_custom_colors()

-- Reapply custom colors after changing colorschemes
vim.api.nvim_create_autocmd("ColorScheme", {
	group = vim.api.nvim_create_augroup("UserCustomHighlights", { clear = true }),
	callback = set_custom_colors,
})
