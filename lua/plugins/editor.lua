return {
  {
    enabled = false,
    "folke/flash.nvim",
    ---@type Flash.Config
    opts = {
      search = {
        forward = true,
        multi_window = false,
        wrap = false,
        incremental = true,
      },
    },
  },

  {
    "echasnovski/mini.hipatterns",
    event = "BufReadPre",
    opts = {
      highlighters = {
        hsl_color = {
          pattern = "hsl%(%d+,? %d+%%?,? %d+%%?%)",
          group = function(_, match)
            local utils = require "solarized-osaka.hsl"
            --- @type string, string, string
            local nh, ns, nl = match:match "hsl%((%d+),? (%d+)%%?,? (%d+)%%?%)"
            --- @type number?, number?, number?
            local h, s, l = tonumber(nh), tonumber(ns), tonumber(nl)
            --- @type string
            local hex_color = utils.hslToHex(h, s, l)
            return MiniHipatterns.compute_hex_color_group(hex_color, "bg")
          end,
        },
      },
    },
  },

  {
    "dinhhuy258/git.nvim",
    event = "BufReadPre",
    opts = {
      keymaps = {
        blame = "<Leader>gb",
        browse = "<Leader>go",
      },
    },
  },

  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      {
        "nvim-lua/plenary.nvim",
        build = "make",
      },
      "nvim-telescope/telescope-file-browser.nvim",
    },
    keys = {
      {
        "<C-m>",
        function()
          local word = vim.fn.expand "<cword>"
          require("telescope.builtin").grep_string {
            search = word,
            only_sort_text = true,
            path_display = { "shorten" },
            cwd = vim.fn.getcwd(),
          }
        end,
      },
      {
        ";r",
        function()
          require("telescope.builtin").resume()
        end,
      },
      {
        ";b",
        function()
          require("telescope.builtin").resume()
        end,
      },
      {
        "nn",
        function()
          local telescope = require "telescope"

          local function telescope_buffer_dir()
            return vim.fn.expand "%:p:h"
          end

          telescope.extensions.file_browser.file_browser {
            path = "%:p:h",
            cwd = telescope_buffer_dir(),
            respect_gitignore = false,
            hidden = true,
            grouped = true,
            previewer = false,
            initial_mode = "normal",
            layout_config = { height = 40, width = 150 },
          }
        end,
      },
    },
    config = function(_, opts)
      local telescope = require "telescope"

      opts.defaults = vim.tbl_deep_extend("force", opts.defaults or {}, {
        wrap_results = true,
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
        mappings = {
          n = {},
        },
      })
      opts.pickers = {
        diagnostics = {
          theme = "ivy",
          initial_mode = "normal",
          layout_config = {
            preview_cutoff = 9999,
          },
        },
      }
      telescope.setup(opts)
      telescope.load_extension "file_browser"
    end,
  },

  {
    "saghen/blink.cmp",
    opts = {
      completion = {
        menu = {
          winblend = vim.o.pumblend,
        },
      },
      signature = {
        window = {
          winblend = vim.o.pumblend,
        },
      },
    },
  },

  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
  },

  {
    "akinsho/toggleterm.nvim",
    config = function()
      require("toggleterm").setup {
        size = 30,
        open_mapping = [[,,]],
        direction = "horizontal",
      }
    end,
  },

  {
    "kdheepak/lazygit.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    config = function() end,
    keys = {
      { "gl", ":LazyGit<CR>", desc = "Open Lazygit" },
    },
    cmd = "LazyGit",
  },

  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    config = function()
      require("gitsigns").setup {
        current_line_blame = true,
      }
    end,
  },

  {
    "tpope/vim-fugitive",
  },
}
