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

            local function toggle_telescope(harpoon_files)

                -- Build the picker from the current Harpoon list.
                local function make_finder()
                    local file_paths = {}

                    for index = 1, harpoon_files:length() do
                        local item = harpoon_files:get(index)

                        -- Harpoon lists can contain empty positions
                        -- after removing entries.
                        if item and item.value and item.value ~= "" then
                            table.insert(file_paths, {
                                path = item.value,
                                harpoon_index = index,
                            })
                        end
                    end

                    return finders.new_table({
                        results = file_paths,

                        entry_maker = function(item)
                            local filename =
                            vim.fn.fnamemodify(item.path, ":t")

                            return {
                                value = item.path,
                                display = filename,
                                ordinal = filename,
                                path = item.path,
                                harpoon_index = item.harpoon_index,
                            }
                        end,
                    })
                end

                -- Ctrl-g: insert the selected path into the command line.
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

                -- Ctrl-d: delete selected entries without closing Telescope.
                local function remove_selected_files(prompt_bufnr)
                    local picker =
                    action_state.get_current_picker(prompt_bufnr)

                    if not picker then
                        return
                    end

                    local removed = 0

                    -- Telescope handles both multi-selection and
                    -- deleting only the current entry when nothing
                    -- is multi-selected.
                    picker:delete_selection(function(entry)
                        local index = entry.harpoon_index

                        if index and harpoon_files:get(index) then
                            harpoon_files:remove_at(index)
                            removed = removed + 1
                            return true
                        end

                        return false
                    end)

                    if removed > 0 then
                        vim.notify(
                            ("Removed %d file(s) from Harpoon"):format(
                                removed
                            ),
                            vim.log.levels.INFO
                        )
                    else
                        vim.notify(
                            "No entries removed",
                            vim.log.levels.WARN
                        )
                    end
                end

                local function attach_path_mapping(prompt_bufnr, map)
                    -- Preserve Ctrl-g in both modes.
                    map("i", "<C-g>", function()
                        insert_selected_path(prompt_bufnr)
                    end)

                    map("n", "<C-g>", function()
                        insert_selected_path(prompt_bufnr)
                    end)

                    -- Delete one or multiple entries with Ctrl-d.
                    map("i", "<C-d>", function()
                        remove_selected_files(prompt_bufnr)
                    end)

                    map("n", "<C-d>", function()
                        remove_selected_files(prompt_bufnr)
                    end)

                    -- Explicit multi-selection mappings.
                    map(
                        "i",
                        "<Tab>",
                        actions.toggle_selection
                        + actions.move_selection_next
                    )

                    map(
                        "i",
                        "<S-Tab>",
                        actions.toggle_selection
                        + actions.move_selection_previous
                    )

                    map(
                        "n",
                        "<Tab>",
                        actions.toggle_selection
                        + actions.move_selection_next
                    )

                    map(
                        "n",
                        "<S-Tab>",
                        actions.toggle_selection
                        + actions.move_selection_previous
                    )

                    return true
                end

                pickers.new({}, {
                    prompt_title = "Harpoon",
                    finder = make_finder(),
                    previewer = conf.file_previewer({}),
                    sorter = conf.generic_sorter({}),
                    attach_mappings = attach_path_mapping,
                }):find()
            end

            -- Open the custom Harpoon picker.
            vim.keymap.set("n", "<C-e>", function()
                toggle_telescope(harpoon:list())
            end, { desc = "Harpoon: Find files" })

            -- Add the current file.
            vim.keymap.set("n", "<leader>a", function()
                harpoon:list():add()
            end, { desc = "Harpoon: Add file" })

            -- Remove the current file from Harpoon.
            vim.keymap.set("n", "<leader>rm", function()
                harpoon:list():remove()
            end, { desc = "Harpoon: Remove current file" })

            -- Clear the entire Harpoon list.
            vim.keymap.set("n", "<leader>hc", function()
                harpoon:list():clear()
            end, { desc = "Harpoon: Clear list" })
        end,
    },
}
