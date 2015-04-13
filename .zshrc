#----------------------------------------------------------#
#                                                          #
#                         $$\                              #
#                         $$ |                             #
#     $$$$$$$$\  $$$$$$$\ $$$$$$$\   $$$$$$\   $$$$$$$\    #
#     \____$$  |$$  _____|$$  __$$\ $$  __$$\ $$  _____|   #
#       $$$$ _/ \$$$$$$\  $$ |  $$ |$$ |  \__|$$ /         #
#      $$  _/    \____$$\ $$ |  $$ |$$ |      $$ |         #
#     $$$$$$$$\ $$$$$$$  |$$ |  $$ |$$ |      \$$$$$$$\    #
#     \________|\_______/ \__|  \__|\__|       \_______|   #
#                                                          #
#----------------------------------------------------------#

#!/usr/local/bin/zsh
# 文字コードの設定
export LC_CTYPE=ja_JP.UTF-8
export LANG=ja_JP.UTF-8
export JLESSCHARSET=japanese-sjis
export OUTPUT_CHARSET=utf-8
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
#----------------------------------------------------------
# エイリアス
alias sudo='sudo '
alias em='emacsclient -nw'
alias killem='emacsclient -e "(kill-emacs)"'
alias emd='emacs —daemon'
alias ls='ls -G'
alias pyg='pygmentize'
alias chrm='open -a Google\ Chrome'

# グローバルエイリアス
alias -g L='| less'
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g GI='| grep -i'
alias -g P='| peco'

#パスの設定
PATH=/Users/kitaguchiyoshinori/.rbenv/shims:/usr/local/bin:$PATH
export PATH

#----------------------------------------------------------
# emacs
#if pgrep emacs >/dev/null 2>&1; then
#    echo "Emacs server is already running..."
#else
#    `/usr/local/bin/emacs --daemon`
#fi

# no matches foundをなくす
setopt nonomatch

# 補完される前にオリジナルのコマンドまで展開してチェックする
setopt complete_aliases

# 別ファイル読み込み
[ -f ~/.zshrc.alias ] && source ~/.zshrc.alias

#----------------------------------------------------------
# 基本
#----------------------------------------------------------
# 色を使う
autoload -U colors; colors
# ビープを鳴らさない
setopt nobeep
# ビープを鳴らさない
setopt nolistbeep
# エスケープシーケンスを使う
setopt prompt_subst
# コマンドラインでも#以降をコメントと見なす
setopt interactive_comments
# vi風のキーバインド
# bindkey -v
bindkey -e
# C-s, C-qを無効にする
setopt no_flow_control
# 日本語のファイル名を表示可能
setopt print_eight_bit
# C-wで直前の/までを削除する
WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'
# ディレクトリを水色にする
export LS_COLORS='di=01;36'
# 色の設定
export LS_COLORS='di=34:ln=35:so=32:pi=33:ex=33:bd=46;34:cd=43;34:su=41;30:sg=46;30:tw=42;30:ow=43;30'
export LSCOLORS=ExFxCxdxBxegedabagacad
# zmv使う
autoload zmv


# --------------------------------------------------
#  オリジナルコマンド
# --------------------------------------------------
# ファイルの削除
# rmで~/.Trashに日付付きディレクトリを作成してそこにmv
# rmfで削除
function rmf() {
/bin/rm $@
}

function rm(){
for file in $*
do
  __rm_single_file $file
done
}

