vim.api.nvim_set_hl(0, "Normal", { fg = "#000000" })
vim.api.nvim_set_hl(0, "NormalFloat", { fg = "#000000" })
vim.opt.guicursor = ""
vim.opt.mouse = "a"

-- Folding seems annoying at present
-- vim.o.foldmethod = "expr"
-- vim.o.foldexpr = "v:lua.vim.treesitter.foldexpr()"
-- vim.o.foldlevel = 3

vim.opt.nu = true
vim.opt.relativenumber = true

vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true

vim.opt.smartindent = true

vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 51

vim.g.undotree_CustomUndotreeCmd = "topleft vertical 30 new"
vim.g.undotree_CustomDiffpanelCmd = "botright 10 new"

-- There is nothing here
vim.opt.list = true

vim.opt.listchars = {
	tab = "» ",
	trail = "·",
	nbsp = "␣",
	eol = "↵",
}

vim.opt.laststatus = 3

vim.api.nvim_create_autocmd({ "WinEnter", "WinLeave" }, {
	callback = function(ev)
		if ev.event == "WinEnter" then
			vim.wo.cursorline = true
		else
			vim.wo.cursorline = false
		end
	end,
})
