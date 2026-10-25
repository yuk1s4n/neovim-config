return {
	{
		"neovim/nvim-lspconfig",

		dependencies = {
			-- Lua development support
			{
				"folke/lazydev.nvim",
				ft = "lua",
			},

			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",

			-- Completion
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
			"saadparwaiz1/cmp_luasnip",
			"L3MON4D3/LuaSnip",

			-- UI
			{ "j-hui/fidget.nvim", opts = {} },
			{ "https://git.sr.ht/~whynothugo/lsp_lines.nvim" },

			-- TypeScript diagnostics
			{
				"dmmulroy/tsc.nvim",
				config = function()
					require("tsc").setup({
						run_as_monorepo = true,
					})
				end,
			},

			-- TypeScript and JavaScript LSP
			{
				"pmizio/typescript-tools.nvim",
				dependencies = {
					"nvim-lua/plenary.nvim",
					"neovim/nvim-lspconfig",
				},
			},

			-- JSON schemas
			"b0o/SchemaStore.nvim",
		},

		config = function()
			local cmp = require("cmp")
			local cmp_lsp = require("cmp_nvim_lsp")
			local capabilities = cmp_lsp.default_capabilities()

			--------------------------------------------------
			-- Mason: install and manage external tools
			--------------------------------------------------

			require("mason").setup()

			-- Configure completion capabilities for all LSP servers.
			vim.lsp.config("*", {
				capabilities = capabilities,
			})

			-- Install and automatically enable these LSP servers.
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"clangd",
					"rust_analyzer",
				},
				automatic_enable = true,
			})

			-- Install formatters and other tools separately.
			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua",
				},
			})

			--------------------------------------------------
			-- TypeScript LSP
			--------------------------------------------------

			require("typescript-tools").setup({
				capabilities = capabilities,
			})

			--------------------------------------------------
			-- Tables for optional per-server customizations
			--------------------------------------------------

			-- Add server-specific capability overrides here if needed.
			local servers = {}

			-- Set a filetype to true to disable semantic tokens.
			-- Example: { cpp = true }
			local disable_semantic_tokens = {}

			--------------------------------------------------
			-- LSP attach: mappings and buffer configuration
			--------------------------------------------------

			vim.api.nvim_create_autocmd("LspAttach", {
				callback = function(args)
					local bufnr = args.buf

					local client = vim.lsp.get_client_by_id(args.data.client_id)

					if not client then
						return
					end

					local builtin = require("telescope.builtin")

					local opts = {
						buffer = bufnr,
						silent = true,
					}

					vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"

					-- Go to definition
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

					-- Find references
					vim.keymap.set("n", "gr", builtin.lsp_references, opts)

					-- Go to declaration
					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

					-- Go to type definition
					vim.keymap.set("n", "gT", vim.lsp.buf.type_definition, opts)

					-- Show hover information
					vim.keymap.set("n", "K", function()
						vim.lsp.buf.hover({
							border = "rounded",
						})
					end, opts)

					-- Show diagnostics for the current buffer
					vim.keymap.set("n", "<leader>bd", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

					-- Rename symbol
					vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

					-- Code actions
					vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

					-- Symbols in the current document
					vim.keymap.set("n", "<leader>wc", builtin.lsp_document_symbols, opts)

					-- Diagnostics across the workspace
					vim.keymap.set("n", "<leader>ww", function()
						builtin.diagnostics()
					end, opts)

					--------------------------------------------------
					-- Optional semantic-token customization
					--------------------------------------------------

					local filetype = vim.bo[bufnr].filetype

					if disable_semantic_tokens[filetype] then
						client.server_capabilities.semanticTokensProvider = nil
					end

					--------------------------------------------------
					-- Optional server capability overrides
					--------------------------------------------------

					local settings = servers[client.name]

					if type(settings) ~= "table" then
						settings = {}
					end

					if settings.server_capabilities then
						for key, value in pairs(settings.server_capabilities) do
							if value == vim.NIL then
								value = nil
							end

							client.server_capabilities[key] = value
						end
					end
				end,
			})

			--------------------------------------------------
			-- Diagnostic display
			--------------------------------------------------

			require("lsp_lines").setup()

			vim.diagnostic.config({
				virtual_text = true,
				virtual_lines = false,
			})

			vim.api.nvim_create_user_command("ToggleLspLines", function()
				local config = vim.diagnostic.config() or {}

				if config.virtual_text then
					vim.diagnostic.config({
						virtual_text = false,
						virtual_lines = true,
					})
				else
					vim.diagnostic.config({
						virtual_text = true,
						virtual_lines = false,
					})
				end
			end, {
				desc = "Toggle LSP diagnostic lines",
			})

			--------------------------------------------------
			-- Completion
			--------------------------------------------------

			local cmp_select = {
				behavior = cmp.SelectBehavior.Select,
			}

			cmp.setup({
				window = {
					completion = cmp.config.window.bordered({
						border = "rounded",
					}),

					documentation = cmp.config.window.bordered({
						border = "rounded",
					}),
				},

				performance = {
					max_view_entries = 5,
				},

				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body)
					end,
				},

				mapping = cmp.mapping.preset.insert({
					["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
					["<C-y>"] = cmp.mapping.confirm({ select = true }),
					["<C-Space>"] = cmp.mapping.complete(),
				}),

				sources = cmp.config.sources({
					{ name = "copilot", group_index = 2 },
					{ name = "nvim_lsp" },
					{ name = "luasnip" },
				}, {
					{ name = "buffer" },
				}),
			})
		end,
	},
}
