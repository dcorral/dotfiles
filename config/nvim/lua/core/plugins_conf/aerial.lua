local aerial = require('aerial')
aerial.setup({
    backends = { "treesitter", "lsp", "markdown", "asciidoc", "man" },
    kfilter_kind = {
        "Class",
        "Constructor",
        "Enum",
        "Function",
        "Interface",
        "Module",
        "Method",
        "Struct",
    }
})
