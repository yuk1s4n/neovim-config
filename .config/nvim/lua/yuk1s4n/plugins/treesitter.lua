return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		lazy = false,
		init = function()
			local parsers = {
				"json",
				"javascript",
				"typescript",
				"tsx",
				"rust",
				"python",
				"yaml",
				"html",
				"css",
				"prisma",
				"markdown",
				"markdown_inline",
				"svelte",
				"graphql",
				"bash",
				"lua",
				"vim",
				"java",
				"dockerfile",
				"gitignore",
				"query",
				"vimdoc",
				"c",
				"cpp",
			}
			local group = vim.api.nvim_create_augroup("yuk1s4nTreeSitter", { clear = true })
			vim.api.nvim_create_autocmd({ "BufEnter", "FileType" }, {
				group = group,
				callback = function()
					if vim.bo.buftype ~= "" then
						return
					end

					pcall(vim.treesitter.start, 0)
				end,
			})

			vim.api.nvim_create_autocmd("User", {
				group = group,
				pattern = "VeryLazy",
				once = true,
				callback = function()
					require("nvim-treesitter").install(parsers)
				end,
			})
		end,
		config = function(_, opts)
			require("nvim-treesitter").setup(opts)
			vim.treesitter.language.register("bash", "zsh")
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		lazy = false,

		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = {
					lookahead = true,
				},
			})

			local select = require("nvim-treesitter-textobjects.select")

			vim.keymap.set({ "x", "o" }, "af", function()
				select.select_textobject("@function.outer", "textobjects")
			end, { desc = "Select around function" })

			vim.keymap.set({ "x", "o" }, "if", function()
				select.select_textobject("@function.inner", "textobjects")
			end, { desc = "Select inside function" })

			local move = require("nvim-treesitter-textobjects.move")

			-- Jump to the next function
			vim.keymap.set({ "n", "x", "o" }, "]m", function()
				move.goto_next_start("@function.outer", "textobjects")
			end, {
				desc = "Treesitter: Next function",
			})

			-- Jump to the previous function
			vim.keymap.set({ "n", "x", "o" }, "[m", function()
				move.goto_previous_start("@function.outer", "textobjects")
			end, {
				desc = "Treesitter: Previous function",
			})
		end,
	},
}
