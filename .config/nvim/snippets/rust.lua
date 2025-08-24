local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
        -- Function
        s("fn", {
                t("fn "), i(1, "name"), t("("), i(2, ""), t(") {"),
                t({ "", "\t" }), i(0),
                t({ "", "}" })
        }),

        -- Main function
        s("main", {
                t("fn main() {"),
                t({ "", "\t" }), i(0),
                t({ "", "}" })
        }),

        -- Struct
        s("struct", {
                t("struct "), i(1, "Name"), t(" {"),
                t({ "", "\t" }), i(0),
                t({ "", "}" })
        }),

        -- Enum
        s("enum", {
                t("enum "), i(1, "Name"), t(" {"),
                t({ "", "\t" }), i(0),
                t({ "", "}" })
        }),

        -- Impl block
        s("impl", {
                t("impl "), i(1, "Name"), t(" {"),
                t({ "", "\tpub fn " }), i(2, "new"), t("() -> Self {"),
                t({ "", "\t\t" }), i(0),
                t({ "", "\t}" }),
                t({ "", "}" })
        }),

        -- Trait
        s("trait", {
                t("trait "), i(1, "TraitName"), t(" {"),
                t({ "", "\tfn " }), i(2, "method"), t("("), i(3), t(");"),
                t({ "", "}" })
        }),

        -- Derive
        s("derive", {
                t("#[derive("), i(1, "Debug, Clone"), t(")]"),
                t({ "", "" }), i(0)
        }),

        -- Test function
        s("test", {
                t("#[cfg(test)]"),
                t({ "", "mod tests {", "\tuse super::*;", "" }),
                t({ "\t#[test]", "\tfn " }), i(1, "test_name"), t("() {"),
                t({ "", "\t\t" }), i(0),
                t({ "", "\t}", "}" })
        }),

        -- Println
        s("pln", {
                t('println!("'), i(1, "{}"), t('", '), i(2), t(");")
        }),

        -- Result main
        s("rmain", {
                t("fn main() -> Result<(), Box<dyn std::error::Error>> {"),
                t({ "", "\t" }), i(0),
                t({ "", "\tOk(())", "}" })
        }),
}
