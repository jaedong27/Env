""""""""""""""""""""""""""
" Vundle
"""""""""""""""""""""""""""
"set rtp+=~/.vim/bundle/Vundle.vim
call plug#begin('~/.vim/plugged')
    "Plug 'VundleVim/Vundle.vim'
"    Plug 'git://git.wincent.com/command-t.git'
"    Plug 'file:///home/gmarik/path/to/plugin'

    Plug 'scrooloose/nerdtree' "Folder Path
    Plug 'jistr/vim-nerdtree-tabs'
    Plug 'airblade/vim-gitgutter' "git status
    Plug 'tyrannicaltoucan/vim-quantum' "Theme
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-fugitive' "show git branch
    Plug 'Townk/vim-autoclose'  "bracket auto close
    Plug 'tpope/vim-commentary' "code comment :#,#Commentary
    Plug 'Yggdroot/indentLine'
"    Plugin 'scrooloose/syntastic' "code syntax check
" Plugin 'vim-ruby/vim-ruby'
    Plug 'ervandew/supertab'    "show same bracket
    Plug 'severin-lemaignan/vim-minimap'
    Plug 'djoshea/vim-autoread' "reload file when the file is changed
    Plug 'slim-template/vim-slim'
    Plug 'christoomey/vim-tmux-navigator'
    Plug 'benmills/vimux'

    Plug 'Valloric/YouCompleteMe'  
call plug#end()

""Plugin 'jiangmiao/auto-pairs'

"""""""""""""""""""""""""""

" disable bells
autocmd! GUIEnter * set vb t_vb=

" Do not make vim compatible with vi.
set nocompatible

" Do not create .swp files
set noswapfile

" Number the lines.
set number

" Show auto complete menus.
set wildmenu

" Make wildmenu behave like bash completion. Finding commands are so easy now.
set wildmode=list:longest

" Enable mouse pointing
set mouse=a

" ALWAYS spaces
set expandtab

" Fix backspace behavior 
set backspace=indent,eol,start

" Use system clipboard 
set clipboard+=unnamed

" Keep Undo history on buffer change
set hidden

" Reload files after change on Disk
"set autoread
"au CursorHold * checktime

" Turn on syntax hightlighting.
"set syntax=on
syntax on
filetype plugin indent on
set nowrap
set tabstop=4     "하나의 탭을 몇칸으로 할 것인가?
set shiftwidth=4  "<<, >>를 했을때 몇칸 이동할것인가?
set cindent       "cindent on
set ai            "Autoindent
set et            "TAB을 모두 space로 대체한다.

" Speed optimization
set ttyfast
set lazyredraw

set encoding=utf-8
" Theme
" set t_ut=
set background=dark
let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"
set termguicolors
colorscheme quantum
set guifont=DejaVu\ Sans\ Mono\ for\ Powerline:h14

" Airline
set laststatus=2
let g:airline#extensions#tabline#enabled=1
"let g:airline_theme='bubblegum'
let g:airline_theme='quantum'
let g:airline_powerline_fonts=1
let g:airline#extensions#branch#enabled=1

" Indent Guides
let g:indentLine_enabled=1
let g:indentLine_color_term=235
let g:indentLine_char='┆'

" Syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list=1
let g:syntastic_auto_loc_list=1
let g:syntastic_check_on_open=1
let g:syntastic_check_on_wq=0

" Start Minimap
"autocmd VimEnter * Minimap

" Delete buffer while keeping window layout (don't close buffer's windows).
" Version 2008-11-18 from http://vim.wikia.com/wiki/VimTip165
if v:version < 700 || exists('loaded_bclose') || &cp
    finish
endif
let loaded_bclose = 1
if !exists('bclose_multiple')
    let bclose_multiple = 1
endif

" Display an error message.
function! s:Warn(msg)
  echohl ErrorMsg
  echomsg a:msg
  echohl NONE
endfunction

