<p align="center">
  <img src="media/simvim.png" width="300">
</p>

**SIMVIM** is my personal development environment tailored for Rust and Python, as well as GDScript. My focus lies on leveraging the native features of Neovim and TMUX before resorting to plugins, ensuring a relatively lightweight setup.

> ⚠️ This is **not** intended to be installed as a complete config - instead, I recommend that you sift through these files and take inspiration; copy-paste what you like into your own setup.

![1](media/1.png)
![2](media/2.png)

## 🖥️ TMUX `.tmux.conf`
- ⌨️ Prefix: `Ctrl-a`
- 🖱️ Mouse support for when you're feeling treacherous.
- 📊 Status bar: session name, time, load average.

## 🐚 Zsh `.zshrc`
Zsh is my shell of choice. I've set it up so that a new zsh instance will automatically attach to a TMUX session called `main` - if there is none already running, a new `main` TMUX session will be created. This ensures I am always inside TMUX when I start my terminal emulator.

### Zsh Aliases `zsh_aliases.zsh`
- 🐍 **`p`**: `python3 *.py`
- 🦀 **`r`**: `cargo run --release`
- 🦀 **`rd`**: `cargo doc --open`
- 🕹️ **`gd`**: Launches a script that starts Godot and Neovim ( through `gv` ) together.
- 🚀 **`gv`**: Launches a script that starts Neovim piped to a local Godot LSP server.
- 📔 **`journal`**: Starts Neovim with a new Typst file using a template - this is automatically titled to the current date and saved in `~/journal`. This makes for effortless journaling, so that I can focus on writing down my thoughts without friction.
- 💀 **`q`**: Launches a script that kills all Neovim and TMUX sessions.
- 📂 **`ls`**: `eza --color=always --icons --group-directories-first --git --no-time --no-permissions`
- 🔍 **`ss`**: Launches fzf with preview window - built-in logic so that if a *directory* is selected you cd into it, but if a *file* is selected you open it in Neovim. Searches from the global directory regardless of `cwd`.
- 🔍 **`s`**: The same logic as `ss`, but only searches through the current directory.

### Scripts `scripts/`
- 💀 **kill-nvim-and-tmux.sh**: Kills all Neovim and TMUX processes.
- 🚀 **start-godot-and-nvim-together.sh**: Opens Godot together with Neovim.
- 🔧 **start-nvim-with-godotpipe.sh**: Starts Neovim with GodotPipe for editing GDScript with Godot.

## 📝 Neovim `.config/nvim/`
Using **v0.12 nightly** with Lua modules for modularity and `vim.pack` as the plugin manager.

### Core Init `init.lua`
- ⚙️ Sets the load-order of native settings, UI, plugins and LSP.
- 📌 Dynamically renames TMUX windows based on buffer.
- 🎨 Switch between the colorschemes defined in **ui/theme.lua** using a numbering system.
- 🌗 Toggle background transparency with a true/false variable.

### Native `lua/native/`

<details>
  <summary>🔱 trident.lua</summary>

<img src="media/trident.gif" width="400" />

