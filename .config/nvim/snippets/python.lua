local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
        -- Function
        s("def", {
                t("def "), i(1, "func_name"), t("("), i(2), t({ "):", "\t" }),
                i(0)
        }),

        -- Class
        s("class", {
                t("class "), i(1, "ClassName"), t(":"), t({ "", "\t" }),
                i(0)
        }),

        -- If main
        s("if __", {
                t('if __name__ == "__main__":'), t({ "", "\t" }),
                i(0)
        }),

        -- For loop
        s("for", {
                t("for "), i(1, "item"), t(" in "), i(2, "iterable"), t({ ":", "\t" }),
                i(0)
        }),

        -- While loop
        s("while", {
                t("while "), i(1, "condition"), t({ ":", "\t" }),
                i(0)
        }),

        -- Try/Except
        s("try", {
                t({ "try:", "\t" }), i(1),
                t({ "", "except " }), i(2, "Exception"), t(" as "), i(3, "e"), t({ ":", "\t" }),
                i(0)
        }),

        -- With statement
        s("with", {
                t("with "), i(1, "expr"), t(" as "), i(2, "var"), t({ ":", "\t" }),
                i(0)
        }),

        -- Print
        s("print", {
                t('print('), i(1, '"msg"'), t(')'), i(0)
        }),

        -- Import
        s("imp", {
                t("import "), i(1, "module"), i(0)
        }),

        -- From import
        s("from", {
                t("from "), i(1, "module"), t(" import "), i(2, "name"), i(0)
        }),

        -- Property
        s("prop", {
                t("@property"), t({ "", "def " }), i(1, "name"), t("(self):"),
                t({ "", "\t" }), i(0)
        }),

        -- Pytest
        s("test", {
                t("def test_"), i(1, "name"), t("():"),
                t({ "", "\t" }), i(0)
        }),
}
