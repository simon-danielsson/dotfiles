#!/usr/bin/env bash

lang="
 bash
 html
 c
 javascript
 rust
 lua
 haskell
 csharp
 cpp
 python
 java
 ruby
󰟓 go
"

git="
 git
 github
 gitadd
 gitbranch
 gitdiff
 gitignore
 gitmodify
 gitdelete
 gitrename
 gitrepo
󰘬 gitunmerged
󰞋 gituntracked
 gitunstaged
 gitstaged
 gitconflict
"

os="
 applemac
 linux
 voidlinux
󰣇 archlinux
 windows
 android
"

apps="
 neovim
 vim
 emacs
 github
 gitlab
 firefox
 steam
 terminal
"

arrows="
 arrow-right
 arrow-up
 arrow-down
 arrow-left
 arrow-right
 arrow-left
 arrow-up
 arrow-down
"

files="
 folder
 folder-open
 file-doc
 file
 file-copy
 dir-copy
 file-image
 file-video
"

sys="
 disk
 search
 clipboard
 user
"

web="
 download
 rss
 cloud
 database
 inbox
"

other="
 file-outline
 flask
 code
 time-clock
 openhand
 rocket
 pen
 config
󱠓 brush
󰃣 brush
󱝱 brush-x
 brush
 roller
 paintcan
"

ui="
 check
 cross
 warning
 tick
 cross
 help
 info
 alert

"

unsorted="

 file-pdf
 arrow-down
 arrow-up
 link
 shuffle
 message
󱧾 image-refresh
 loop-refresh
 loop-refresh
 power
 cart
 record
 record
 view-eye
 expand
 view-eye
 redo
 calendar
 search
󰍺 multiple-monitors
󰍹 monitor
 gear
 home
 globe
 mail
 music-headphones
 music
 note
 camera
 image
 film
 volume
 microphone
 battery
 wifi
 database
 clock
󰥔 clock-filled
 dot
 users
 link
 user
 gamepad
 bar-chart
 line-chart
 pie-chart
 circle
 cross
 question
 info
 delta
 epsilon
 phi
 plus
 minus
 exclamation
 alert
 key
󰨙 toggleoff
󰔡 toggleon
 gift
󰈙 document
󱪝 new document
 lock
 mail
 bookmark
 target
 warning
 redo
 calendar
 pen
 magnet
"

devicons="
$unsorted
$os
$ui
$git
$web
$lang
$apps
$files
$arrows
"

selected=$(printf "%s\n" "$devicons" \
	| fzf --prompt="devicon > " --height=40% --reverse) || exit 0

icon_char=$(printf "%s" "$selected" | awk '{print $1}')

printf "%s" "$icon_char" | pbcopy
printf "%s" "$icon_char"