A Neovim-native interpretation of [harpoon](https://github.com/ThePrimeagen/harpoon/tree/harpoon2).
- Buffers can not be added manually like in harpoon, but are instead added and subtracted from the list automatically.
- A maximum of 6 buffers are allowed on the list at once (to minimize visual noise) - this is easily configurable if you find it limiting.
- The list automatically rotates sequentially when any listed buffers are closed or deleted.
- Uses **nvim-web-devicons** to get filetype icons in the list - if **nvim-web-devicons** is malfunctioning or isn't installed, Trident defaults to a configurable fallback icon to avoid errors.
- Hit the prefix `"` to initiate Trident, then hit the number corresponding to the buffer you wish to open. The prefix is easily altered within **trident.lua**.

</details>

<details>
  <summary>🔍 vim_hover_win.lua</summary>

<img src="media/lsp_hover_win.gif" width="400" />

- Quick reference at cursor hover.
- Configurable max window size and width.
- No toggle, always on. To turn it off, do so manually in **init.lua**.

</details>

<details>
  <summary>🚀 autocmds.lua</summary>

#### Write & Formatting
- Autosave every 8th time normal mode is entered.
- Format buffer on save using LSP or Tree-sitter.
- Remove trailing whitespace, extra empty lines, and empty first lines.
- Export Typst files to PDF automatically.
- Make shell scripts executable on save.

#### File & Directory Management
- Load a template when opening a new file, if available.
- Automatically change working directory to current buffer's folder.
- Create directories automatically before saving files.
- Ensure undo directory exists.

#### Cursor Management
- Restore cursor position when reopening a buffer.
- Highlight cursorline in active windows (ignored for certain buffers).
- Temporarily highlight yanked text.

#### Terminal Management
- Automatically enter insert mode in terminal buffers.
- Close terminal buffer when the process exits.

#### User Interface Tweaks
- Disable automatic comment insertion on new lines.
- Enable spell checking for text, markdown, and Typst files.
- Fold paragraphs separated by empty lines.
- Hide statusline for Oil file explorer and restore afterward.
- Auto-resize splits when the window is resized.

#### Miscellaneous
- Suppress non-error notifications inside Oil buffers.

</details>

<details>
  <summary>📝 comment.lua</summary>

Native commenting logic.

</details>

<details>
  <summary>⌨️ keymaps.lua</summary>

Note that I'm using my own Swedish version of Workman on a 42-key split keyboard, so my keymaps may not make sense for someone with (for example) a qwerty US-layout.

</details>

<details>
  <summary>📁 netrw.lua</summary>

Customization for the built-in file explorer, including keymaps.

</details>

<details>
  <summary>🛠️ options.lua</summary>

Global Neovim options.

</details>

### Plugins `lua/plugins/`
- 🕹️ [**nvim-cmp**](https://github.com/hrsh7th/nvim-cmp)
- ✨ [**flash.nvim**](https://github.com/folke/flash.nvim)
- 📏 [**indent-blankline.nvim**](https://github.com/lukas-reineke/indent-blankline.nvim)
- 💬 [**noice.nvim**](https://github.com/folke/noice.nvim)
- 🔭 [**telescope.nvim**](https://github.com/nvim-telescope/telescope.nvim)
- 🖥️ [**nvim-lspconfig**](https://github.com/neovim/nvim-lspconfig)
- 🌳 [**nvim-treesitter**](https://github.com/nvim-treesitter/nvim-treesitter)
- 🔗 [**mini.surround**](https://github.com/echasnovski/mini.surround)
- ⏪ [**undotree**](https://github.com/mbbill/undotree)
- 🧰 [**mason.nvim**](https://github.com/williamboman/mason.nvim)
- 🔧 [**plenary.nvim**](https://github.com/nvim-lua/plenary.nvim)
- 🎨 [**nui.nvim**](https://github.com/MunifTanjim/nui.nvim)
- 🔔 [**nvim-notify**](https://github.com/rcarriga/nvim-notify)
- 📁 [**netrw.nvim**](https://github.com/prichrd/netrw.nvim)
- 🌟 [**nvim-web-devicons**](https://github.com/nvim-tree/nvim-web-devicons)
- 📚 [**friendly-snippets**](https://github.com/rafamadriz/friendly-snippets)
- ✂️ [**LuaSnip**](https://github.com/L3MON4D3/LuaSnip)
- 🗝️ **keymaps.lua**

### UI `lua/ui/`
- 🎉 **splash.lua**: A Neovim-native splashscreen.
    - Centered banner configurable in **theme.lua**.
    - Separate highlight groups for version, banner, and buttons - configurable in **theme.lua**.
    - Configurable quick-action buttons.
    - Neovim version display.
- 🎨 **theme.lua**: Defines custom color palette - configuring these colours allow you to change the colour style globally across Neovim.
- 🖌️ **colorscheme.lua**: Applies color overrides using the colors set in **theme.lua**.
- 🌟 **icons.lua**: Defines icons for statusline, telescope, etc., using Nerd Fonts.
- 📊 **statusline.lua**: Custom statusline displaying mode, file name, diagnostics, git branch, wordcount etc.

### Templates `templates/`
Template files for new buffers ( template application is defined in **autocmds.lua** ).
- 🐚 C
- 🔵 C++
- 🟨 Javascript
- 🌙 Lua
- 🐍 Python
- 🦀 Rust
- 🖋️ Typst
