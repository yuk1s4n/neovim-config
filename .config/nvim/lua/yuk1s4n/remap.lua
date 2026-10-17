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
vim.keymap.set("i", ";fg", "-")
vim.keymap.set("i", ";fgg", "_")
-- vim.keymap.set("i", "-", "<nop>")
vim.keymap.set("i", "<Enter>", "<nop>")
vim.keymap.set("i", "{<Cr>", "{<Cr>}<Esc>0O")
vim.keymap.set("i", "<C-j>", "<Enter>")

vim.keymap.set("i", ";fj", "\\") -- Open Parentheses [
vim.keymap.set("i", ";fjj", "|") -- Close Parentheses [
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


                    vim.keymap.set("n", "<leader><leader>", function()
                        vim.cmd("so")
                    end)

                    vim.keymap.set("n", "<leader>gc", [[:Gvdiffsplit]])

                    vim.api.nvim_create_user_command("ChangeMode", function()
                        vim.fn.system({ "chmod", "+x", vim.fn.expand("%:p") })
                        
                        if vim.v.shell_error == 0 then
                            vim.notify("Changed mode: +x", vim.log.levels.INFO)
                        else
                            vim.notify("Failed to change mode", vim.log.levels.ERROR)
                        end
                    end, { desc = "Make current file executable" })

                    -- Paste from system (global) clipboard
                    vim.keymap.set("n", "<leader>v", '"+p', {
                        desc = "Paste from system clipboard",
                    })
                    -- Get path and file name
                    vim.api.nvim_create_user_command("GetPath", function()
                        local text = vim.fn.expand("%:p")
                        vim.fn.setreg("+", text)
                        vim.notify("Copied path: " .. text, vim.log.levels.INFO)
                    end, { desc = "Copy absolute file path" })
                    
                    vim.api.nvim_create_user_command("GetFileName", function()
                        local text = vim.fn.expand("%:t")
                        vim.fn.setreg("+", text)
                        vim.notify("Copied file name: " .. text, vim.log.levels.INFO)
                    end, { desc = "Copy file name" })

                    -- Clear locaton list
                    vim.api.nvim_create_user_command("Cclear", function()
                        vim.fn.setloclist(0, {}, "r")
                    end, { desc = "Clear Location List" })

                    -- Make highlighted words more visible
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


                vim.keymap.set("n", "<C-a>", "<C-w>")
                vim.keymap.set("i", "<C-d>", "<C-w>")
                vim.keymap.set("c", "<C-a>", "<C-b>")
                -- vim.keymap.set("n", "<leader>cq", function()
                    --     vim.fn.setqflist({})
                    -- end)


                    -- :GitStashApply {index}
                    vim.api.nvim_create_user_command("GitStashApply", function(opts)
                        local index = opts.args

                        if not index:match("^%d+$") then
                            vim.notify(
                                "Usage: GitStashApply <index>",
                                vim.log.levels.ERROR
                            )
                            return
                        end

                        local git_root = get_git_root()
                        if not git_root then
                            return
                        end

                        local output = vim.fn.systemlist({
                            "git",
                            "-C",
                            git_root,
                            "stash",
                            "apply",
                            "stash@{" .. index .. "}",
                        })

                        if vim.v.shell_error ~= 0 then
                            vim.notify(
                                table.concat(output, "\n"),
                                vim.log.levels.ERROR
                            )
                            return
                        end

                        vim.notify(
                            "Applied stash@{" .. index .. "}\n"
                            .. table.concat(output, "\n"),
                            vim.log.levels.INFO
                        )
                    end, {
                    nargs = 1,
                    desc = "Apply Git stash by index",
                    complete = function()
                        return {}
                    end,
                })


                -- :GitStashDrop {index}
                vim.api.nvim_create_user_command("GitStashDrop", function(opts)
                    local index = opts.args

                    if not index:match("^%d+$") then
                        vim.notify(
                            "Usage: GitStashDrop <index>",
                            vim.log.levels.ERROR
                        )
                        return
                    end

                    local git_root = get_git_root()
                    if not git_root then
                        return
                    end

                    local ref = "stash@{" .. index .. "}"

                    local choice = vim.fn.confirm(
                        "Delete " .. ref .. " permanently?",
                        "&Yes\n&No",
                        2
                    )

                    if choice ~= 1 then
                        return
                    end

                    local output = vim.fn.systemlist({
                        "git",
                        "-C",
                        git_root,
                        "stash",
                        "drop",
                        ref,
                    })

                    if vim.v.shell_error ~= 0 then
                        vim.notify(
                            table.concat(output, "\n"),
                            vim.log.levels.ERROR
                        )
                        return
                    end

                    vim.notify(
                        "Dropped " .. ref .. "\n"
                        .. table.concat(output, "\n"),
                        vim.log.levels.INFO
                    )
                end, {
                nargs = 1,
                desc = "Drop Git stash by index",
                complete = function()
                    return {}
                end,
            })

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

    vim.api.nvim_create_user_command("Rename", function(opts)
        local old = vim.api.nvim_buf_get_name(0)
        local new = vim.fn.fnamemodify(old, ":h") .. "/" .. opts.args

        vim.cmd("saveas " .. vim.fn.fnameescape(new))
        vim.fn.delete(old)
    end, { nargs = 1 })

    vim.keymap.set("x", "<leader>lw", function()
        local selection = vim.fn.getregion(
            vim.fn.getpos("v"),
            vim.fn.getpos("."),
            { type = vim.fn.mode() }
        )

        local search_text = table.concat(selection, "\n")

        if search_text == "" then
            return
        end

        -- Literal search: escape ký tự đặc biệt của Vim regex.
        local pattern = [[\V]] .. vim.fn.escape(search_text, [[\]])

        -- Tìm trong buffer hiện tại.
        local filepath = vim.fn.expand("%:p")
        local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
        local matches = {}

        for lnum, line in ipairs(lines) do
            local start = 1

            while true do
                local s, e = line:find(search_text, start, true)

                if not s then
                    break
                end

                table.insert(matches, {
                    bufnr = vim.api.nvim_get_current_buf(),
                    lnum = lnum,
                    col = s,
                    text = line,
                })

                start = e + 1
            end
        end

        vim.fn.setqflist({}, "r", {
            title = "Literal search: " .. search_text,
            items = matches,
        })

        vim.cmd("copen")
    end, { desc = "Search visual selection in current buffer" })

    vim.api.nvim_create_user_command("Qhis", function()
        require("telescope.builtin").quickfixhistory()
    end, {
    desc = "Open Telescope Quickfix history",
})

vim.api.nvim_create_user_command("Format", function()
    local view = vim.fn.winsaveview()

    vim.cmd("normal! ggVG=")

    vim.fn.winrestview(view)
    vim.cmd("normal! zz")
end, {
desc = "Format entire file and keep cursor centered",
})

-- :QuickfixRename <new name> [index]
-- Rename the current Quickfix List or a specified list by index.
vim.api.nvim_create_user_command("Qrename", function(opts)
    local title = opts.args
    local index

    -- If the final argument is a number, treat it as the list index.
    local name, index_arg = title:match("^(.-)%s+(%d+)%s*$")

    if name then
        title = vim.trim(name)
        index = tonumber(index_arg)
    else
        title = vim.trim(title)
    end

    if title == "" then
        vim.notify(
            "Usage: QuickfixRename <new name> [index]",
            vim.log.levels.ERROR
        )
        return
    end

    if index == 0 then
        vim.notify(
            "Quickfix list index must be greater than zero",
            vim.log.levels.ERROR
        )
        return
    end

    -- Get the specified list, or the current list when index is omitted.
    local info

    if index then
        info = vim.fn.getqflist({
            nr = index,
            id = 0,
        })
    else
        info = vim.fn.getqflist({
            nr = 0,
            id = 0,
        })
    end

    if not info.id or info.id == 0 then
        vim.notify(
            index and ("Quickfix list " .. index .. " not found")
            or "No current Quickfix List",
            vim.log.levels.ERROR
        )
        return
    end

    local result = vim.fn.setqflist({}, "a", {
        id = info.id,
        title = title,
    })

    if result ~= 0 then
        vim.notify(
            "Failed to rename Quickfix List",
            vim.log.levels.ERROR
        )
        return
    end

    vim.notify(
        "Quickfix List " .. (index or info.nr) .. " renamed to: " .. title,
        vim.log.levels.INFO
    )
end, {
nargs = "+",
desc = "Rename current or specified Quickfix List",
})
