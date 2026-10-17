return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope.nvim",
        },

        config = function()
            local harpoon = require("harpoon")

            harpoon:setup({
                settings = {
                    save_on_toggle = true,
                    sync_on_ui_close = true,
                },
            })

            local pickers = require("telescope.pickers")
            local finders = require("telescope.finders")
            local conf = require("telescope.config").values
            local actions = require("telescope.actions")
            local action_state = require("telescope.actions.state")

            -- Store the last cursor position for each file.
            local last_positions = {}

            local function normalize_path(filepath)
                return vim.fn.fnamemodify(filepath, ":p")
            end

            local function save_cursor_position()
                local buf = vim.api.nvim_get_current_buf()

                -- Ignore special buffers.
                if vim.bo[buf].buftype ~= "" then
                    return
                end

                local filepath = vim.api.nvim_buf_get_name(buf)

                if filepath == "" then
                    return
                end

                local cursor = vim.api.nvim_win_get_cursor(0)

                last_positions[normalize_path(filepath)] = {
                    line = cursor[1],
                    col = cursor[2],
                }
            end

            -- Save cursor positions while editing and when leaving a file.
            vim.api.nvim_create_autocmd(
                { "CursorMoved", "CursorMovedI", "BufLeave" },
                {
                    callback = save_cursor_position,
                }
            )

            local function toggle_telescope(harpoon_files)
                -- Save the current position before opening Harpoon.
                save_cursor_position()

                local file_paths = {}

                for _, item in ipairs(harpoon_files.items) do
                    if item.value and item.value ~= "" then
                        table.insert(
                            file_paths,
                            normalize_path(item.value)
                        )
                    end
                end

                local function insert_selected_path(prompt_bufnr)
                    local entry = action_state.get_selected_entry()

                    if not entry then
                        vim.notify(
                            "No selected entry",
                            vim.log.levels.WARN
                        )
                        return
                    end

                    local filepath = entry.path or entry.value

                    if not filepath or filepath == "" then
                        vim.notify(
                            "Cannot get the selected file path",
                            vim.log.levels.WARN
                        )
                        return
                    end

                    filepath = vim.fn.fnameescape(
                        normalize_path(filepath)
                    )

                    actions.close(prompt_bufnr)

                    vim.schedule(function()
                        vim.api.nvim_feedkeys(
                            vim.api.nvim_replace_termcodes(
                                ":" .. filepath,
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

                pickers.new({}, {
                    prompt_title = "Harpoon",

                    finder = finders.new_table({
                        results = file_paths,

                        entry_maker = function(path)
                            local filepath = normalize_path(path)

                            local filename =
                                vim.fn.fnamemodify(filepath, ":t")

                            local position = last_positions[filepath]

                            -- Make sure the file exists before previewing.
                            if vim.fn.filereadable(filepath) ~= 1 then
                                return nil
                            end

                            return {
                                value = filepath,
                                path = filepath,
                                filename = filepath,
                                display = filename,
                                ordinal = filepath,

                                -- Preview the file at its remembered line.
                                lnum = position and position.line or 1,

                                -- Telescope uses a 1-based column here.
                                col = position and (position.col + 1) or 1,
                            }
                        end,
                    }),

                    -- Use the same previewer family as Telescope find_files.
                    previewer = conf.grep_previewer({}),

                    sorter = conf.generic_sorter({}),
                    attach_mappings = attach_path_mapping,
                }):find()
            end

            -- Open Harpoon.
            vim.keymap.set("n", "<C-e>", function()
                toggle_telescope(harpoon:list())
            end, {
                desc = "Harpoon: Find files",
            })

            -- Add the current file.
            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end, {
                desc = "Harpoon: Add file",
            })

            -- Remove the current file from Harpoon.
            vim.keymap.set("n", "<leader>rm", function()
                harpoon:list():remove()
            end, {
                desc = "Harpoon: Remove file",
            })

            -- Clear the entire Harpoon list.
            vim.keymap.set("n", "<leader>hc", function()
                harpoon:list():clear()
            end, {
                desc = "Harpoon: Clear list",
            })
        end,
    },
}
