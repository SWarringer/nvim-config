return {
    {
        "yuukiflow/Arduino-Nvim",  -- GitHub repo
        config = function()
            -- Load LSP configuration
            require("Arduino-Nvim.lsp").setup()

            -- Set up Arduino file type detection
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "arduino",
                callback = function()
                    require("Arduino-Nvim")
                end
            })
        end
    }
}
