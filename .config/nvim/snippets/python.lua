local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
        s("def", {
                t("def "), i(1, "func_name"), t("("), i(2, ""), t({ "):", "\t" }), i(0)
        }),
        s("class", {
                t("class "), i(1, "ClassName"), t(":"), t({ "", "\t" }), i(0)
        }),
        s("if", {
                t('if __name__ == "__main__":'), t({ "", "\t" }),
                i(0)
        }),

}
