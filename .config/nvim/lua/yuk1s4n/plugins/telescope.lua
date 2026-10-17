return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },

        config = function()
            local telescope = require("telescope")
            local builtin = require("telescope.builtin")
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            --------------------------------------------------
            -- Find the Git root containing the current file
            --------------------------------------------------
            local function get_git_root()
                local filename = vim.api.nvim_buf_get_name(0)
                local start_dir

                if filename ~= "" then
                    start_dir = vim.fn.fnamemodify(filename, ":p:h")
                else
                    start_dir = vim.fn.getcwd()
                end

                local result = vim.fn.systemlist({
                    "git",
                    "-C",
                    start_dir,
                    "rev-parse",
                    "--show-toplevel",
                })

                if vim.v.shell_error ~= 0 or not result[1] then
                    vim.notify(
                        "Current file is not inside a Git repository",
                        vim.log.levels.WARN
                    )
                    return nil
                end

                return vim.trim(result[1])
            end

            --------------------------------------------------
            -- Stop Treesitter in nofile buffers
            --------------------------------------------------
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local buf = args.buf

                    if vim.bo[buf].buftype == "nofile" then
                        pcall(vim.treesitter.stop, buf)
                    end
                end,
            })

            vim.keymap.set("i", "<C-s>", "<Nop>", {
                desc = "Disable default Ctrl-S in Insert mode",
            })
            --------------------------------------------------
            -- Telescope setup: giữ nguyên cấu hình của bạn
            --------------------------------------------------
            telescope.setup({
                defaults = {
                    layout_strategy = "horizontal",

                    layout_config = {
                        horizontal = {
                            preview_cutoff = 0,
                            preview_width = 0.5,
                        },
                    },

                    path_display = function(_, path)
                        local utils = require("telescope.utils")
                        return utils.path_tail(path)
                    end,
                },
            })

            --------------------------------------------------
            -- Ctrl-g: insert selected file path into command line
            -- Không thực thi command
            --------------------------------------------------
            local function insert_selected_path(prompt_bufnr)
                local entry = action_state.get_selected_entry()

                if not entry then
                    vim.notify(
                        "No selected entry",
                        vim.log.levels.WARN
                    )
                    return
                end

                local filepath = entry.path or entry.filename

                if not filepath then
                    vim.notify(
                        "Cannot get the selected file path",
                        vim.log.levels.WARN
                    )
                    return
                end

                filepath = vim.fn.fnamemodify(filepath, ":p")
                filepath = vim.fn.fnameescape(filepath)

                actions.close(prompt_bufnr)

                vim.schedule(function()
                    local keys = ":" .. filepath

                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes(
                            keys,
                            true,
                            false,
                            true
                        ),
                        "n",
                        false
                    )
                end)
            end

            local function attach_path_mapping(_, map)
                map("i", "<C-g>", insert_selected_path)
                map("n", "<C-g>", insert_selected_path)
                return true
            end

            --------------------------------------------------
            -- Ctrl-s: save Telescope results to a NEW Quickfix List
            --------------------------------------------------
            local function save_results_to_quickfix(prompt_bufnr)
                local picker =
                action_state.get_current_picker(prompt_bufnr)

                if not picker then
                    return
                end

                local items = {}

                for entry in picker.manager:iter() do
                    local filename = entry.filename or entry.path

                    if filename then
                        filename = vim.fn.fnamemodify(
                            filename,
                            ":p"
                        )

                        table.insert(items, {
                            filename = filename,
                            lnum = tonumber(entry.lnum) or 1,
                            col = tonumber(entry.col) or 1,
                            text = vim.trim(
                                entry.text or entry.display or filename
                            ),
                        })
                    end
                end

                local title = "Telescope Results"

                if picker.prompt_title and picker.prompt_title ~= "" then
                    title = "Telescope: " .. picker.prompt_title
                end

                actions.close(prompt_bufnr)

                -- " " creates a new Quickfix List, not an append
                vim.fn.setqflist({}, " ", {
                    title = title,
                    items = items,
                })

                vim.cmd("copen")

                if #items == 0 then
                    vim.notify(
                        "No file results to save",
                        vim.log.levels.WARN
                    )
                else
                    vim.notify(
                        string.format(
                            "Saved %d results to Quickfix",
                            #items
                        ),
                        vim.log.levels.INFO
                    )
                end
            end

            local function attach_quickfix_mapping(_, map)
                map("i", "<C-s>", save_results_to_quickfix)
                map("n", "<C-s>", save_results_to_quickfix)
                return true
            end

            --------------------------------------------------
            -- <leader>pf: Find files
            --------------------------------------------------
            vim.keymap.set("n", "<leader>pf", function()
                builtin.find_files({
                    attach_mappings = function(prompt_bufnr, map)
                        attach_path_mapping(prompt_bufnr, map)
                        attach_quickfix_mapping(prompt_bufnr, map)
                        return true
                    end,
                })
            end, {
            desc = "Find files",
        })

        --------------------------------------------------
        -- Ctrl-p: Git files in the current repository
        --------------------------------------------------
        vim.keymap.set("n", "<C-p>", function()
            local git_root = get_git_root()
            if not git_root then
                return
            end

            builtin.git_files({
                cwd = git_root,
                attach_mappings = function(prompt_bufnr, map)
                    attach_path_mapping(prompt_bufnr, map)
                    attach_quickfix_mapping(prompt_bufnr, map)
                    return true
                end,
            })
        end, {
        desc = "Find Git files in current repository",
    })

    --------------------------------------------------
    -- <leader>ps: Search text or visual selection
    --------------------------------------------------
    vim.keymap.set({ "n", "x" }, "<leader>ps", function()
        local search_text

        if vim.fn.mode():match("[vV\22]") then
            local start_pos = vim.fn.getpos("v")
            local end_pos = vim.fn.getpos(".")

            local selection = vim.fn.getregion(
                start_pos,
                end_pos,
                { type = vim.fn.mode() }
            )

            search_text = table.concat(selection, "\n")
        else
            search_text = vim.fn.input("Grep > ")
        end

        if search_text == "" then
            return
        end

        builtin.grep_string({
            search = search_text,
            use_regex = false,
            attach_mappings = function(prompt_bufnr, map)
                attach_path_mapping(prompt_bufnr, map)
                attach_quickfix_mapping(prompt_bufnr, map)
                return true
            end,
        })
    end, {
    desc = "Grep string or visual selection",
})

