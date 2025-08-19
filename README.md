# A Swedish Development Environment

This repository contains my personal dotfiles for a minimal and maintainable development environment tailored for Rust and Python, as well as GDScript. My focus is on leveraging the native features of Neovim and TMUX before resorting to plugins, ensuring a relatively lightweight setup.
What makes this config unique is its Swedish flair—optimized for Swedish keyboard layouts (e.g., easy access to å, ä, ö in keymaps). But note that I'm using my own modified version of the Workman keyboard layout on a 42-key split keyboard, so my keymaps may not make sense for someone with a full-size qwerty keyboard.

> Note that this is **not** intended to be installed as a complete config - instead, I recommend that you sift through these files and take inspiration; copy-paste what you like into your own setup.

## Screenshots
<style>
.tabs { display: flex; gap: 10px; margin-bottom: 10px; }
.tab { padding: 5px 10px; border: 1px solid #ccc; cursor: pointer; }
.tab.active { background: #eee; }
.tab-content { display: none; }
.tab-content.active { display: block; }
</style>
<div class="tabs">
  <div class="tab active" onclick="showTab(1)">1</div>
  <div class="tab" onclick="showTab(2)">2</div>
  <div class="tab" onclick="showTab(3)">3</div>
</div>
<div id="tab1" class="tab-content active">
  <img src="screenshots/1.png" alt="">
</div>
<div id="tab2" class="tab-content">
  <img src="screenshots/2.png" alt="">
</div>
<div id="tab3" class="tab-content">
  <img src="screenshots/3.png" alt="">
</div>

<script>
function showTab(n) {
  document.querySelectorAll('.tab, .tab-content').forEach(el => el.classList.remove('active'));
  document.querySelectorAll('.tab')[n-1].classList.add('active');
  document.getElementById('tab'+n).classList.add('active');
}
</script>

## TMUX Configuration (.tmux.conf)

This file sets up TMUX for efficient session management.
- Uses native TMUX features for splitting panes, resizing, and navigation.
- Prefix: Ctrl-a
- Mouse support enabled for when you're feeling lazy.
- Status bar customized with minimal info: session name, time, and load average.

## Zsh (.zshrc)

Zsh is my shell of choice. I've set it up so that a new zsh instance will automatically attach to a TMUX session called "main" - if there is none already running, a new "main" TMUX session will be created. This ensures I am always inside TMUX when I start my terminal emulator.

### Zsh Aliases (zsh_aliases.zsh)
- **`p`**: `python3 *.py`
- **`r`**: `cargo run --release`
- **`rd`**: `cargo doc --open`
- **`gd`**: Launches a script that starts Godot and neovim ( through **gv** ) together.
- **`gv`**: Launches a script that starts godot piped to the local godot LSP server.
- **`journal`**: Starts neovim with a new typst file using a template - this is automatically titled to the current date and saved in `~/journal`. This makes for effortless journaling, so that I can focus on writing down my thoughts without friction.
- **`q`**: Launches a script that kills all neovim sessions, and then all tmux sessions, which ultimately also ends up closing down the Ghostty instance.
- **`ls`**: `eza --color=always --icons --group-directories-first --git --no-time --no-permissions`
- **`ss`**: Launches fzf with preview window - built-in logic so that if a directory is selected you cd into it, but if a file is selected you open it in neovim. Searches from the global directory regardless of `cwd`.
- **`s`**: The same logic as `ss`, but it only searches through the current directory.

## Neovim Configuration (.config/nvim/)

v0.12 nightly build. Configured in Lua modules for modularity. Uses vim.pack as the plugin manager.
### Core Init (init.lua)
- Loads native settings, UI, plugins, and LSP from modules.
- Function that renames TMUX windows dynamically after the currently open buffer.

### Native Features (lua/native/)

- **autocmds.lua**: Loads and loads of autocommands.
- **comment.lua**: Native commenting with gc/gb motions.
- **keymaps.lua**: Keymaps.
- **netrw.lua**: Built-in file explorer customization.
- **options.lua**: Global options.

### Plugins (lua/plugins/)

- [**nvim-cmp**](https://dotfyle.com/plugins/hrsh7th/nvim-cmp): Completion engine.
- [**flash.nvim**](https://dotfyle.com/plugins/folke/flash.nvim): Like `/` but quicker and flashier.
- [**indent-blankline.nvim**](https://dotfyle.com/plugins/lukas-reineke/indent-blankline.nvim): Indent guides.
- [**noice.nvim**](https://dotfyle.com/plugins/folke/noice.nvim): Prettier notifications, cmdline and popupmenu.
- [**telescope.nvim**](https://dotfyle.com/plugins/nvim-telescope/telescope.nvim): Fuzzy finder for files, grep, buffers.
- [**nvim-lspconfig**](https://dotfyle.com/plugins/neovim/nvim-lspconfig): LSP!
- [**nvim-treesitter**](https://dotfyle.com/plugins/nvim-treesitter/nvim-treesitter): Syntax highlighting and parsing.
- [**mini.surround**](https://dotfyle.com/plugins/echasnovski/mini.surround): Quick surround with ys/cs/ds for quotes, tags, etc.
- [**undotree**](https://github.com/mbbill/undotree): Visual undo tree.
- [**mason.nvim**](https://dotfyle.com/plugins/williamboman/mason.nvim): Package manager for LSP, formatters, linters etc.
- [**plenary.nvim**](https://dotfyle.com/plugins/nvim-lua/plenary.nvim): Utility.
- [**nui.nvim**](https://dotfyle.com/plugins/MunifTanjim/nui.nvim): Utility.
- [**nvim-notify**](https://dotfyle.com/plugins/rcarriga/nvim-notify): Utility.
- **keymaps.lua**: Keymaps specific to plugins.

### UI Customizations (lua/ui/)

- **colors.lua**: Defines custom color palette, configuring these colours allow you to change the colour style globally across neovim.
- **colorscheme.lua**: Applies a custom theme based on hl-groups, using the neovim built-in theme `retrobox` as a foundation.
- **icons.lua**: Defines icons for statusline, telescope, etc., using Nerd Fonts.
- **statusline.lua**: Custom statusline showing mode, file name, LSP diagnostics, git branch, wordcount etc.

### Templates (templates/)

Skeleton files for new buffers (defined in autocmds.lua):
- **template.py**: Basic Python script with `if __name__ == "__main__"`.
- **template.typ**: Typst template for writing simple text documents.

## Scripts (scripts/)

Utility bash scripts:
- **kill-nvim-and-tmux.sh**: Kills all Neovim and TMUX processes cleanly.
- **start-godot-and-nvim-together.sh**: Opens Godot engine and Neovim, auto-loading GDScript files.
- **start-nvim-with-godotpipe.sh**: Starts Neovim with GodotPipe for seamless GDScript editing with Godot.
