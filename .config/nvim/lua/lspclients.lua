local function new_client_autocmd(pattern, factory)
	vim.api.nvim_create_autocmd("FileType", {
		pattern = pattern,
		callback = function(args)
			vim.lsp.start(factory(args))
		end,
	})
end

return {
	can_format = function(filetype)
		return true
	end,
	get = function()
		local configurations = {}
		configurations["lua-language-server"] = function(options)
			new_client_autocmd({ "lua" }, function()
				return {
					name = options.name,
					capabilities = options.capabilities,
					cmd = { options.name },
				}
			end)
		end
		configurations["gopls"] = function(options)
			new_client_autocmd({ "go", "gomod" }, function(args)
				return {
					name = options.name,
					capabilities = options.capabilities,
					cmd = { options.name },
					root_dir = vim.fs.root(args.buf, { "go.mod", "go.sum" }),
					settings = {
						gopls = {
							gofumpt = true,
							staticcheck = true,
						},
					},
				}
			end)
		end
		return configurations
	end,
}
