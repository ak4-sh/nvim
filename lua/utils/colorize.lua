local M = {}

-- Decode escaped ANSI CSI prefixes, leaving ordinary backslashes untouched.
local function decode_ansi(line)
  for _, prefix in ipairs({ "\\033", "\\x1[bB]", "\\u001[bB]", "\\e" }) do
    line = line:gsub(prefix .. "%[", "\27[")
  end
  return line
end

function M.colorize()
  local source = vim.api.nvim_get_current_buf()
  if vim.b[source].colorize_viewer then
    return source
  end

  local lines = vim.api.nvim_buf_get_lines(source, 0, -1, false)
  while #lines > 0 and vim.trim(lines[#lines]) == "" do
    lines[#lines] = nil
  end
  for i, line in ipairs(lines) do
    lines[i] = decode_ansi(line)
  end

  local buf = vim.api.nvim_create_buf(false, true)
  vim.b[buf].colorize_viewer = true
  vim.bo[buf].bufhidden = "wipe"
  vim.api.nvim_open_win(buf, true, { split = "below" })

  vim.wo.number = false
  vim.wo.relativenumber = false
  vim.wo.statuscolumn = ""
  vim.wo.signcolumn = "no"
  vim.wo.foldcolumn = "0"
  vim.wo.foldenable = false
  vim.wo.list = false
  vim.wo.cursorline = false

  local function scroll_to_end()
    if not vim.api.nvim_buf_is_valid(buf) then
      return
    end
    for _, win in ipairs(vim.fn.win_findbuf(buf)) do
      vim.api.nvim_win_call(win, function()
        vim.cmd("normal! G$")
      end)
    end
  end

  local group = vim.api.nvim_create_augroup("ColorizeViewer", { clear = false })
  vim.api.nvim_create_autocmd("TextChanged", {
    group = group,
    buffer = buf,
    callback = scroll_to_end,
  })
  vim.api.nvim_create_autocmd("TermEnter", {
    group = group,
    buffer = buf,
    command = "stopinsert",
  })
  vim.keymap.set("n", "q", "<cmd>close<cr>", {
    silent = true,
    buffer = buf,
    desc = "Close colorized output",
  })

  local channel = vim.api.nvim_open_term(buf, { force_crlf = false })
  vim.api.nvim_chan_send(channel, table.concat(lines, "\r\n"))
  vim.cmd("stopinsert")
  vim.schedule(scroll_to_end)
  return buf
end

return M
