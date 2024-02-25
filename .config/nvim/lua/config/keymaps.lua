-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
--

vim.g.maplocalleader = [[\]]

vim.api.nvim_create_autocmd("BufEnter", {
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Disable New Line Comment",
})

local Terminal = require("toggleterm.terminal").Terminal

-- open lazygit history for the current file
vim.keymap.set("n", "<leader>gl", function()
  local absolutePath = vim.api.nvim_buf_get_name(0)

  local lazygit = Terminal:new({
    cmd = "lazygit --filter " .. absolutePath,
    dir = "git_dir",
    direction = "float",
    close_on_exit = true,
    float_opts = {
      -- lazygit itself already has a border
      border = "none",
    },
  })

  lazygit:open()
end, { desc = "lazygit file commits" })

-- open lazygit in the current git directory
vim.keymap.set("n", "<leader>gg", function()
  local lazygit = Terminal:new({
    cmd = "lazygit",
    dir = "git_dir",
    direction = "float",
    close_on_exit = true,
    float_opts = {
      -- lazygit itself already has a border
      border = "none",
    },
  })

  lazygit:open()
end, { desc = "lazygit" })

-- disable esc j and esc k moving lines accidentally
-- https://github.com/LazyVim/LazyVim/discussions/658
vim.keymap.set("n", "<A-k>", "<esc>k", { desc = "Move up" })
vim.keymap.set("n", "<A-j>", "<esc>j", { desc = "Move down" })
vim.keymap.set("i", "<A-k>", "<esc>gk", { desc = "Move up" })
vim.keymap.set("i", "<A-j>", "<esc>gj", { desc = "Move down" })
vim.keymap.set("v", "<A-k>", "<esc>gk", { desc = "Move up" })
vim.keymap.set("v", "<A-j>", "<esc>gj", { desc = "Move down" })

-- move to previous and next changes in the current file
vim.api.nvim_set_keymap("n", "-", "g;", { noremap = true })
vim.api.nvim_set_keymap("n", "+", "g,", { noremap = true })

-- based mapping section from ThePrimeagen

-- move lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line up" })

-- joins lines without moving the cursor
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join line" })

-- move screen up and down but keep the cursor in place (less disorienting)
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Move screen up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Move screen down" })

-- when searching, move to the next match and center the screen
vim.keymap.set("n", "n", "nzzzv", { desc = "Move to next match" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Move to previous match" })

-- replace whatever is visually selected with the next pasted text, without overwriting the clipboard
-- NOTE: prime uses "<leader>p" but I use that for something else
vim.keymap.set("x", "p", '"_dP')

-- easy navigation between quickfix items such as errors
vim.keymap.set("n", "<leader>j", "<cmd>cnext<CR>zz", { desc = "Next quickfix" })
vim.keymap.set("n", "<leader>k", "<cmd>cprev<CR>zz", { desc = "Previous quickfix" })

--
-- Replace the current word interactively
--
local function editSubstitutionCommand()
  -- Get the word under the cursor
  local word = vim.fn.expand("<cword>")

  -- Reposition the cursor at the beginning of the word.
  -- This is important because deleting the & suggestion will cause nvim to jump to the next match by default (this is disorienting). For some reason this doesn't happen when we reposition the cursor.
  vim.cmd("normal! viwo")

  -- Construct the substitution command
  local substitutionCommand = ":%s/\\<" .. word .. "\\>/&/gI"

  -- Open the command-line window with the command pre-filled and editable, but don't execute it yet
  vim.cmd("normal! :q:")
  vim.fn.feedkeys(substitutionCommand)
  -- position the cursor at the beginning of the word ("&")
  for _ = 1, 3 do
    vim.api.nvim_input("<Left>")
  end
end

vim.keymap.set("n", "<leader>r", function()
  editSubstitutionCommand()
end, { desc = "Replace the current word interactively" })

-- Copy the current buffer path to the clipboard
-- https://stackoverflow.com/a/17096082/1336788
vim.keymap.set("n", "<leader>fyr", function()
  vim.fn.setreg("+", vim.fn.expand("%"))
end, { desc = "Copy relative path to clipboard" })

-- full path
vim.keymap.set("n", "<leader>fyp", function()
  vim.fn.setreg("+", vim.fn.expand("%:p"))
end, { desc = "Copy full path to clipboard" })

-- just filename
vim.keymap.set("n", "<leader>fyf", function()
  vim.fn.setreg("+", vim.fn.expand("%:t"))
end, { desc = "Copy filename to clipboard" })

-- Remap y to ygv<esc> in visual mode so the cursor does not jump back to where
-- you started the selection.
-- https://www.reddit.com/r/neovim/comments/13y3thq/comment/jmm7tut/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
vim.keymap.set("v", "y", "ygv<esc>")

vim.keymap.set("n", "<backspace>", ":wa<cr>", { desc = "Save all files", silent = true })