--------------------------------------------------
-- <leader>re: Resume Telescope
--------------------------------------------------
vim.keymap.set("n", "<leader>re", builtin.resume, {
    desc = "Resume Telescope",
})

--------------------------------------------------
-- <leader>ls: Browse Git stashes and show selected diff
--------------------------------------------------
vim.keymap.set("n", "<leader>ls", function()
    local git_root = get_git_root()
    if not git_root then
        return
    end

    builtin.git_stash({
        cwd = git_root,

        attach_mappings = function(prompt_bufnr, map)
            local function show_stash_diff()
                local selection = action_state.get_selected_entry()
                if not selection then
                    return
                end

                local source = selection.value
                or selection.ordinal
                or selection.display
                or ""

                local index = tostring(source):match(
                    "stash@{(%d+)}"
                )

                if not index then
                    vim.notify(
                        "Cannot determine stash index",
                        vim.log.levels.ERROR
                    )
                    return
                end

                actions.close(prompt_bufnr)

                local output = vim.fn.systemlist({
                    "git",
                    "-C",
                    git_root,
                    "stash",
                    "show",
                    "-p",
                    "stash@{" .. index .. "}",
                })

                if vim.v.shell_error ~= 0 then
                    vim.notify(
                        table.concat(output, "\n"),
                        vim.log.levels.ERROR
                    )
                    return
                end

                -- Display diff in a separate scratch buffer
                vim.cmd("botright new")

                local buf = vim.api.nvim_get_current_buf()

                vim.api.nvim_buf_set_name(
                    buf,
                    "Git Stash Diff " .. index
                )

                vim.bo[buf].buftype = "nofile"
                vim.bo[buf].bufhidden = "wipe"
                vim.bo[buf].swapfile = false
                vim.bo[buf].filetype = "diff"
                vim.bo[buf].modifiable = true

                vim.api.nvim_buf_set_lines(
                    buf,
                    0,
                    -1,
                    false,
                    #output > 0 and output or {
                        "No changes in this stash",
                    }
                )

                vim.bo[buf].modifiable = false
            end

            -- Enter: show diff, never apply the stash
            map("i", "<CR>", show_stash_diff)
            map("n", "<CR>", show_stash_diff)

            return true
        end,
    })
end, {
desc = "Browse Git stashes",
        })
    end,
},
}
