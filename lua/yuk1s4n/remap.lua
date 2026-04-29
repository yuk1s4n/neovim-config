vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- In terminal insert mode, escape, then followed by :bd! or :q
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("i", "<Up>", "<nop>")
vim.keymap.set("i", "<Down>", "<nop>")
vim.keymap.set("i", "<Left>", "<nop>")
vim.keymap.set("i", "<Right>", "<nop>")

vim.keymap.set("v", "<C-a>", "ggVG")

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
vim.keymap.set("n", "=ap", "ma=ap'a")

-- Restart the LSP server
-- vim.keymap.set("n", "<leader>zig", "<cmd>LspRestart<cr>")

-- vim.keymap.set("n", "<leader>vwm", function()
--     require("vim-with-me").StartVimWithMe()
-- end)
-- vim.keymap.set("n", "<leader>svwm", function()
--     require("vim-with-me").StopVimWithMe()
-- end)
-- vim.keymap.set("n", "<leader>lt", function()
--     vim.cmd [[ PlenaryBustedFile % ]]
-- end)

-- In visual modes, paste over a selection without overwriting your clipboard register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- Yank the selection/motion into system clipboard (e.g. <leader>yw: yank word, <leader>y$: yank to end of line)
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
-- Yank the entire line into system clipboard
vim.keymap.set("n", "<leader>Y", [["+Y]])

-- Delete into the void register -- Nothing gets overwritten in your clipboard.
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")

-- Disable Q in normal mode
vim.keymap.set("n", "Q", "<nop>")

-- Tmux integration
-- Opens a new tmux window running a custom tmux-sessionizer scipt
-- vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
-- vim.keymap.set("n", "<M-h>", "<cmd>silent !tmux-sessionizer -s 0 --vsplit<CR>")
-- vim.keymap.set("n", "<M-H>", "<cmd>silent !tmux neww tmux-sessionizer -s 0<CR>")

-- Go to the next item in the quickfix list, then center the screen
vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- Go to the previous, ...
vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- Go to the prev/next item in the location list (per-window, vs quickfix is global), then center
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Starts a project-wide search-and-replace for the word under the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

-- vim.keymap.set(
--     "n",
--     "<leader>ee",
--     "oif err != nil {<CR>}<Esc>Oreturn err<Esc>"
-- )
--
-- vim.keymap.set(
--     "n",
--     "<leader>ea",
--     "oassert.NoError(err, \"\")<Esc>F\";a"
-- )
--
-- vim.keymap.set(
--     "n",
--     "<leader>ef",
--     "oif err != nil {<CR>}<Esc>Olog.Fatalf(\"error: %s\\n\", err.Error())<Esc>jj"
-- )
--
-- vim.keymap.set(
--     "n",
--     "<leader>el",
--     "oif err != nil {<CR>}<Esc>O.logger.Error(\"error\", \"error\", err)<Esc>F.;i"
-- )
--
-- vim.keymap.set("n", "<leader>ca", function()
--     require("cellular-automaton").start_animation("make_it_rain")
-- end)

vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)
