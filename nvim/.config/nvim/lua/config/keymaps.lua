-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local map = vim.keymap.set
local uv = vim.uv or vim.loop

local function num(value, default)
  local parsed = tonumber(value)
  return parsed or default
end

local cfg = vim.tbl_extend("force", {
  offset = 0,
  distance = 10,
  scroll_distance = 200,
  conditional_move_lines = 3,
}, vim.g.faybcontrol or {})

vim.g.faybcontrol = cfg

local function max_topline()
  return math.max(1, vim.fn.line("$") - vim.api.nvim_win_get_height(0) + 1)
end

local function scroll_by(direction, amount)
  local view = vim.fn.winsaveview()
  local original_topline = view.topline
  local delta = math.max(1, num(amount, 1))

  if direction == "down" then
    view.topline = math.min(max_topline(), view.topline + delta)
  else
    view.topline = math.max(1, view.topline - delta)
  end

  vim.fn.winrestview(view)
  return view.topline ~= original_topline
end

local function look(direction)
  local view = vim.fn.winsaveview()
  local win_height = vim.api.nvim_win_get_height(0)
  local offset = math.max(0, num(cfg.offset, 0))

  if direction == "down" then
    view.topline = math.max(1, view.lnum - offset)
  else
    local cursor_from_top = math.max(0, win_height - offset - 1)
    view.topline = math.max(1, view.lnum - cursor_from_top)
  end

  view.topline = math.min(max_topline(), view.topline)
  vim.fn.winrestview(view)
end

local function look_middle()
  vim.cmd("normal! zz")
end

local function place_cursor_middle()
  local middle = math.floor((vim.fn.line("w0") + vim.fn.line("w$")) / 2)
  vim.api.nvim_win_set_cursor(0, { middle, 0 })
end

local function move_cursor_conditional(direction, amount)
  local view = vim.fn.winsaveview()
  local is_visible = view.lnum >= view.topline and view.lnum <= vim.fn.line("w$")
  local lines = math.max(1, num(amount, 1))

  if is_visible then
    vim.cmd("normal! " .. lines .. (direction == "down" and "gj" or "gk"))
  else
    place_cursor_middle()
  end
end

local function is_visual_mode()
  local mode = vim.api.nvim_get_mode().mode
  return mode == "v" or mode == "V" or mode == "\22"
end

local function eol_col(line)
  return #vim.fn.getline(line)
end

local function select_line_with_previous_break_up()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local target_line = math.max(1, cursor[1] - 1)

  if not is_visual_mode() then
    vim.api.nvim_win_set_cursor(0, { cursor[1], eol_col(cursor[1]) })
    vim.cmd("normal! v")
  end

  vim.api.nvim_win_set_cursor(0, { target_line, eol_col(target_line) })
end

local function select_line_with_previous_break_down()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_count = vim.api.nvim_buf_line_count(0)

  if not is_visual_mode() then
    local start_line = math.max(1, cursor[1] - 1)
    vim.api.nvim_win_set_cursor(0, { start_line, eol_col(start_line) })
    vim.cmd("normal! v")
    vim.api.nvim_win_set_cursor(0, { cursor[1], eol_col(cursor[1]) })
    return
  end

  local target_line = math.min(line_count, cursor[1] + 1)
  vim.api.nvim_win_set_cursor(0, { target_line, eol_col(target_line) })
end

local scroll_state = {
  timer = nil,
  last_direction = nil,
  speed = 16,
  step = 2,
}

local function stop_scrolling()
  if not scroll_state.timer then
    return
  end

  scroll_state.timer:stop()
  scroll_state.timer:close()
  scroll_state.timer = nil
  scroll_state.last_direction = nil
  scroll_state.speed = 16
  scroll_state.step = 2
end

local function start_scrolling(direction)
  if scroll_state.timer then
    if scroll_state.last_direction ~= direction then
      stop_scrolling()
      return
    end

    scroll_state.speed = math.max(1, math.floor(scroll_state.speed / 2))
    scroll_state.step = scroll_state.step + 1
    scroll_state.timer:stop()
  else
    scroll_state.timer = uv.new_timer()
  end

  scroll_state.last_direction = direction
  scroll_state.timer:start(0, scroll_state.speed, vim.schedule_wrap(function()
    if not scroll_by(direction, scroll_state.step) then
      stop_scrolling()
    end
  end))
end

vim.api.nvim_create_autocmd({
  "CursorMoved",
  "CursorMovedI",
  "InsertEnter",
  "TextChanged",
  "BufLeave",
  "WinLeave",
}, {
  group = vim.api.nvim_create_augroup("faybcontrol-scroll", { clear = true }),
  callback = stop_scrolling,
})

map("n", "<C-Up>", function()
  look("down")
end, { desc = "FaybControl look down" })

map("n", "<C-Down>", function()
  scroll_by("down", num(cfg.scroll_distance, 200))
end, { desc = "FaybControl scroll down" })

map("n", "<PageUp>", function()
  move_cursor_conditional("up", num(cfg.conditional_move_lines, 3))
end, { desc = "FaybControl move cursor up" })

map("n", "<PageDown>", function()
  move_cursor_conditional("down", num(cfg.conditional_move_lines, 3))
end, { desc = "FaybControl move cursor down" })

map("n", "<M-PageUp>", function()
  start_scrolling("up")
end, { desc = "FaybControl start scroll up" })

map("n", "<M-PageDown>", function()
  start_scrolling("down")
end, { desc = "FaybControl start scroll down" })

map("n", "<C-l>", look_middle, { desc = "FaybControl look middle" })
map("n", "<C-M-b>", place_cursor_middle, { desc = "FaybControl place cursor middle" })
map({ "n", "x" }, "<C-M-Home>", select_line_with_previous_break_up, { desc = "FaybControl select up" })
map({ "n", "x" }, "<C-M-End>", select_line_with_previous_break_down, { desc = "FaybControl select down" })

map("n", "<C-Left>", "b", { desc = "Jump word left" })
map("n", "<C-Right>", "w", { desc = "Jump word right" })
map("i", "<C-Left>", "<C-o>b", { desc = "Jump word left" })
map("i", "<C-Right>", "<C-o>w", { desc = "Jump word right" })
