-- Make highlighted words more visible
local high_light_id = nil

local function clear_highlight()
	if high_light_id ~= nil then
		pcall(vim.fn.matchdelete, high_light_id)
		high_light_id = nil
	end
end

local function highlight_word(word)
	if not word or word == "" then
		return
	end

	clear_highlight()

	local pattern = "\\V\\<" .. vim.fn.escape(word, "\\") .. "\\>"

	high_light_id = vim.fn.matchadd("search", pattern)
end

local function highlight_word_under_cursor()
	local word = vim.fn.expand("<cword>")
	highlight_word(word)
end

local function highlight_visual_selection()
	local old_reg = vim.fn.getreg('"')
	local old_regtype = vim.fn.getregtype('"')

	vim.cmd("normal! y")

	local text = vim.fn.getreg('"')

	vim.fn.setreg('"', old_reg, old_regtype)

	text = text:gsub("\n$", "")

	if text == "" or text:find("\n") then
		return
	end

	highlight_word(text)
end

vim.keymap.set("n", "<leader>h", highlight_word_under_cursor, {
	silent = true,
})

vim.keymap.set("v", "<leader>h", function()
	highlight_visual_selection()
end, {
	silent = true,
})

vim.keymap.set({ "n", "v" }, "<leader>nh", clear_highlight, {
	silent = true,
})
