local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
        s("fn", {
                t("function "), i(1, "name"), t("("), i(2, "args"), t({ ")", "\t" }), i(0)
        }),
        s("req", {
                t("local "), i(1, "module"), t(" = require('"), i(2, "module_name"), t("')"), i(0)
        }),
}
