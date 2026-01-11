return {
    {
        "nvim-mini/mini.nvim",
        version = "*",
        config = function()
            require('mini.pairs').setup()
            require('mini.ai').setup()
            require('mini.hipatterns').setup()
            require('mini.cursorword').setup()
            require('mini.git').setup()
            require('mini.diff').setup()
            require('mini.snippets').setup()
            require('mini.completion').setup()
            require('mini.indentscope').setup()
        end
    }
}
