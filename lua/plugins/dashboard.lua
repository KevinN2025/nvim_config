return {
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[ _  __          _        _   _   _                              ]],
        [[| |/ /___ _   _(_)_ __  | \ | | ___   __ _ _   _  ___ _ __ __ _]],
        [[| ' // _ \ | | | | '_ \ |  \| |/ _ \ / _` | | | |/ _ \ '__/ _` |]],
        [[| . \  __/ |_| | | | | || |\  | (_) | (_| | |_| |  __/ | | (_| |]],
        [[|_|\_\___|\__,_|_|_| |_||_| \_|\___/ \__, |\__,_|\___|_|  \__,_|]],
        [[                                      |___/                     ]],
        [[                                                               ]],
        [[                      Kevin Noguera Neovim                      ]],
      }

      dashboard.section.buttons.val = {
        dashboard.button("e", "New file", ":ene <BAR> startinsert<CR>"),
        dashboard.button("f", "Find file", ":Telescope find_files<CR>"),
        dashboard.button("r", "Recent files", ":Telescope oldfiles<CR>"),
        dashboard.button("q", "Quit", ":qa<CR>"),
      }

      dashboard.section.footer.val = {
        "Personal starter",
      }

      dashboard.config.layout[1].val = 6
      dashboard.config.layout[#dashboard.config.layout].val = 6

      alpha.setup(dashboard.config)
    end,
  },
}
