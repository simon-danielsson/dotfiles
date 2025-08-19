-- ~/.config/nvim/snippets/python.lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

-- Load snippets
ls.add_snippets("python", {
        -- Simple print
        s("print", fmt("print({})", { i(1, "value") })),
        -- Function definition
        s("def", fmt([[
        def {}({}):
        {}
        ]], { i(1, "func_name"), i(2, ""), i(3, "pass") })),
        -- Class definition
        s("class", fmt([[
        class {}({}):
        def __init__(self, {}):
        {}
        ]], { i(1, "ClassName"), i(2, "object"), i(3, ""), i(4, "pass") })),
        -- If main guard
        s("main", fmt([[
        if __name__ == "__main__":
                {}
                ]], { i(1, "main()") })),
                -- For loop
                s("for", fmt([[
                for {} in {}:
                        {}
                        ]], { i(1, "item"), i(2, "iterable"), i(3, "pass") })),
                        -- While loop
                        s("while", fmt([[
                        while {}:
                                {}
                                ]], { i(1, "condition"), i(2, "pass") })),
                                -- If/elif/else
                                s("if", fmt([[
                                if {}:
                                        {}
                                        ]], { i(1, "condition"), i(2, "pass") })),
                                        s("elif", fmt([[
                                        elif {}:
                                        {}
                                        ]], { i(1, "condition"), i(2, "pass") })),
                                        s("else", fmt([[
                                else:
                                        {}
                                        ]], { i(1, "pass") })),
                                        -- Try/except/finally
                                        s("try", fmt([[
                                        try:
                                        {}
                                        except {} as {}:
                                        {}
                                        finally:
                                        {}
                                        ]], { i(1, "pass"), i(2, "Exception"), i(3, "e"), i(4, "pass"), i(5, "pass") })),
                                        -- Import statement
                                        s("imp", fmt("import {}", { i(1, "module") })),
                                        s("from", fmt("from {} import {}", { i(1, "module"), i(2, "*") })),
                                        -- Lambda
                                        s("lambda", fmt("{} = lambda {}: {}", { i(1, "f"), i(2, "x"), i(3, "x*2") })),
                                        -- Docstring for function
                                        s("doc", fmt([[
                                        \"\"\"
                                        {}
                                        \"\"\"
                                        ]], { i(1, "Description") })),
                                })
