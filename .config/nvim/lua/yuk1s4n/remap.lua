vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- In terminal insert mode, escape, then followed by :bd! or :q
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("i", "<Up>", "<nop>")
vim.keymap.set("i", "<Down>", "<nop>")
vim.keymap.set("i", "<Left>", "<nop>")
vim.keymap.set("i", "<Right>", "<nop>")

vim.keymap.set("n", "s", "<nop>")
vim.keymap.set("n", "S", "<nop>")
vim.keymap.set("n", "<leader>it", "<cmd>InspectTree<cr>", { desc = "Inspect treesitter tree" })
vim.keymap.set("n", "<leader>bf", "<cmd>Telescope buffers<cr>", { desc = "List of buffers and preview" })
vim.keymap.set("n", "<leader>mo", function()
	if vim.opt.mouse:get() == "a" then
		vim.opt.mouse = ""
		print("Mouse disabled")
	else
		vim.opt.mouse = "a"
		print("Mouse enabled")
	end
end, { desc = "Toggle mouse" })

vim.keymap.set("i", ";fe", "=")
vim.keymap.set("i", ";fee", "+")
-- vim.keymap.set("i", "-", "<nop>")
vim.keymap.set("i", "<Enter>", "<nop>")
vim.keymap.set("i", "{<Cr>", "{<Cr>}<Esc>0O")
vim.keymap.set("i", "<C-j>", "<Enter>")

vim.keymap.set("i", ";fj", "\\") -- Open Parentheses [
vim.keymap.set("i", ";fjj", "|") -- Close Parentheses [
vim.keymap.set("i", ";fb", "{") -- Open Parenthesee {
vim.keymap.set("i", ";fB", "{<Cr>}<Esc>0O") -- Parentheses {}

vim.api.nvim_set_keymap("n", "<leader>wr", ":set wrap!<CR>", { noremap = true, silent = true })

-- In visual mode, move the selected block (like Alt + Up/Down in vscode)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- vim.api.nvim_set_keymap("n", "<leader>tf", "<Plug>PlenaryTestFile", { noremap = false, silent = false })

-- Joins the line below into the current line without moving the cursor
vim.keymap.set("n", "J", "mzJ`z")

-- Half-page scroll up/down + recentering
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- Jump to the next/previous search match, then center the screen and open any folds
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- Format the current paragraph and cursor does not jump
vim.keymap.set("n", "<leader>=", "ma=ap'a")

-- In visual modes, paste over a selection without overwriting your clipboard register
vim.keymap.set("n", "<leader>lb", function()
	require("dap").list_breakpoints()
	vim.cmd("copen")
end, { desc = "List breakpoints" })

vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank the selection/motion into system clipboard (e.g. <leader>yw: yank word, <leader>y$: yank to end of line)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- Yank the entire line into system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete into the void register -- Nothing gets overwritten in your clipboard.
vim.keymap.set({ "n", "v" }, "<leader>dv", '"_d')

-- Disable Q in normal mode
vim.keymap.set("n", "Q", "<nop>")

-- Go to the next item in the quickfix list, then center the screen
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- -- Go to the previous, ...
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")

-- Starts a project-wide search-and-replace for the word under the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

vim.keymap.set("n", "<leader>gc", [[:Gvdiffsplit]])

vim.keymap.set("n", "<C-a>", "<C-w>")
vim.keymap.set("i", "<C-d>", "<C-w>")
vim.keymap.set("i", "<C-w>", "<C-a>")
vim.keymap.set("c", "<C-a>", "<C-b>")

vim.keymap.set("i", "<C-k>", "<C-o>D", {
	desc = "Delete to end of line",
})

vim.keymap.set("i", "<C-g>", "<C-o>dw", {
	desc = "Delete word forward",
})

vim.keymap.set("c", "<C-g>", function()
	return "<C-Right><C-w>"
end, {
	expr = true,
	desc = "Delete word forward",
})

vim.keymap.set("c", "<C-k>", function()
	return vim.fn.getcmdline():sub(1, vim.fn.getcmdpos() - 1)
end, {
	expr = true,
	desc = "Delete to end of line",
})
