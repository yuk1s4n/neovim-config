return {
    {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup {
                signs = {
                    add          = { text = '┃' },
                    change       = { text = '┃' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
                signs_staged = {
                    add          = { text = '┃' },
                    change       = { text = '┃' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
                signs_staged_enable = true,
                signcolumn = true,  -- Toggle with `:Gitsigns toggle_signs`
                numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
                linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
                word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir = {
                    follow_files = true
                },
                auto_attach = true,
                attach_to_untracked = false,
                current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                    use_focus = true,
                },
                current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
                blame_formatter = nil, -- Use default
                sign_priority = 6,
                update_debounce = 100,
                status_formatter = nil, -- Use default
                max_file_length = 40000, -- Disable if file is longer than this (in lines)
                preview_config = {
                    -- Options passed to nvim_open_win
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
                vim.keymap.set("n", "<leader>gh", ":Gitsigns preview_hunk<CR>", {}),
                vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", {}),
                vim.api.nvim_create_user_command("BlameCopy", function()
                    local file = vim.api.nvim_buf_get_name(0)
                    local line = vim.api.nvim_win_get_cursor(0)[1]

                    if file == "" then
                        vim.notify("Current buffer has no file", vim.log.levels.WARN)
                        return
                    end

                    local result = vim.fn.system({
                        "git", "blame", "--line-porcelain",
                        "-L", tostring(line) .. "," .. tostring(line),
                        "--", file,
                    })

                    if vim.v.shell_error ~= 0 then
                        vim.notify("Git blame failed: " .. vim.trim(result), vim.log.levels.ERROR)
                        return
                    end

                    local commit = result:match("^(%x+)")
                    local author = result:match("\nauthor (.-)\n")
                    local author_time = tonumber(result:match("\nauthor%-time (%d+)\n"))
                    local summary = result:match("\nsummary (.-)\n")

                    if not (commit and author and author_time and summary) then
                        vim.notify("Could not parse git blame output", vim.log.levels.ERROR)
                        return
                    end

                    local text = string.format(
                        "%s %s, %s - %s",
                        commit,
                        author,
                        os.date("%Y-%m-%d %H:%M:%S", author_time),
                        summary
                    )

                    vim.fn.setreg("+", text)
                    vim.notify("Blame copied to clipboard")
                end, { desc = "Copy current line blame" })
            }
        end
    },
}