function __rm_single_file(){
local DATE=`date "+%y%m%d"`
if ! [ -d ~/.Trash/$DATE/ ]
then
  command /bin/mkdir ~/.Trash/$DATE/
fi
if ! [ $# -eq 1 ]
then
  echo "__rm_single_file: 1 argument required but $# passed."
  exit
fi
if [ -e $1 ]
then
  BASENAME=`basename $1`
  NAME=$BASENAME
  COUNT=0
  while [ -e ~/.Trash/$DATE/$NAME ]
  do
    COUNT=$(($COUNT+1))
    NAME="$BASENAME.$COUNT"
  done
  command /bin/mv $1 ~/.Trash/$DATE/$NAME
else
  echo "No such file or directory: $file"
fi
}

# 空でEnter押すとlsとgit status表示
function do_enter() {
if [ -n "$BUFFER" ]; then
  zle accept-line
  return 0
fi
echo
ls
#ls_abbrev
if [ "$(git rev-parse --is-inside-work-tree 2> /dev/null)" = 'true' ]; then
    echo
    echo -e "\e[0;33m--- git status ---\e[0m"
    git status -sb
fi
zle reset-prompt
return 0
}
zle -N do_enter
bindkey '^m' do_enter

#----------------------------------------------------------
# 補完関連
#----------------------------------------------------------
# 補完機能を強化
autoload -Uz compinit; compinit -u
# URLを自動エスケープ
# auto-fuと競合する
autoload -Uz url-quote-magic; zle -N self-insert url-quote-magic
# TABで順に補完候補を切り替える
setopt auto_menu
# 補完候補を一覧表示
setopt auto_list
# 補完で大文字小文字の区別をしない
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
# 補完候補をEmacsのキーバインドで動けるように
zstyle ':completion:*:default' menu select=1
zstyle ':completion:*' list-colors ''
# --prefix=/usrなどの=以降も補間
setopt magic_equal_subst
# ディレクトリ名の補間で末尾の/を自動的に付加し、次の補間に備える
setopt auto_param_slash
## 補完候補の色付け
#eval `dircolors`
export ZLS_COLORS=$LS_COLORS
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
# 補完候補を詰めて表示
setopt list_packed
# 補完候補一覧でファイルの種別をマーク表示
setopt list_types
# 最後のスラッシュを自動的に削除しない
setopt noautoremoveslash
# スペルチェック
setopt correct
# killコマンドでプロセスを補完
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([%0-9]#)*=0=01;31'

#----------------------------------------
# 予測の先読み
# -U オプション:既存の関数を読み込むときに、自分で定義した alias によってその関数の内容が書き換えられることを防ぐ
# うっとうしい！！！
# autoload -U predict-on
# zle-line-init() { predict-on }
# zle -N zle-line-init
# zle -N predict-on
# zle -N predict-off
# # C-x uでon
# # C-x iでoff
# bindkey '^xu' predict-on
# bindkey '^xi' predict-off
# # コマンドライン編集中は予測しない
# zstyle ':predict' toggle true
# 予測のon/offの切り替わりを表示
# zstyle ':predict' verbose true
#----------------------------------------------------------
# 移動関連
#----------------------------------------------------------
# ディレクトリ名でもcd
setopt auto_cd
# cdのタイミングで自動的にpushd.直前と同じ場合は無視
setopt auto_pushd
setopt pushd_ignore_dups

#----------------------------------------------------------
# 履歴関連
#----------------------------------------------------------
# 履歴の保存先
HISTFILE=$HOME/.zsh-history
# メモリに展開する履歴の数
HISTSIZE=100000
# 保存する履歴の数
SAVEHIST=100000
# ヒストリ全体でのコマンドの重複を禁止する
setopt hist_ignore_dups
# コマンドの空白をけずる
setopt hist_reduce_blanks
# historyコマンドはログに記述しない
setopt hist_no_store
# 先頭が空白だった場合はログに残さない
setopt hist_ignore_space
# 履歴ファイルに時刻を記録
setopt extended_history
# シェルのプロセスごとに履歴を共有
setopt share_history
# 複数のzshを同時に使うときなどhistoryファイルに上書きせず追加
setopt append_history
# 履歴をインクリメンタルに追加
setopt inc_append_history
# ヒストリを呼び出してから実行する間に一旦編集可能
setopt hist_verify
# 履歴検索機能のショートカット設定
autoload history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
bindkey "^P" history-beginning-search-backward-end
bindkey "^N" history-beginning-search-forward-end
# インクリメンタルサーチの設定
bindkey "^R" history-incremental-search-backward
bindkey "^S" history-incremental-search-forward
# 全履歴の一覧を出力する
function history-all { history -E 1 }

#----------------------------------------------------------
# プロンプト表示関連
#----------------------------------------------------------
# 右側に時間を表示する
RPROMPT="%T"
# 右側まで入力が来ら時間を消す
setopt transient_rprompt
# プロンプト
function precmd() {
PROMPT="%{${fg[green]}%}%n%{${fg[yellow]}%} %~%{${reset_color}%}"
st=`git status 2>/dev/null`
if [[ -n `echo "$st" | grep "^nothing to"` ]]; then
  color=${fg[cyan]}
elif [[ -n `echo "$st" | grep "^nothing added"` ]]; then
  color=${fg[blue]}
elif [[ -n `echo "$st" | grep "^# Untracked"` ]]; then
  color=${fg_bold[red]}
else
  color=${fg[red]}
fi
PROMPT+=" %{$color%}$(git branch --no-color 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/\1 /')%b%{${reset_color}%}
"
}
PROMPT2="%_%% "
#コマンドスペルミスの際のプロンプト
SPROMPT="%r is correct? [No,Yes,Abort,Exit]: "


#----------------------------------------------------------
# Python
#----------------------------------------------------------
export NOSE_REDNOSE=1

#----------------------------------------------------------
# その他
#----------------------------------------------------------
# ログアウト時にバックグラウンドジョブをkillしない
setopt no_hup
# ログアウト時にバックグラウンドジョブを確認しない
setopt no_checkjobs
# バックグラウンドジョブが終了したら(プロンプトの表示を待たずに)すぐに知らせる
setopt notify

# makeのエラー出力に色付け
e_normal=`echo -e "\033[0;30m"`
e_RED=`echo -e "\033[1;31m"`
e_BLUE=`echo -e "\033[1;36m"`
function make() {
LANG=C command make "$@" 2>&1 | sed -e "s@[Ee]rror:.*@$e_RED&$e_normal@g" -e "s@cannot\sfind.*@$e_RED&$e_normal@g" -e "s@[Ww]arning:.*@$e_BLUE&$e_normal@g"
}

pbcopy-buffer(){
  print -rn $BUFFER | pbcopy
  zle -M "pbcopy: ${BUFFER}"
}
zle -N pbcopy-buffer
bindkey '^x^p' pbcopy-buffer

#--------------------------------------------------
# 文字コード変換
#--------------------------------------------------

function euc() {
    for i in $*; do
        if [[ -f $i ]] then
            nkf -e -Lu $i >! /tmp/euc.$$ # -Lu :改行を LF にする
            mv -f /tmp/euc.$$ $i
        fi
    done
}
function utf() {
    for i in $*; do
        if [[ -f $i ]] then
            nkf -w -Lu $i >! /tmp/utf.$$ # -Lu :改行を LF にする
            mv -f /tmp/utf.$$ $i
        fi
    done
}
function sjis() {
    for i in $*; do
        if [[ -f $i ]] then
            nkf -s -Lw $i >! /tmp/sjis.$$ # -Lw :改行を CR+LF にする
            mv -f /tmp/sjis.$$ $i
        fi
    done
}

#--------------------------------------------------
# 論文の句読点を直す
#--------------------------------------------------

function paper() {
    find . -name '*.tex' -print0 | xargs -0 sed -i '' -e 's/、/, /g'
    find . -name '*.tex' -print0 | xargs -0 sed -i '' -e 's/。/. /g'
}

#--------------------------------------------------
# mp4をmp3に変換
#--------------------------------------------------

function mp4tomp3() {
    ffmpeg -i $1 -ab 256k $2
}

#--------------------------------------------------
# youtube動画をmp3に変換して~/Dropbox/mediaに移動
#--------------------------------------------------

function youtubetomp3() {
    youtube-dl -g $1 > /var/tmp/youtube-filename
    wget -O /var/tmp/youtube-file -i /var/tmp/youtube-filename
    mp4tomp3 /var/tmp/youtube-file $2.mp3
    mv $2.mp3 ~/Dropbox/media/.
}

#--------------------------------------------------
# anyenv
#--------------------------------------------------
# eval "$(anyenv init -)"

if [ -d $HOME/.anyenv ] ; then
  export PATH="$HOME/.anyenv/bin:$PATH"
  eval "$(anyenv init -)"
  for D in `ls $HOME/.anyenv/envs`
  do
    export PATH="$HOME/.anyenv/envs/$D/shims:$PATH"
  done
fi

#--------------------------------------------------
# cdr
#--------------------------------------------------

autoload -Uz is-at-least
if is-at-least 4.3.11
then
    autoload -Uz chpwd_recent_dirs cdr add-zsh-hook
    add-zsh-hook chpwd chpwd_recent_dirs
    zstyle ':chpwd:*' recent-dirs-max 5000
    zstyle ':chpwd:*' recent-dirs-default yes
    zstyle ':completion:*' recent-dirs-insert both
fi

#--------------------------------------------------
# gitのルートディレクトリに移動
#--------------------------------------------------

function cdgr() {
    cd `git rev-parse --show-toplevel`
}

#--------------------------------------------------
# peco
#--------------------------------------------------
bindkey '^r' peco-select-history
bindkey '^@' peco-cdr
bindkey "^g^a" peco-select-gitadd

function peco-select-history() {
    local tac
    if which tac > /dev/null; then
        tac="tac"
    else
        tac="tail -r"
    fi
    BUFFER=$(history -n 1 | \
        eval $tac | \
        peco --query "$LBUFFER")
    CURSOR=$#BUFFER
    zle clear-screen
}
zle -N peco-select-history

function peco-cdr () {
    local selected_dir=$(cdr -l | awk '{ print $2 }' | peco)
    if [ -n "$selected_dir" ]; then
        BUFFER="cd ${selected_dir}"
        zle accept-line
    fi
    zle clear-screen
}
zle -N peco-cdr

function peco-select-gitadd() {
    local SELECTED_FILE_TO_ADD="$(git status --porcelain | \
                                  peco --query "$LBUFFER" | \
                                  awk -F ' ' '{print $NF}')"
    if [ -n "$SELECTED_FILE_TO_ADD" ]; then
                      BUFFER="git add $(echo "$SELECTED_FILE_TO_ADD" | tr '\n' ' ')"
                      CURSOR=$#BUFFER
    fi
    zle accept-line
    # zle clear-screen
}
zle -N peco-select-gitadd

# 環境依存対応
#----------------------------------------------------------
# ~/.zshrc.localを読み込む
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

