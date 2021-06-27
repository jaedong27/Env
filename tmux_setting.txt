- Mac은 tmux등등이 알아서 256으로 설정되서 동작하는듯
아래 내용 추가

#.tmux.conf
# Terminal type configuration

set -g default-terminal "screen-256color"

set -ga terminal-overrides ",xterm-256color:Tc"

#.vimrc
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"

let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

set termguicolors

- Ubuntu에서 세팅시에는 몇개 더 해야함 Tmux Setting
출처 : https://unix.stackexchange.com/questions/197391/background-color-mismatch-in-vim-and-tmux
#After adding the line below into .tmux.conf
set -g default-terminal "screen-256color"
#You still need to add the line below into .vimrc
set term=screen-256color
#Finally, the alias need to be added to .bashrc
alias tmux='tmux -2'


ubuntu 에선 minimap 동작 안함
지워주어야 함

UTF 한글로 하는거 만들어 줘야
NERD Tree가 동작함
