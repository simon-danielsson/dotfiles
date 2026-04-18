#!/usr/bin/env bash

readme=./README.md

touch $readme

cat > "$readme" <<EOF
<p align="center">
    <h2> Template </h2>
</p>

<p align="center">
  <em>Description</em>
</p>

<p align="center">
    <img src="https://img.shields.io/crates/v/brakoll?style=flat-square&color=blueviolet&link=https%3A%2F%2Fcrates.io%2Fcrates%brakoll" alt="Crates.io version" />
    <img src="https://img.shields.io/badge/license-MIT-green?style=flat-square" alt="MIT License" />
  <img src="https://img.shields.io/github/last-commit/simon-danielsson/brakoll/main?style=flat-square&color=blue" alt="Last commit" />
</p>

<p align="center">
  <a href="#info">Info</a> •
  <a href="#install">Install</a> •
  <a href="#usage">Usage</a>
  <br>
  <a href="#dependencies">Dependencies</a> •
  <a href="#license">License</a>
</p>

---
<div id="info"></div>

## Information

Information

---
<div id="install"></div>

## Install

``` bash
cargo install brakoll
```

---
<div id="usage"></div>

## Usage

### Adding a new issue

The core philosophy of Brakoll is that issues are opened, closed and edited **inside the codebase itself**. Issues live in the codebase and are not dependent on an internet-connection, or you having to pay a subscription fee at the end of every month. When you want to add something to your issue list you simply type it out in your project, perhaps next to relevant code (tip: create a snippet for this; for example "issue").

``` rust
// *brakoll - d: fix typo in debug print, p: 10, t: debug, s: closed
fn debug() {
    println!("debugG")
}
```

- d: description of the issue (obligatory)
- p: priority from 0 to infinity where the highest number takes priority (optional - fallback: 0)
- t: tag (optional - fallback: n/a)
- s: status [ (op)en | (pr)ogress | (cl)osed ] (optional - fallback: open)

The status value can also take abbreviations (op, pr & cl).

> [!IMPORTANT]
> * An issue line is any line containing the prefix "*brakoll".
> * Everything before the prefix on an issue line is ignored by the parser.
> * Everything after the prefix is parsed as metadata.
> * Multiple tags are not supported - this is by design, to force clarity when opening issues!

### Workflow integration

Here's a way to integrate Brakoll into your neovim config using luasnip:

``` lua
local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node

return {
    s("issue", {
        t("*brakoll - d: "), i(1),
        t(", p: "), i(2),
        t(", t: "), i(3),
        t(", s: open"),
    }),
}
```

Here's a way to integrate Brakoll into git using a bash alias:

``` bash
unalias commit 2>/dev/null
commit() {
    local id="$1"
    brakoll close $id
    brakoll cp $id

    if command -v pbpaste >/dev/null; then
        clip=$(pbpaste)
    elif command -v xclip >/dev/null; then
        clip=$(xclip -o -selection clipboard)
    elif command -v wl-paste >/dev/null; then
        clip=$(wl-paste)
    fi

    git add --all
    git commit -a -m "$clip"
}
```

**My development workflow with Brakoll looks like this:**
1. Create a new issue within the codebase.
2. When I want to work on the issue, I set its status to "in progress" either directly in the code or through the CLI.
3. Finish working on the issue.
4. Run command `brakoll` (with relevant filter flags if necessary) to find its id number.
5. Run bash script `commit <id>` to close the issue and commit it to git.
6. Run command `brakoll summary` every once in a while to track my progress.
7. Rinse and repeat.

---
<div id="subc"></div>

## Subcommands and flags

All the issues listed, sorted by priority and status (the current directory is scanned recursively by default):

``` terminal
brakoll
```

An optional target path can be added (works alongside other flags):

``` terminal
brakoll <relative path>
```

Filter issues by tag:

``` terminal
brakoll -t <tag>
```

Filter issues by status:

``` terminal
brakoll -s <status>
```

Filter issues by description:

``` terminal
brakoll -d <keyword>
```

Limit scan to shallow depth (i.e. no recursion):

``` terminal
brakoll -r
```

Summary of all issues:

``` terminal
brakoll summary
```

Copy issue details to clipboard with formatting: "tag (file:line): desc".
This is to reduce the friction of writing git commit messages manually.

``` terminal
brakoll copy <id>
brakoll cp <id>
```

Close issue through CLI:

``` terminal
brakoll closed <id>
brakoll close <id>
brakoll cl <id>
```

Open issue through CLI:

``` terminal
brakoll open <id>
brakoll op <id>
```

Progress issue through CLI:

``` terminal
brakoll prog <id>
brakoll pr <id>
brakoll progress <id>
```

Display help and version information:

``` terminal
brakoll help
```

---
<div id="license"></div>

## License
This project is licensed under the [MIT License](https://github.com/simon-danielsson/brakoll/blob/main/LICENSE).

---
<div id="dependencies"></div>

## Dependencies

- [walkdir](https://github.com/BurntSushi/walkdir)
- [dirs](https://codeberg.org/dirs/dirs-rs)
- [cli-clipboard](https://github.com/allie-wake-up/cli-clipboard)
EOF

