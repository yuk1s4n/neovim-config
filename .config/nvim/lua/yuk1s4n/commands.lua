-- Change mode
vim.api.nvim_create_user_command("ChangeMode", function()
	vim.fn.system({ "chmod", "+x", vim.fn.expand("%:p") })

	if vim.v.shell_error == 0 then
		vim.notify("Changed mode: +x", vim.log.levels.INFO)
	else
		vim.notify("Failed to change mode", vim.log.levels.ERROR)
	end
end, { desc = "Make current file executable" })

-- Get path and file name
vim.api.nvim_create_user_command("GetPath", function()
	local text = vim.fn.expand("%:p")
	vim.fn.setreg("+", text)
	vim.notify("Copied path: " .. text, vim.log.levels.INFO)
end, { desc = "Copy absolute file path" })

vim.api.nvim_create_user_command("GetFileName", function()
	local text = vim.fn.expand("%:t")
	vim.fn.setreg("+", text)
	vim.notify("Copied file name: " .. text, vim.log.levels.INFO)
end, { desc = "Copy file name" })

-- Make git stash easier
vim.api.nvim_create_user_command("GitStashApply", function(opts)
	local index = opts.args

	if not index:match("^%d+$") then
		vim.notify("Usage: GitStashApply <index>", vim.log.levels.ERROR)
		return
	end

	local git_root = get_git_root()
	if not git_root then
		return
	end

	local output = vim.fn.systemlist({
		"git",
		"-C",
		git_root,
		"stash",
		"apply",
		"stash@{" .. index .. "}",
	})

	if vim.v.shell_error ~= 0 then
		vim.notify(table.concat(output, "\n"), vim.log.levels.ERROR)
		return
	end

	vim.notify("Applied stash@{" .. index .. "}\n" .. table.concat(output, "\n"), vim.log.levels.INFO)
end, {
	nargs = 1,
	desc = "Apply Git stash by index",
	complete = function()
		return {}
	end,
})

-- :GitStashDrop {index}
vim.api.nvim_create_user_command("GitStashDrop", function(opts)
	local index = opts.args

	if not index:match("^%d+$") then
		vim.notify("Usage: GitStashDrop <index>", vim.log.levels.ERROR)
		return
	end

	local git_root = get_git_root()
	if not git_root then
		return
	end

	local ref = "stash@{" .. index .. "}"

	local choice = vim.fn.confirm("Delete " .. ref .. " permanently?", "&Yes\n&No", 2)

	if choice ~= 1 then
		return
	end

	local output = vim.fn.systemlist({
		"git",
		"-C",
		git_root,
		"stash",
		"drop",
		ref,
	})

	if vim.v.shell_error ~= 0 then
		vim.notify(table.concat(output, "\n"), vim.log.levels.ERROR)
		return
	end

	vim.notify("Dropped " .. ref .. "\n" .. table.concat(output, "\n"), vim.log.levels.INFO)
end, {
	nargs = 1,
	desc = "Drop Git stash by index",
	complete = function()
		return {}
	end,
})

-- Rename a file
vim.api.nvim_create_user_command("Rename", function(opts)
	local old = vim.api.nvim_buf_get_name(0)
	local new = vim.fn.fnamemodify(old, ":h") .. "/" .. opts.args

	vim.cmd("saveas " .. vim.fn.fnameescape(new))
	vim.fn.delete(old)
end, { nargs = 1 })

vim.keymap.set("x", "<leader>lw", function()
	local selection = vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = vim.fn.mode() })

	local search_text = table.concat(selection, "\n")

	if search_text == "" then
		return
	end

	local pattern = [[\V]] .. vim.fn.escape(search_text, [[\]])

	local filepath = vim.fn.expand("%:p")
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	local matches = {}

	for lnum, line in ipairs(lines) do
		local start = 1

		while true do
			local s, e = line:find(search_text, start, true)

			if not s then
				break
			end

			table.insert(matches, {
				bufnr = vim.api.nvim_get_current_buf(),
				lnum = lnum,
				col = s,
				text = line,
			})

			start = e + 1
		end
	end

	vim.fn.setqflist({}, "r", {
		title = "Literal search: " .. search_text,
		items = matches,
	})

	vim.cmd("copen")
end, { desc = "Search visual selection in current buffer" })

-- :QuickfixRename <new name> [index]
-- Rename the current Quickfix List or a specified list by index.
vim.api.nvim_create_user_command("Qrename", function(opts)
	local title = opts.args
	local index

	-- If the final argument is a number, treat it as the list index.
	local name, index_arg = title:match("^(.-)%s+(%d+)%s*$")

	if name then
		title = vim.trim(name)
		index = tonumber(index_arg)
	else
		title = vim.trim(title)
	end

	if title == "" then
		vim.notify("Usage: QuickfixRename <new name> [index]", vim.log.levels.ERROR)
		return
	end

	if index == 0 then
		vim.notify("Quickfix list index must be greater than zero", vim.log.levels.ERROR)
		return
	end

	-- Get the specified list, or the current list when index is omitted.
	local info

	if index then
		info = vim.fn.getqflist({
			nr = index,
			id = 0,
		})
	else
		info = vim.fn.getqflist({
			nr = 0,
			id = 0,
		})
	end

	if not info.id or info.id == 0 then
		vim.notify(
			index and ("Quickfix list " .. index .. " not found") or "No current Quickfix List",
			vim.log.levels.ERROR
		)
		return
	end

	local result = vim.fn.setqflist({}, "a", {
		id = info.id,
		title = title,
	})

	if result ~= 0 then
		vim.notify("Failed to rename Quickfix List", vim.log.levels.ERROR)
		return
	end

	vim.notify("Quickfix List " .. (index or info.nr) .. " renamed to: " .. title, vim.log.levels.INFO)
end, {
	nargs = "+",
	desc = "Rename current or specified Quickfix List",
})

vim.api.nvim_create_user_command("ClearUnnamed", function()
	vim.fn.setreg('"', "")
end, {
	desc = "Clear the unnamed register",
})
