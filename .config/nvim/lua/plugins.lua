-- airline settings
vim.g.airline_extensions = {"tabline"}
vim.g.airline_extensions["tabline"] = {["formatter"] = "unique_tail_improved"}

-- nvim-cmp settings
local cmp = require'cmp'

cmp.setup({
    snippet = {
        expand = function(args)
            require('luasnip').lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert({
        ['<Right>'] = cmp.mapping.confirm({ select = false }),
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    }, {
        { name = 'buffer' },
    })
})

-- lsp
util = require 'lspconfig.util'
lspconfig = require "lspconfig"
local on_attach = function(client, bufnr)
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

local no_exec = function(name)
    return vim.fn.executable(name) ~= 1
end

local function setuplsp(exe, format_types)
    if no_exec(exe) then
        return
    end
    capabilities = require('cmp_nvim_lsp').default_capabilities()
    if exe == "gopls" then
        lspconfig.gopls.setup{
            on_attach = on_attach,
            capabilities = capabilities,
            settings = {
                gopls = {
                    gofumpt = true,
                    staticcheck = true
                }
            },
        }
    elseif exe == "efm-langserver" then
        lspconfig.efm.setup{
            on_attach = on_attach,
            capabilities = capabilities,
        }
    elseif exe == "rust-analyzer" then
        lspconfig.rust_analyzer.setup{
            on_attach = on_attach,
            capabilities = capabilities,
        }
    else
        error("unknown lsp requested")
    end
    if format_types ~= nil then
        vim.api.nvim_create_autocmd({ "BufWritePre" }, {
            pattern = { "*." .. format_types },
            callback = function()
                vim.lsp.buf.format { async = false }
            end
        })
    end
    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics,
        {
            virtual_text = true,
            signs = true,
            update_in_insert = false,
            underline = true,
        }
    )
end

setuplsp("rust-analyzer", "rs")
setuplsp("efm-langserver", nil)
setuplsp("gopls", "go")
function toggle_diagnostics()
    vim.diagnostic.open_float(nil, {
        focus=false,
        scope="buffer",
        format=function(d)
            return string.format("%s (line: %d, col: %d)", d.message, d.lnum, d.col)
        end
    })
end
vim.api.nvim_set_keymap("n", "<C-e>", ':call v:lua.toggle_diagnostics()<CR>', { noremap = true, silent = true })

-- term
require("toggleterm").setup{
    open_mapping = [[<C-t>]],
    direction = "float",
}
