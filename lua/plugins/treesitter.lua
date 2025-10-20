
return {
    {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	lazy = false,
	build = ":TSUpdate",
	config = function()
	    require("nvim-treesitter.configs").setup {
		ensure_installed = { "lua", "c", "python", "rust" },
		highlight = { enable = true },
		indent = { enable = true },
		auto_install = false,
	    }
	end,
    },
}

