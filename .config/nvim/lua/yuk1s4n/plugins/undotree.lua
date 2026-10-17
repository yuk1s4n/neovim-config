return {
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set('n', '<leader>ut', vim.cmd.UndotreeToggle)
            vim.keymap.set('n', '<leader>uf', vim.cmd.UndotreeFocus)
            -- vim.keymap.set('n', '<leader>uu', function()
                --     vim.fn['undotree#UndotreePersistUndo'](1)
                -- end, { desc = 'Undotree persist undo' })
                -- if vim.fn.has("persistent_undo") == 1 then
                --     local target_path = vim.fn.expand("~/.undodir")
                --
                --     if vim.fn.isdirectory(target_path) == 0 then
                --         vim.fn.mkdir(target_path, "p", 0700)
                --     end
                --
                --     vim.opt.undodir = target_path
                --     vim.opt.undofile = true
                -- end
            end
        },
    }
