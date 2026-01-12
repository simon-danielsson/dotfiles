local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
        -- Function
        s("fn", {
                t("function "), i(1, "name"), t("("), i(2, "args"), t({ ")", "\t" }),
                i(0)
        }),

        -- Require a module
        s("req", {
                t("local "), i(1, "module"), t(" = require('"), i(2, "module_name"), t("')"),
                i(0)
        }),

        -- Local variable
        s("loc", {
                t("local "), i(1, "name"), t(" = "), i(2, "value"),
                i(0)
        }),

        -- If statement
        s("if", {
                t("if "), i(1, "condition"), t(" then"),
                t({ "", "\t" }), i(0),
                t({ "", "end" })
        }),

        -- For loop (numeric)
        s("for", {
                t("for "), i(1, "i"), t(" = "), i(2, "1"), t(", "), i(3, "10"), t(" do"),
                t({ "", "\t" }), i(0),
                t({ "", "end" })
        }),

        -- Generic for loop (pairs/ipairs)
        s("forp", {
                t("for "), i(1, "k"), t(", "), i(2, "v"), t(" in "), i(3, "pairs("), i(4, "table"), t(") do"),
                t({ "", "\t" }), i(0),
                t({ "", "end" })
        }),

        -- Print
        s("print", {
                t("print("), i(1, "'message'"), t(")"),
                i(0)
        }),

        -- Return
        s("ret", {
                t("return "), i(1),
                i(0)
        }),

        -- Comment
        s("cmt", {
                t("-- "), i(1, "comment"),
                i(0)
        }),
}
