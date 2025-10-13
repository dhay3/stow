return {
  "folke/tokyonight.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("tokyonight").setup({
      on_colors = function(colors)
        colors.bg = "#101010"
      end,
    })
    vim.cmd([[colorscheme tokyonight]])
  end,
}
