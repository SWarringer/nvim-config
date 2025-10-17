-- core/snacks_fix.lua
-- Prevent "Invalid buffer id" from Snacks.nvim by wrapping nvim_win_set_buf early.

if _G.__snacks_safe_buf_patch then return end
_G.__snacks_safe_buf_patch = true

local api = vim.api
local orig_set_buf = api.nvim_win_set_buf

---@diagnostic disable-next-line: duplicate-set-field
api.nvim_win_set_buf = function(win, buf)
  if api.nvim_win_is_valid(win) and api.nvim_buf_is_valid(buf) then
    local ok, err = pcall(orig_set_buf, win, buf)
    if not ok then
      vim.schedule(function()
        vim.notify("snacks_fix: skipped invalid buf " .. tostring(buf), vim.log.levels.WARN)
      end)
    end
  end
  -- if either invalid, silently skip
end
