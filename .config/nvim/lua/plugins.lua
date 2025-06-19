vim.g.airline_extensions = { "tabline" }
vim.g.airline_extensions["tabline"] = { ["formatter"] = "unique_tail_improved" }

require("lsp")

-- handle formatting
local formatting = {
	filetype = {},
}

local has_formatter = false
local add_formatter = function(lang, tool)
	if vim.fn.executable(tool) then
		has_formatter = true
		local filetypes = require("formatter.filetypes." .. lang)
		return filetypes[tool]
	end
	return nil
end

local langs = require("languages")
for lang, formatter in pairs(langs.formatters()) do
	formatting.filetype[lang] = add_formatter(lang, formatter)
end
if has_formatter then
	require("formatter").setup(formatting)
end

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
