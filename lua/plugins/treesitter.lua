return {
    "nvim-treesitter/nvim-treesitter",
    config = function()
        require'nvim-treesitter'.install{
            "rust", "javascript", "zig", "python", "java", "c", "cpp", "bash", "zsh",
            "markdown", "yaml", "latex"
        }
    end
}
