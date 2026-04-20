return {
    { "EdenEast/nightfox.nvim" },
    { "rebelot/kanagawa.nvim" },
    {
        "rose-pine/neovim",
        name = "rose-pine",
    },
    {
      "oskarnurm/koda.nvim",
    },
    {
        "catppuccin/nvim",
        name="catppuccin",
        priority=1000
    },
    {
        "Shatur/neovim-ayu",
        name="ayu",
    },
    {
        "vague-theme/vague.nvim",
        name="vague",
    },
    {
        "baliestri/aura-theme",
        lazy = false,
        priority = 1000,
        config = function(plugin)
          vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
          vim.cmd([[colorscheme aura-dark]])
        end
    },
}
