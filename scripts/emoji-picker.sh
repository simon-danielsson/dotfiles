#!/usr/bin/env bash

emoji_list="
😀 grinning face
🟢 circle green
🔵 circle blue
🔴 circle red
🟣 circle purple magenta
😃 grinning face big eyes
🎨 paint easel
😄 grinning smiling eyes
😁 beaming smile
😆 squinting laugh
😅 nervous laugh
😂 tears of joy
🤣 rolling laugh
🙂 slight smile
🙃 upside down
😉 wink
😊 smiling eyes
😇 halo
🥰 smiling hearts
😍 heart eyes
🤩 star struck
😘 blowing kiss
😗 kiss
😚 closed eyes kiss
😙 smiling kiss
😋 yummy
😛 tongue
😜 winking tongue
🤪 zany
😝 squint tongue
🤗 hugging
🤔 thinking
🤨 raised eyebrow
😐 neutral
😑 expressionless
😶 no mouth
🙄 eye roll
😏 smirk
😒 unamused
😬 grimace
😮 open mouth
😲 astonished
😴 sleeping
🤤 drooling
😪 sleepy
😵 dizzy
🤯 exploding head
🥵 hot face
🥶 cold face
😳 flushed
🥺 pleading
😭 crying
😢 sad
😤 steam nose
😡 angry
😠 mad
🤬 swearing
😈 smiling devil
👿 angry devil
💀 skull
☠ skull crossbones
👻 ghost
👽 alien
🤖 robot

👍 thumbs up
👎 thumbs down
👌 ok hand
✌ victory
🤞 crossed fingers
🤟 love you
🤘 rock on
👏 clap
🙌 raised hands
🙏 pray
💪 muscle
🧠 brain
👀 eyes
🫀 heart organ
🫁 lungs

❤️ red heart
🧡 orange heart
💛 yellow heart
💚 green heart
💙 blue heart
💜 purple heart
🖤 black heart
🤍 white heart
🤎 brown heart
💔 broken heart
💕 two hearts
💖 sparkling heart
💘 heart arrow

🔥 fire
💧 droplet
🌊 wave
🌪 tornado
⚡ lightning
☀ sun
🌙 moon
⭐ star
✨ sparkles
💥 explosion
☁ cloud
❄ snowflake

✔ check
✅ check box
❌ cross
⚠ warning
🚫 prohibited
⛔ no entry
♻ recycle
🔒 lock
🔓 unlock
🔑 key
🗑 trash
📦 package
📁 folder
📂 open folder
📝 memo
📌 pin
📎 paperclip
🖊 pen
📊 chart
📈 upward chart
📉 downward chart

💻 laptop
🖥 desktop
🖱 mouse
⌨ keyboard
📱 phone
🔋 battery
🔌 plug
🧮 abacus
💾 floppy
🗄 file cabinet
🛠 hammer wrench
⚙ gear
🐧 linux penguin
🦀 crab (rust)
🐍 snake (python)
☕ coffee
🍺 beer
🍷 wine
🍕 pizza
🍔 burger
🍟 fries

🐶 dog
🐱 cat
🐭 mouse
🐹 hamster
🐰 rabbit
🦊 fox
🐻 bear
🐼 panda
🐨 koala
🐯 tiger
🦁 lion
🐮 cow
🐷 pig
🐸 frog
🐵 monkey
🐔 chicken
🐧 penguin
🐦 bird
🐤 chick
🐺 wolf
🦄 unicorn

🚀 rocket
🛸 ufo
🗿 moai
🎉 party
🎊 confetti
🎶 music
🎧 headphones
📢 loudspeaker
🔔 bell
🕒 clock
🧭 compass
🗺 map
🏁 finish flag
"

selected=$(printf "%s\n" "$emoji_list" \
    | fzf --prompt="emoji > " --height=40% --reverse) || exit 0

emoji_char=$(printf "%s" "$selected" | awk '{print $1}')

printf "%s" "$emoji_char" | pbcopy
printf "%s" "$emoji_char"
