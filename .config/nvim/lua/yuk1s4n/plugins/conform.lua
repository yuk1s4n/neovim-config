return {
	"stevearc/conform.nvim",
	opts = {},
	config = function()
		require("conform").setup({
			format_on_save = {
				timeout_ms = 5000,
                lsp_format = "fallback",
			},
			formatters_by_ft = {
				c = { "clang-format" },
				cpp = { "clang-format" },
                cc = { "clang-format" },
				lua = { "stylua" },
                rust = { "rustfmt" },
                java = { "astyle" },
				json = { "prettier" },
                -- Maybe i need this someday
				-- elixir = { "mix" },
			},
			formatters = {
				["clang-format"] = {
					prepend_args = { "-style=file", "-fallback-style=LLVM" },
				},
			},
		})

        vim.api.nvim_create_user_command("Format", function()
            require("conform").format({ bufnr = 0 })
        end, {
        desc = "Format this file",
    })
	end,
}
