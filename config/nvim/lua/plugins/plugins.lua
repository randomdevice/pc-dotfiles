local default_adapter = "copilot"

return {
    -- Plenary Lua library
    {
        "nvim-lua/plenary.nvim",
        lazy = true,
    },

    -- Tree sitter
    {
      "nvim-treesitter/nvim-treesitter",
    },

    -- Fuzzy finder
    { "junegunn/fzf", build = "./install --bin" },
    {
        "ibhagwan/fzf-lua",
        -- optional for icon support
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- calling `setup` is optional for customization
            require("fzf-lua").setup({})
        end
    },

    -- LSP Autocomplete
    {
      'saghen/blink.cmp',
      dependencies = { 'rafamadriz/friendly-snippets' },
      opts = {
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- 'super-tab' for mappings similar to vscode (tab to accept)
        -- 'enter' for enter to accept
        -- 'none' for no mappings
        --
        -- All presets have the following mappings:
        -- C-space: Open menu or open docs if already open
        -- C-n/C-p or Up/Down: Select next/previous item
        -- C-e: Hide menu
        -- C-k: Toggle signature help (if signature.enabled = true)
        --
        -- See :h blink-cmp-config-keymap for defining your own keymap
        keymap = { preset = 'default' },
        completion = { documentation = { auto_show = true } },
        fuzzy = { implementation = "lua" }
      },
      opts_extend = { "sources.default" }
    },

    -- LSP Config
    {
        "neovim/nvim-lspconfig",
        dependencies = {
          "saghen/blink.cmp",
          {
            "folke/lazydev.nvim",
            ft = "lua", -- only load on lua files
            opts = {
              library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
              },
            },
          },
        },
    },

    -- LSP Installation Manager
    {
        "mason-org/mason.nvim",
        opts = {}
    },

    -- LSP Autoconfig Bridge
    {
        "mason-org/mason-lspconfig.nvim",
        opts = {},
        dependencies = {
            { "mason-org/mason.nvim", opts = {} },
            "neovim/nvim-lspconfig",
        },
    },

    -- AI Code Assist
    {
      "olimorris/codecompanion.nvim",
      opts = {
          strategies = {
            chat = {
                adapter = default_adapter,
            },
            inline = {
                adapter = default_adapter,
            },
          },
          adapters = {
              gemma3 = function()
                return require("codecompanion.adapters").extend("ollama", {
                    name = "gemma3",
                    schema = {
                        model = {
                            default = "gemma3:4b"
                        },
                    },
                })
              end,
              qwen = function()
                return require("codecompanion.adapters").extend("ollama", {
                    name = "qwen",
                    schema = {
                        model = {
                            default = "qwen2.5-coder:7b"
                        },
                    },
                })
              end,
          },
      },
      dependencies = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
      },
    },
}
