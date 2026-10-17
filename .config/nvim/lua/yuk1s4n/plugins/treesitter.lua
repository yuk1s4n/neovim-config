return {
{
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        opts = {
            highlight = { enable = false },
            indent = { enable = false },
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
}
