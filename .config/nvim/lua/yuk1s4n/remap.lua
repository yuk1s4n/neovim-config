vim.g.mapleader = " "
vim.keymap.set("n", "<leader>ww", "<C-w>w")
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
-- vim.keymap.set("n", "<leader>tn", vim.cmd.tabnew)
-- vim.keymap.set("n", "<leader>tc", vim.cmd.tabclose)
-- vim.keymap.set("n", "<leader>tt", ":tabnew | terminal<CR>")

-- In terminal insert mode, escape, then followed by :bd! or :q
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

vim.keymap.set("i", "<Up>", "<nop>")
vim.keymap.set("i", "<Down>", "<nop>")
vim.keymap.set("i", "<Left>", "<nop>")
vim.keymap.set("i", "<Right>", "<nop>")

vim.keymap.set("n", "s", "<nop>")
vim.keymap.set("n", "S", "<nop>")
vim.keymap.set("n", "<leader>it", "<cmd>InspectTree<cr>", { desc = "Inspect treesitter tree" })
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
vim.keymap.set("i", ";fg", "-")
vim.keymap.set("i", ";fgg", "_")
vim.keymap.set("i", "-", "<nop>")
vim.keymap.set("i", "<Enter>", "<nop>")
vim.keymap.set("i", "{<Cr>", "{<Cr>}<Esc>0O")
vim.keymap.set("i", "<C-j>", "<Enter>")

vim.keymap.set("i", ";fj", "[") -- Open Parentheses [
vim.keymap.set("i", ";fjj", "]") -- Close Parentheses [
vim.keymap.set("i", ";fb", "{") -- Open Parenthesee { 
vim.keymap.set("i", ";fbb", "}") -- Close Parenthesee } 
vim.keymap.set("i", ";fr", "(") -- Open Parentheses (
vim.keymap.set("i", ";frr", ")") -- Close Parentheses )
vim.keymap.set("i", ";fB", "{<Cr>}<Esc>0O") -- Parentheses {}

vim.api.nvim_set_keymap('n', '<leader>wr', ':set wrap!<CR>', { noremap = true, silent = true })
-- vim.keymap.set("v", "<C-a>", "ggVG")

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
vim.keymap.set({ "n", "v" }, "<leader>dv", "\"_d")

-- Disable Q in normal mode
vim.keymap.set("n", "Q", "<nop>")

-- Go to the next item in the quickfix list, then center the screen
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- -- Go to the previous, ...
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- -- Go to the prev/next item in the location list (per-window, vs quickfix is global), then center
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- Starts a project-wide search-and-replace for the word under the cursor
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })


vim.keymap.set("n", "<leader><leader>", function()
    vim.cmd("so")
end)

vim.keymap.set("n", "<leader>gc", [[:Gvdiffsplit]])


vim.keymap.set("n", "<leader>yp", function()
    vim.fn.setreg("+", vim.fn.expand("%:p%"))
end)

local high_light_id = nil

local function clear_highlight()
    if high_light_id ~= nil then
        pcall(vim.fn.matchdelete, high_light_id)
        high_light_id = nil
    end
end

local function highlight_word(word)
    if not word or word == "" then
        return
    end

    clear_highlight()

    local pattern = "\\V\\<" .. vim.fn.escape(word, "\\") .. "\\>"

    high_light_id = vim.fn.matchadd("search", pattern)
end

local function highlight_word_under_cursor()
    local word = vim.fn.expand("<cword>")
    highlight_word(word)
end

local function highlight_visual_selection()
    local old_reg = vim.fn.getreg('"')
    local old_regtype = vim.fn.getregtype('"')

    vim.cmd('normal! y')

    local text = vim.fn.getreg('"')

    vim.fn.setreg('"', old_reg, old_regtype)

    text = text:gsub("\n$", "")

    if text == "" or text:find("\n") then
        return
    end

    highlight_word(text)
end

vim.keymap.set("n", "<leader>h", highlight_word_under_cursor, {
    silent = true,
})

vim.keymap.set("v", "<leader>h", function()
    highlight_visual_selection()
end, {
    silent = true,
})

vim.keymap.set({ "n", "v" }, "<leader>nh", clear_highlight, {
    silent = true,
})

vim.keymap.set("n", "<leader>lx", function()
    vim.fn.setloclist(0, {}, "r")
end, { desc = "Clear Location List" })

vim.keymap.set("n", "<leader>lw", [[:lvimgrep /\<<C-r><C-w>\>/ %<Left><Left><Left><Left><Left>]])
