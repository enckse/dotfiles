vim.g.airline_extensions = { "tabline" }
vim.g.airline_extensions["tabline"] = { ["formatter"] = "unique_tail_improved" }

require("lsp")

-- handle formatting
require("formatter").setup({
	filetype = {
		lua = {
			require("formatter.filetypes.lua").stylua,
		},
		go = {
			require("formatter.filetypes.go").gofumpt,
		},
	},
})
local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd
augroup("__formatter__", { clear = true })
autocmd("BufWritePost", {
	group = "__formatter__",
	command = ":FormatWrite",
})

vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter" }, {
	callback = function()
		if vim.bo.filetype == "sh" then
			require("lint").try_lint("shellcheck")
		end
	end,
})
