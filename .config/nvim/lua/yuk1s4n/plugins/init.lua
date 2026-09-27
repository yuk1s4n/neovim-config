return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        opts = {
            highlight = { enable = true },
            indent = { enable = true },
            ensure_installed = {
                "json", "javascript", "typescript", "tsx", "rust", "python",
                "yaml", "html", "css", "prisma",
                "markdown", "markdown_inline", "svelte",
                "graphql", "bash", "lua", "vim",
                "dockerfile", "gitignore", "query", "vimdoc", "c", "cpp",
            },
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = "<C-space>",
                    node_incremental = "<C-space>",
                    scope_incremental = false,
                    node_decremental = "<bs>",
                },
            },
        },
        config = function(_, opts)
            require("nvim-treesitter").setup(opts)
            vim.treesitter.language.register("bash", "zsh")
        end,
    },
    {
        "otavioschwanck/arrow.nvim",
        dependencies = {
            { "nvim-tree/nvim-web-devicons" },
            -- or if using `mini.icons`
            -- { "echasnovski/mini.icons" },
        },
        opts = {
            show_icons = true,
            save_path = function()
                return vim.fn.stdpath("cache") .. "/arrow"
            end,
            window = { -- controls the appearance and position of an arrow window (see nvim_open_win() for all options)
                width = "auto",
                height = "auto",
                row = "auto",
                col = "auto",
                border = "double",
            },
            per_buffer_config = {
                lines = 4, -- Number of lines showed on preview.
                sort_automatically = true, -- Auto sort buffer marks.
                satellite = { -- default to nil, display arrow index in scrollbar at every update
                    enable = false,
                    overlap = true,
                    priority = 1000,
                },
                zindex = 10, --default 50
                treesitter_context = nil, -- it can be { line_shift_down = 2 }, currently not usable, for detail see https://github.com/otavioschwanck/arrow.nvim/pull/43#issue-2236320268
            },
            save_key = "cwd", -- what will be used as root to save the bookmarks. Can be also `git_root` and `git_root_bare`.
            index_keys = "123456789zxcbnmZXVBNM,afghjklAFGHJKLwrtyuiopWRTYUIOP", -- keys mapped to bookmark index, i.e. 1st bookmark will be accessible by 1, and 12th - by c
            leader_key = "\\",
            buffer_leader_key = 'm',
            full_path_list = { "update_stuff" } -- filenames on this list will ALWAYS show the file path too.
        }
    },
    {
        "scottmckendry/cyberdream.nvim",
        lazy = false,
        priority = 1000,

        config = function()
            vim.cmd("colorscheme cyberdream")
            require("cyberdream").setup({
                -- Set light or dark variant
                variant = "default", -- use "light" for the light variant, "muted" for a softer dark variant. Also accepts "auto" to set dark or light colors based on the current value of `vim.o.background`

                -- Enable transparent background
                transparent = true,

                -- Reduce the overall saturation of colours for a more muted look
                saturation = 1, -- accepts a value between 0 and 1. 0 will be fully desaturated (greyscale) and 1 will be the full color (default)

                -- Enable italics comments
                italic_comments = false,

                -- Replace all fillchars with ' ' for the ultimate clean look
                hide_fillchars = true,

                -- Apply a modern borderless look to pickers like Telescope, Snacks Picker & Fzf-Lua
                borderless_pickers = true,

                -- Set terminal colors used in `:terminal`
                terminal_colors = true,

                -- Improve start up time by caching highlights. Generate cache with :CyberdreamBuildCache and clear with :CyberdreamClearCache
                cache = false,

                -- Override highlight groups with your own colour values
                highlights = {
                    -- Highlight groups to override, adding new groups is also possible
                    -- See `:h highlight-groups` for a list of highlight groups or run `:hi` to see all groups and their current values

                    -- Example:
                    Comment = { fg = "#696969", bg = "NONE", italic = true },

                    -- More examples can be found in `lua/cyberdream/extensions/*.lua`
                },

                -- Override a highlight group entirely using the built-in colour palette
                overrides = function(colors) -- NOTE: This function nullifies the `highlights` option
                    -- Example:
                    return {
                        Comment = { fg = colors.green, bg = "NONE", italic = true },
                        ["@property"] = { fg = colors.magenta, bold = true },
                    }
                end,

                -- Override colors
                colors = {
                    -- For a list of colors see `lua/cyberdream/colours.lua`

                    -- Override colors for both light and dark variants
                    bg = "#000000",
                    green = "#00ff00",

                    -- If you want to override colors for light or dark variants only, use the following format:
                    dark = {
                        magenta = "#ff00ff",
                        fg = "#eeeeee",
                    },
                    light = {
                        red = "#ff5c57",
                        cyan = "#5ef1ff",
                    },
                },

                -- Disable or enable colorscheme extensions
                extensions = {
                    telescope = true,
                    notify = true,
                    mini = true,
                    harpoon = true,
                },

                -- Alternatively, you can use 'default' to set all extensions at once
                -- cache = true, -- Use cache for fastest loads
                -- extensions = {
                    --     default = false, -- Disable all by default
                    --     base = true, -- Enable all built-in hl groups (you probably want this)
                    --
                    --     -- Now enable only what you want to use
                    --     telescope = true,
                    --     cmp = true,
                    --     gitsigns = true,
                    -- },
                })
            end
    },
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle)
            vim.keymap.set('n', '<leader>uf', vim.cmd.UndotreeFocus)
            -- vim.keymap.set('n', '<leader>uu', function()
                --     vim.fn['undotree#UndotreePersistUndo'](1)
                -- end, { desc = 'Undotree persist undo' })
                if vim.fn.has("persistent_undo") == 1 then
                    local target_path = vim.fn.expand("~/.undodir")

                    if vim.fn.isdirectory(target_path) == 0 then
                        vim.fn.mkdir(target_path, "p", 0700)
                    end

                    vim.opt.undodir = target_path
                    vim.opt.undofile = true
                end
            end
        },
        "nvim-lua/plenary.nvim",
        {
            "tpope/vim-fugitive",
            config = function()
                vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
            end
        },
        {
            "nvim-telescope/telescope.nvim",
            dependencies = { "nvim-lua/plenary.nvim" },
            config = function()
                local telescope = require("telescope")
                local builtin = require("telescope.builtin")

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
                            return utils.path_tail(vim.fn.fnamemodify(path, ":h"))
                            .. "/" .. utils.path_tail(path)
                        end,
                    },
                })

                vim.keymap.set("n", "<leader>pf", builtin.find_files)
                vim.keymap.set("n", "<C-p>", builtin.git_files)

                vim.keymap.set("n", "<leader>ps", function()
                    builtin.grep_string({
                        search = vim.fn.input("Grep > "),
                    })
                end)

                vim.keymap.set("n", "<leader>re", builtin.resume)
            end,
        },
        {
            "ThePrimeagen/harpoon",
            branch = "harpoon2",
            dependencies = { "nvim-lua/plenary.nvim", "nvim-telescope/telescope.nvim" },
            config = function()
                local harpoon = require("harpoon")
                harpoon:setup({
                    settings = {
                        save_on_toggle = true,
                        sync_on_ui_close = true,
                    }
                })
                local pickers = require("telescope.pickers")
                local finders = require("telescope.finders")
                local utils = require("telescope.utils")
                local conf = require("telescope.config").values

                local function toggle_telescope(harpoon_files)
                    local file_paths = {}
                    for _, item in ipairs(harpoon_files.items) do
                        table.insert(file_paths, item.value)
                    end

                    pickers.new({}, {
                        prompt_title = "Harpoon",
                        finder = require("telescope.finders").new_table({
                            results = file_paths,
                            entry_maker = function(path)
                                local filename = vim.fn.fnamemodify(path, ":t")
                                local dirname = vim.fn.fnamemodify(path, ":h:t")
                                local name = dirname .. "/" .. filename

                                return {
                                    value = path,
                                    display = name,
                                    ordinal = name,
                                    path = path,
                                }
                            end,
                        }),
                        previewer = conf.file_previewer({}),
                        -- previewer = previewers.vim_buffer_cat.new({}),
                        sorter = conf.generic_sorter({}),
                    }):find()
                end
                vim.keymap.set("n", "<C-e>", function() toggle_telescope(harpoon:list()) end)
                vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
                vim.keymap.set("n", "<leader>rm", function() harpoon:list():remove() end)
                vim.keymap.set("n", "<leader>hc", function() harpoon:list():clear() end)
                -- vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
                -- vim.keymap.set("n", "<C-j>", function() harpoon:list():select(2) end)
                -- vim.keymap.set("n", "<C-k>", function() harpoon:list():select(3) end)
                -- vim.keymap.set("n", "<C-h>", function() harpoon:list():select(1) end)
                -- vim.keymap.set("n", "<C-l>", function() harpoon:list():select(4) end)
            end
        },
        {
            'nvim-lualine/lualine.nvim',
            dependencies = { 'nvim-tree/nvim-web-devicons' },
            config = function()
                require('lualine').setup {
                    options = {
                        icons_enabled = true,
                        theme = 'codedark',
                        component_separators = { left = '', right = ''},
                        section_separators = { left = '', right = ''},
                        disabled_filetypes = {
                            statusline = {},
                            winbar = {},
                        },
                        ignore_focus = {},
                        always_divide_middle = true,
                        always_show_tabline = true,
                        globalstatus = false,
                        refresh = {
                            statusline = 1000,
                            tabline = 1000,
                            winbar = 1000,
                            refresh_time = 16, -- ~60fps
                            events = {
                                'WinEnter',
                                'BufEnter',
                                'BufWritePost',
                                'SessionLoadPost',
                                'FileChangedShellPost',
                                'VimResized',
                                'Filetype',
                                'CursorMoved',
                                'CursorMovedI',
                                'ModeChanged',
                            },
                        }
                    },
                    sections = {
                        lualine_a = {'mode'},
                        lualine_b = {'branch', 'diff', 'diagnostics'},
                        lualine_c = {'filename'},
                        lualine_x = {'encoding', 'fileformat', 'filetype'},
                        lualine_y = {'progress'},
                        lualine_z = {'location'}
                    },
                    inactive_sections = {
                        lualine_a = {},
                        lualine_b = {},
                        lualine_c = {'filename'},
                        lualine_x = {'location'},
                        lualine_y = {},
                        lualine_z = {}
                    },
                    tabline = {},
                    winbar = {},
                    inactive_winbar = {},
                    extensions = {}
                }
            end
        },
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
                    vim.keymap.set("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", {}),
                    vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", {}),
                }
            end
        },
        {
            "karb94/neoscroll.nvim",
            opts = {},
            config = function()
                require('neoscroll').setup({
                    mappings = {                 -- Keys to be mapped to their corresponding default scrolling animation
                        '<C-u>', '<C-d>',
                        'zz',
                    },
                    hide_cursor = true,          -- Hide cursor while scrolling
                    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
                    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
                    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
                    duration_multiplier = 1.0,   -- Global duration multiplier
                    easing = 'linear',           -- Default easing function
                    pre_hook = nil,              -- Function to run before the scrolling animation starts
                    post_hook = nil,             -- Function to run after the scrolling animation ends
                    performance_mode = false,    -- Disable "Performance Mode" on all buffers.
                    ignored_events = {           -- Events ignored while scrolling
                        'WinScrolled', 'CursorMoved'
                    },
                })
            end
        },
        -- {
        --     "sphamba/smear-cursor.nvim",
        --     opts = {
        --         -- Smear cursor when switching buffers or windows.
        --         smear_between_buffers = true,
        --
        --         -- Smear cursor when moving within line or to neighbor lines.
        --         -- Use `min_horizontal_distance_smear` and `min_vertical_distance_smear` for finer control
        --         smear_between_neighbor_lines = true,
        --
        --         -- Draw the smear in buffer space instead of screen space when scrolling
        --         scroll_buffer_space = true,
        --
        --         -- Set to `true` if your font supports legacy computing symbols (block unicode symbols).
        --         -- Smears and particles will look a lot less blocky.
        --         legacy_computing_symbols_support = false,
        --
        --         -- Smear cursor in insert mode.
        --         -- See also `vertical_bar_cursor_insert_mode` and `distance_stop_animating_vertical_bar`.
        --         smear_insert_mode = false,
        --     },
        -- },
        {
            "kdheepak/lazygit.nvim",

            cmd = {
                "LazyGit",
                "LazyGitConfig",
                "LazyGitCurrentFile",
                "LazyGitFilter",
                "LazyGitFilterCurrentFile",
            },
            -- optional for floating window border decoration
            dependencies = {
                "nvim-lua/plenary.nvim",
            },
            -- setting the keybinding for LazyGit with 'keys' is recommended in
            -- order to load the plugin when the command is run for the first time
            keys = {
                { "<leader>lg", "<cmd>LazyGit<cr>", desc = "Open lazy git" },
            },
        },
    }
