require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = { "lua_ls", "rust_analyzer" },
})

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_, bufnr)
  local function buf_set_option(...)
    vim.api.nvim_buf_set_option(bufnr, ...)
  end

  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = function(desc) 
      desc = desc or ""
      return { 
          buffer = bufnr, 
          noremap = true, 
          silent = true, 
          desc = desc 
      }
  end
  vim.keymap.set('n', 'lD', vim.lsp.buf.declaration, opts("LSP declaration"))
  vim.keymap.set('n', 'ld', vim.lsp.buf.definition, opts("LSP definition"))
  vim.keymap.set('n', 'lh', vim.lsp.buf.hover, opts("LSP hover"))
  vim.keymap.set('n', 'li', vim.lsp.buf.implementation, opts("LSP implementation"))
  vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts("LSP signature"))
  vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts())
  vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts())
  vim.keymap.set('n', '<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts())
  vim.keymap.set('n', '<leader>lt', vim.lsp.buf.type_definition, opts())
  vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts())
  vim.keymap.set('n', 'lr', vim.lsp.buf.references, opts())
  vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts())
  vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts())
  vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts())
  vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts())
end

-- Set up lspconfig and cmp_nvim binding.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

--require("mason-lspconfig").setup_handlers {
--     -- The first entry (without a key) will be the default handler
--     -- and will be called for each installed server that doesn't have
--     -- a dedicated handler.
--     function (server_name) -- default handler (optional)
--         require("lspconfig")[server_name].setup {
--            on_attach = on_attach,
--            capabilities = capabilities
--         }
--     end,
--}

