# Things to figure out

### Movement

- [ ] selecting text/paragraphs to copy/cut/delete and/or move around

# Bindings

### Buffer navigation 

Next line               C-n        Previous line           C-p
Forwards one char       C-f        Backwards one char      C-b
Forwards one word       M-f        Backwards one word      M-b
Go to start of line     C-a        Go to end of line       C-e
Previous paragraph      M-a        Next paragraph          M-e
Center cursor           C-l
Go to start of buffer   Esc <      Go to end of buffer     Esc >

Go to line              C-u <relative line-number> <C-n | C-p>

### Editing 

I-Search (e.g grep)     C-s        Cycle search results    C-s
Revert changes          s-u        Set mark                C-. (or C-,)
Comment line            C-'

### Windows 

Close all but current   s-W        Close window            s-w
Split vertical          s-d        Split horizontal        s-D
Move to left window     s-N        Move to right window    s-I
Move to top window      s-O        Move to bottom window   s-E

### Git (Magit)

Open Magit              C-x g      Commit (magit)          c
Stage (magit)           s          Stage all (magit)       S
Commit (magit)          c          Save commit (in commit) C-c C-c

### Terminal

Open terminal (vterm)   s-t        Copy mode toggle        C-c C-t

### Buffers 

List all buffers       C-c b       List bookmarks          C-x r l
Create bookmark        C-x r m     Jump to bookmark        C-x r b

### Files 

Dired edit toggle       C-x C-q    Dired browser           C-x d
List directory          C-x C-d    Find / create file      C-x C-f
Save file               C-x C-s    Dired in current buff   C-x C-j
Dired edit filenames    C-x C-q    Dired toggle details    (

### Compile 

Compile project        C-c c       Run shell command       C-c s
