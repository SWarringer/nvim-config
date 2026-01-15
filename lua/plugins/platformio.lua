
return {
  'anurag3301/nvim-platformio.lua',
  cond = function()
    local platformioRootDir = (vim.fn.filereadable('platformio.ini') == 1) and vim.fn.getcwd() or nil
    if platformioRootDir then
      vim.g.platformioRootDir = platformioRootDir
    elseif (vim.uv or vim.loop).fs_stat(vim.fn.stdpath('data') .. '/lazy/nvim-platformio.lua') == nil then
      vim.g.platformioRootDir = vim.fn.getcwd()
    else
      vim.api.nvim_create_user_command('Pioinit', function()
        vim.api.nvim_create_autocmd('User', {
          pattern = { 'LazyRestore', 'LazyLoad' },
          once = true,
          callback = function(args)
            if args.match == 'LazyRestore' then
              require('lazy').load({ plugins = { 'nvim-platformio.lua' } })
            elseif args.match == 'LazyLoad' then
              vim.notify('PlatformIO loaded', vim.log.levels.INFO, { title = 'PlatformIO' })
              require("platformio").setup(vim.g.pioConfig)
              vim.cmd('Pioinit')
            end
          end,
        })
        vim.g.platformioRootDir = vim.fn.getcwd()
        require('lazy').restore({ plguins = { 'nvim-platformio.lua' }, show = false })
      end, {})
    end
    return vim.g.platformioRootDir ~= nil
  end,
  dependencies = {
    { 'akinsho/toggleterm.nvim' },
    { 'nvim-telescope/telescope.nvim' },
    { 'nvim-telescope/telescope-ui-select.nvim' },
    { 'nvim-lua/plenary.nvim' },
    { 'folke/which-key.nvim' },
    { 'nvim-treesitter/nvim-treesitter' }
  },
  cmd = { 'Pioinit', 'Piorun', 'Piocmdh', 'Piocmdf', 'Piolib', 'Piomon', 'Piodebug', 'Piodb' },
}
