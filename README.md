## A swedish development environment.
  
### Computer 
I use an Apple Macbook Pro M3 (2023) for everything that I do - but I also use some different Linux machines as well. On my Linux machines I'm using voidlinux/i3 (the most perfect workflow that exists), and I'm emulating that workflow on my mac by using tools such as [aerospace](https://github.com/nikitabobko/AeroSpace) and [simplebar](https://github.com/Jean-Tinland/simple-bar).
  
I live in the terminal most of the time, and my philosophy regarding terminal tools is that my most commonly used programs should be created by myself - tools such as ls, [cloc](https://github.com/AlDanial/cloc), issue tracking, the bash prompt and so on. Not out of necessity of course; I just think it's fun to build my own tooling since it's an easy gateway into learning more about how computers work and why/how our tools work the way they do!
  
---
  
### Keyboard
My keyboard is a [Keebart Corne Choc Pro](https://www.keebart.com/products/corne). For this keyboard I use my own rearranged version of the Workman layout (you can see in my neovim config that I've remapped 'hjkl' to 'neoi').
  
---
  
### Development setup
I had previously been using ghostty/tmux as my main development setup, but as of march 2026 I have switched to [cmux](https://github.com/manaflow-ai/cmux). Cmux offers a sleeker appearance, has more sensible defaults than tmux, and still uses ghostty as a backend.
  
My neovim config is based around a no-plugins philosophy - lsp, completion, pickers, syntax highlighting and so on is all being done through native means. This is because I'm of the opinion that neovim feels a bit snappier and responsive with no plugins installed. I also like keeping my entire config contained in a single file for the sake of portability.
  
#### Features of my neovim config
- netrw sensible defaults
- file templates
- in-editor annotations
- grep picker via quickfix
- oldfiles picker via quickfix
- buffer picker via quickfix
- native implementation of [flash.nvim](https://github.com/folke/flash.nvim)
- native implementation of [autopairs](https://github.com/windwp/nvim-autopairs)
- custom theme based on 'habamax'
- rust/c/python compilation keybind for iterative development, integrated with built-in terminal
- easy native lsp setup with completion and auto-formatting
- basic custom snippet support
- better indent guides


