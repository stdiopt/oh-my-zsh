_fishy_collapsed_wd() {
  echo $(pwd | perl -pe '
   BEGIN {
      binmode STDIN,  ":encoding(UTF-8)";
      binmode STDOUT, ":encoding(UTF-8)";
   }; s|^$ENV{HOME}|~|g; s|/([^/.])[^/]*(?=/)|/$1|g; s|/\.([^/])[^/]*(?=/)|/.$1|g
')
}

local return_code="%(?..%{$fg_bold[red]%}%? ↵%{$reset_color%})"
function my_git_prompt_info() {
	ref=$(git symbolic-ref HEAD 2> /dev/null) || return
	GIT_STATUS=$(git_prompt_status)
	[[ -n $GIT_STATUS ]] && GIT_STATUS=" $GIT_STATUS"
	echo "$ZSH_THEME_GIT_PROMPT_PREFIX${ref#refs/heads/}$GIT_STATUS$ZSH_THEME_GIT_PROMPT_SUFFIX"
}

function my_aws_info() {
  test -n "$AWS_PROFILE" && echo "$fg[blue]🅰 $AWS_PROFILE"
}

# Colored prompt
ZSH_THEME_COLOR_USER="green" 
ZSH_THEME_COLOR_HOST="green" 
ZSH_THEME_COLOR_PWD="yellow" 
test -n "$SSH_CONNECTION" && ZSH_THEME_COLOR_USER="red" && ZSH_THEME_COLOR_HOST="red"
test `id -u` = 0 && ZSH_THEME_COLOR_USER="magenta" && ZSH_THEME_COLOR_HOST="magenta"

PROMPT="$(my_aws_info)"'%{$fg_bold[$ZSH_THEME_COLOR_USER]%}%n@%{$fg_bold[$ZSH_THEME_COLOR_HOST]%}%M%{$reset_color%}:%{$fg_bold[$ZSH_THEME_COLOR_PWD]%}$(_fishy_collapsed_wd)%{$reset_color%} $(my_git_prompt_info)%(!.#.$) '
RPS1="${return_code}"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[cyan]%}("
ZSH_THEME_GIT_PROMPT_SUFFIX=") %{$reset_color%}"
ZSH_THEME_GIT_PROMPT_UNTRACKED="%%"
ZSH_THEME_GIT_PROMPT_ADDED="+"
ZSH_THEME_GIT_PROMPT_MODIFIED="*"
ZSH_THEME_GIT_PROMPT_RENAMED="~"
ZSH_THEME_GIT_PROMPT_DELETED="!"
ZSH_THEME_GIT_PROMPT_UNMERGED="?"

