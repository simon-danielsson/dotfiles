local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s("issue", {
        t("*brakoll - d: "), i(1),
        t(", p: "), i(2),
        t(", t: "), i(3),
        t(", s: todo"),
    }),
}
