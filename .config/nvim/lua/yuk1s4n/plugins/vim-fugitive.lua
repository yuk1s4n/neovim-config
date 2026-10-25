return {
	{
		"tpope/vim-fugitive",
		config = function()
			vim.keymap.set("n", "<leader>gs", vim.cmd.Git)
			vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
			vim.keymap.set("n", "gl", "<cmd>diffget //2<CR>")
			vim.api.nvim_create_user_command("GitPush", function()
				vim.cmd("Git push origin HEAD:refs/for/master")
			end, {
				desc = "Git: Push to Gerrit",
			})
		end,
	},
}