" Close buffer properly with NERDtree
" http://stackoverflow.com/questions/1864394/vim-and-nerd-tree-closing-a-buffer-properly
"
" Command ':Bclose' executes ':bd' to delete buffer in current window.
" The window will show the alternate buffer (Ctrl-^) if it exists,
" or the previous buffer (:bp), or a blank buffer if no previous.
" Command ':Bclose!' is the same, but executes ':bd!' (discard changes).
" An optional argument can specify which buffer to close (name or number).
function! s:Bclose(bang, buffer)
    if empty(a:buffer)
        let btarget = bufnr('%')
    elseif a:buffer =~ '^\d\+$'
        let btarget = bufnr(str2nr(a:buffer))
    else
        let btarget = bufnr(a:buffer)
    endif

    if btarget < 0
        call s:Warn('No matching buffer for '.a:buffer)
        return
    endif
    if empty(a:bang) && getbufvar(btarget, '&modified')
        call s:Warn('No write since last change for buffer '.btarget.' (use :Bclose!)')
        return
    endif
    " Numbers of windows that view target buffer which we will delete.
    let wnums = filter(range(1, winnr('$')), 'winbufnr(v:val) == btarget')
    if !g:bclose_multiple && len(wnums) > 1
        call s:Warn('Buffer is in multiple windows (use ":let bclose_multiple=1")')
        return
    endif
    let wcurrent = winnr()
    for w in wnums
        execute w.'wincmd w'
        let prevbuf = bufnr('#')
        if prevbuf > 0 && buflisted(prevbuf) && prevbuf != w
            buffer #
        else
            bprevious
        endif
        if btarget == bufnr('%')
            " Numbers of listed buffers which are not the target to be deleted.
            let blisted = filter(range(1, bufnr('$')), 'buflisted(v:val) && v:val !=btarget')
            " Listed, not target, and not displayed.
            let bhidden = filter(copy(blisted), 'bufwinnr(v:val) < 0')
            " Take the first buffer, if any (could be more intelligent).
            let bjump = (bhidden + blisted + [-1])[0]
            if bjump > 0
                execute 'buffer '.bjump
            else
                execute 'enew'.a:bang
            endif
        endif
    endfor
    execute 'bdelete'.a:bang.' '.btarget
    execute wcurrent.'wincmd w'
endfunction

command! -bang -complete=buffer -nargs=? Bclose call <SID>Bclose('<bang>','<args>')
nnoremap <silent> <Leader>bd :Bclose<CR>
nnoremap <silent> <Leader>bD :Bclose!<CR>

" Chain vimgrep and copen
augroup qf
    autocmd!
    autocmd QuickFixCmdPost [^l]* cwindow
    autocmd QuickFixCmdPost l*    cwindow
    autocmd VimEnter        *     cwindow
augroup END

" Change cursor appearance depending on the current mode
let &t_SI = "\<Esc>]50;CursorShape=1\x7"
let &t_SR = "\<Esc>]50;CursorShape=2\x7"
let &t_EI = "\<Esc>]50;CursorShape=0\x7"

""""""""""""""""""""""""""
" Custom bindings
""""""""""""""""""""""""""

" Browse airline tabs
:nnoremap <C-u> :bprevious<CR>
:nnoremap <C-i> :bnext<CR>

" Map Control S for save
" noremap <silent> <C-S> :update<CR>
" vnoremap <silent> <C-S> <C-C>:update<CR>
" inoremap <silent> <C-S>  <C-O>:update<CR>

" Comment block
vnoremap <silent> <C-n> :Commentary<cr>

" Close current buffer
noremap <silent> <C-q> :Bclose!<CR>

" Toggle Nerdtree
noremap <silent> <C-o> ::NERDTreeToggle<CR>

" Select all
" map <C-a> <esc>ggVG<CR>

" https://blog.bugsnag.com/tmux-and-vim/#related-reading
" Add Vertical Mode
" vv to generate new vertical split
"nnoremap <silent> vv <C-w>v

"" Prompt for a command to run
"map <Leader>vp :VimuxPromptCommand<CR>
"noremap <silent> <F7> :VimuxPromptCommand<CR>

"" Run last command executed by VimuxRunCommand
"map <Leader>vl :VimuxRunLastCommand<CR>
""noremap <silent> <F7> :VimuxRunLastCommand<CR>

"" Inspect runner pane
"map <Leader>vi :VimuxInspectRunner<CR>

"" Zoom the tmux runner pane
"map <Leader>vz :VimuxZoomRunner<CR>
""noremap <silent> <F5> :VimuxZoomRunner<CR>

"" Close vim tmux runner opend by VimuxRuncommand
"map <Leader>vq :VimuxCloseRunner<CR>
""noremap <silent> <F8> :VimuxCloseRunner<CR>

