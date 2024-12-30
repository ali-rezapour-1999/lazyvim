local keymap = vim.keymap
local opts = { noremap = true, silent = true }

-- Escape insert mode with "jk"
keymap.set("i", "jk", "<ESC>", opts)

-- Remove search highlights
keymap.set("n", "nh", ":nohl<CR>", opts)

-- Save file quickly with ";;"
keymap.set("n", ";;", ":w<CR>", opts)

-- Delete a character without affecting registers
keymap.set("n", "x", '"_x', opts)

-- Delete a word backwards
keymap.set("n", "dw", 'vb"_d', opts)

-- Window management shortcuts
keymap.set("n", "sv", "<C-w>v", opts) -- Split window vertically
keymap.set("n", "sh", "<C-w>s", opts) -- Split window horizontally
keymap.set("n", "se", "<C-w>=", opts) -- Equalize window sizes

keymap.set("n", "cl", ":bdelete<CR>", opts)

-- Tab management shortcuts
keymap.set("n", "to", ":tabnew<CR>", opts) -- Open a new tab
keymap.set("n", "te", ":tabedit<CR>", opts) -- Edit in a new tab
keymap.set("n", "tl", ":tabnext<CR>", opts)
keymap.set("n", "th", ":tabprev<CR>", opts)

-- Keybindings for managing buffers within windows
keymap.set("n", "bc", ":bdelete<CR>", opts)

-- Switch windows
keymap.set("n", "<Space>", "<C-w>w", opts)

--Neotree
keymap.set("n", "nt", ":Neotree filesystem reveal toggle left<CR>", {})

-- Telescope shortcuts
keymap.set("n", "ff", "<cmd>Telescope find_files<cr>", opts) -- Find files
keymap.set("n", "fs", "<cmd>Telescope live_grep<cr>", opts) -- Live grep
keymap.set("n", "fb", "<cmd>Telescope buffers<cr>", opts) -- List buffers
keymap.set("n", "fh", "<cmd>Telescope help_tags<cr>", opts) -- Find help tags

-- Commenting
keymap.set("n", "<C-_>", "<Plug>(comment_toggle_linewise_current)", { desc = "Toggle comment for current line" })
keymap.set("v", "<C-_>", "<Plug>(comment_toggle_linewise_visual)", { desc = "Toggle comment for selection" })

-- Navigate suggestions in insert mode
keymap.set("i", "<C-j>", "<C-n>", opts) -- Next suggestion
keymap.set("i", "<C-k>", "<C-p>", opts) -- Previous suggestion

-- Restart LSP
keymap.set("n", "rss", ":LspRestart<CR>", opts)

-- Diagnostic navigation
keymap.set("n", "<C-j>", function()
  vim.diagnostic.goto_next()
end, opts)

-- Go to definition in a new tab
keymap.set("n", "<C-k>", function()
  local params = vim.lsp.util.make_position_params()
  vim.lsp.buf_request(0, "textDocument/definition", params, function(_, result, _, _)
    if not result or vim.tbl_isempty(result) then
      print "No definition found!"
      return
    end

    local target = result[1] or result
    local uri = target.uri or target.targetUri
    local range = target.range or target.targetSelectionRange
    local current_uri = vim.uri_from_bufnr(0)

    if uri == current_uri then
      -- Move cursor to the target location in the same buffer
      local row = range.start.line + 1
      local col = range.start.character + 1
      vim.api.nvim_win_set_cursor(0, { row, col })
    else
      -- Open the definition in a new tab
      vim.cmd "tabedit"
      vim.lsp.util.jump_to_location(target, "utf-8")
    end
  end)
end, { noremap = true, silent = true, desc = "Go to definition in a new tab" })