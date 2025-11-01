-- plugins/telescope.lua
return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = {
    'nvim-lua/plenary.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    'nvim-telescope/telescope-ui-select.nvim',
  },
  config = function()
    local telescope = require('telescope')
    local builtin = require('telescope.builtin')

    telescope.setup({
      defaults = {
        vimgrep_arguments = { 'rg', '--smart-case' },
        sorting_strategy = 'ascending',
        layout_config = { prompt_position = 'top' },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        ['ui-select'] = {
          require('telescope.themes').get_dropdown(),
        },
      },
    })

    -- Load extensions
    pcall(telescope.load_extension, 'fzf')
    pcall(telescope.load_extension, 'ui-select')

    -- Global keymaps
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
    vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Buffers' })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })

    -- Optional: Mason context keymaps
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "mason",
      callback = function()
        vim.keymap.set('n', '<C-f>', builtin.live_grep, { buffer = true, desc = 'Grep Mason packages' })
        vim.keymap.set('n', '<C-q>', builtin.quickfix, { buffer = true, desc = 'Open quickfix' })
      end,
    })
  end,
}
