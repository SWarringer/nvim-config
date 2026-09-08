return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            local ensure_installed = {
                "lua",
                "c",
                "python",
                "rust",
                "markdown",
                "markdown_inline",
                "vimdoc",
            }

            local ts = require("nvim-treesitter")
            ts.setup()

            -- On the `main` branch, `setup()` does NOT install parsers or enable
            -- highlight/indent. We install parsers and wire up highlighting manually.
            ts.install(ensure_installed)

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "lua", "c", "python", "rust", "markdown", "help" },
                callback = function(args)
                    -- Enable treesitter-based highlighting.
                    pcall(vim.treesitter.start, args.buf)
                    -- Enable treesitter-based indentation.
                    vim.bo[args.buf].indentexpr =
                        "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
}
