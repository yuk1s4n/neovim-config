return {
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
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup({
                settings = {
                    save_on_toggle = true,
                    sync_on_ui_close = true,
                }
            })
            vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
            vim.keymap.set("n", "<leader>rm", function() harpoon:list():remove() end)
            vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)
            vim.keymap.set("n", "<C-j>", function() harpoon:list():select(1) end)
            vim.keymap.set("n", "<C-k>", function() harpoon:list():select(2) end)
            vim.keymap.set("n", "<C-l>", function() harpoon:list():select(3) end)
            vim.keymap.set("n", "<C-s>", function() harpoon:list():select(4) end)
        end
    },
}
