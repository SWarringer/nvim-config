return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").setup({
                ensure_installed = {
                    "lua",
                    "c",
                    "python",
                    "rust",
                    "markdown",
                    "markdown_inline",
                },
                highlight = {
                    enable = true,
                },
                indent = {
                    enable = true,
                },
                auto_install = false,
            })
        end,
    },
}
