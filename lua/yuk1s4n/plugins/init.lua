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
            local builtin = require("telescope.builtin")
            require("telescope").setup({})
            vim.keymap.set("n", "<leader>pf", builtin.find_files)
            vim.keymap.set("n", "<C-p>", builtin.git_files)
            vim.keymap.set("n", "<leader>ps", function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") });
            end)
            vim.keymap.set("n", "<leader>re", builtin.resume)
        end
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
            local conf = require("telescope.config").values
            local function toggle_telescope(harpoon_files)
                local file_paths = {}
                for _, item in ipairs(harpoon_files.items) do
                    table.insert(file_paths, item.value)
                end

                require("telescope.pickers").new({}, {
                    prompt_title = "Harpoon",
                    finder = require("telescope.finders").new_table({
                        results = file_paths,
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
