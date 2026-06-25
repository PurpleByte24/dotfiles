-- lua/mappings.lua
local keymap = vim.keymap

-- ==========================================
-- GROUP 1: CORE OPERATIONS & NAVIGATION
-- ==========================================

-- Double Spacebar to enter command mode
keymap.set({ "n", "x" }, "<space><space>", ":", { desc = "Enter command mode" })

-- Open the Lazy.nvim plugin manager dashboard anywhere
vim.keymap.set("n", "<leader>l", "<cmd>Lazy<cr>", { silent = true, desc = "Open lazy panel" })

-- Fast Saving & Window Closing
keymap.set("n", "<leader>w", "<cmd>update<cr>", { silent = true, desc = "Save buffer" })
keymap.set("n", "<leader>q", "<cmd>x<cr>", { silent = true, desc = "Quit current window" })

-- Escape forcefully closes annoying floating pop-ups/menus
keymap.set("n", "<Esc>", function()
  local win_config = vim.api.nvim_win_get_config(0)
  if win_config.relative ~= "" then
    vim.cmd("fclose!")
  else
    vim.cmd("noh")
  end
end, { desc = "Close floating win or clear highlight" })

-- Toggle case
keymap.set("n", "tc", "g~l", { desc = "Toggle case" })

-- Redo
keymap.set("n", "U", "<C-r>", { desc = "Redo" })

-- Show full diagnostic message under cursor
keymap.set("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })

-- ==========================================
-- GROUP 2: CURSOR MOVEMENT & SELECTION
-- ==========================================

-- Move by physical lines instead of logical lines (great for wrapped text)
keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Move down (visual line)" })
keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Move up (visual line)" })

-- Continuous visual shifting (holding > or < keeps the text highlighted)
keymap.set("x", "<", "<gv", { desc = "Indent left (keep selection)" })
keymap.set("x", ">", ">gv", { desc = "Indent right (keep selection)" })

-- ==========================================
-- GROUP 3: CLIPBOARD & REGISTERS
-- ==========================================

-- Don't let single char deletion overwrite clipboard history
keymap.set("n", "x", '"_x', {desc = "Delete char (no yank)" })
-- Don't let changing text overwrite your clipboard history
keymap.set("n", "c", '"_c', { desc = "Change (no yank)" })
keymap.set("n", "C", '"_C', { desc = "Change to EOL (no yank)" })
keymap.set("n", "cc", '"_cc', { desc = "Change line (no yank)" })
keymap.set("x", "c", '"_c', { desc = "Change selection (no yank)" })

-- Paste over highlighted text without losing your original clipboard
keymap.set("x", "p", '"_c<Esc>p', { desc = "Paste over selection (no yank)" })

-- Copy the entire file buffer to clipboard (Space + a for "All")
keymap.set("n", "<leader>a", "<cmd>%yank<cr>", { desc = "Yank entire buffer" })

-- ==========================================
-- GROUP 4: LINE CONTROLS & SMART TYPING
-- ==========================================

-- Join lines without violently jumping your cursor to the end of the line
keymap.set("n", "J", function()
  vim.cmd([[
      normal! mzJ`z
      delmarks z
    ]])
end, { desc = "Join lines without moving cursor" })

keymap.set("n", "gJ", function()
  vim.cmd([[
      normal! mzgJ`z
      delmarks z
    ]])
end, { desc = "Join lines without moving cursor" })

-- Break inserted text into smaller undo units on punctuation marks
local undo_ch = { ",", ".", "!", "?", ";", ":" }
for _, ch in ipairs(undo_ch) do
  keymap.set("i", ch, ch .. "<c-g>u")
end

-- ==========================================
-- GROUP 5: NATIVE MAC JUMPS (INSERT MODE)
-- ==========================================

-- Jump to start/end of line while typing (Emacs style)
keymap.set("i", "<C-A>", "<HOME>", { desc = "Jump to line start" })
keymap.set("i", "<C-E>", "<END>", { desc = "Jump to line end" })
keymap.set("c", "<C-A>", "<HOME>", { desc = "Jump to line start (cmdline)" })

-- Forward delete (delete character to the right of cursor)
keymap.set("i", "<C-D>", "<DEL>", { desc = "Forward delete" })

-- ==========================================
-- GROUP 6: BUFFER TAB CONTROLS (BUFFERLINE)
-- ==========================================

-- Cycle forward through open file tabs using Tab
keymap.set("n", "<Tab>", "<cmd>bnext<cr>", { silent = true, desc = "Next file tab" })

-- Cycle backward through open file tabs using Shift + Tab
keymap.set("n", "<S-Tab>", "<cmd>bprevious<cr>", { silent = true, desc = "Previous file tab" })

-- Instantly kill the current file tab without exiting Neovim
keymap.set("n", "<leader>x", function()
  local buf = vim.api.nvim_get_current_buf()
  local next = vim.fn.bufnr("#")
  if next == -1 or next == buf then
    vim.cmd("bnext")
    next = vim.api.nvim_get_current_buf()
  end
  if next ~= buf then
    vim.api.nvim_set_current_buf(next)
  end
  vim.api.nvim_buf_delete(buf, { force = false })
end, { silent = true, desc = "Close current file tab" })

-- ==========================================
-- GROUP 6: SEARCH AND REPLACE
-- ==========================================
-- In-file search and replace (populates with word under cursor)
keymap.set("n", "<leader>F", function()
  local word = vim.fn.expand("<cword>")
  vim.api.nvim_feedkeys(":%s/" .. word .. "/" .. word .. "/g", "n", false)
  -- places cursor before /g so you can edit the replacement
  local back = vim.api.nvim_replace_termcodes("<Left><Left><Left>", true, false, true)
  vim.api.nvim_feedkeys(back, "n", false)
end, { desc = "Replace word under cursor in file" })
