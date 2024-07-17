export ZSH="$HOME/.oh-my-zsh"

# Created by newuser for 5.8.1
ZSH_THEME="bira"
local return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"

if [[ $UID -eq 0 ]]; then
    local user_host='%{$terminfo[bold]$fg[red]%}%n@%m %{$reset_color%}'
    local user_symbol='#'
else
    local user_host='%{$terminfo[bold]$fg[green]%}%n@%m %{$reset_color%}'
    local user_symbol='$'
fi

local current_dir='%{$terminfo[bold]$fg[blue]%}%~ %{$reset_color%}'
local git_branch='$(git_prompt_info)'
local git_user='%{$terminfo[bold]$fg[red]%}$(git_current_user_name) %{$reset_color%}'
local rvm_ruby='$(ruby_prompt_info)'
local venv_prompt='$(virtualenv_prompt_info)'

ZSH_THEME_RVM_PROMPT_OPTIONS="i v g"

PROMPT="╭─${user_host}${current_dir}${rvm_ruby}${git_branch}${git_user}${venv_prompt}
╰─%B${user_symbol}%b "
RPROMPT="%B${return_code}%b"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg[yellow]%}‹"
ZSH_THEME_GIT_PROMPT_SUFFIX="› %{$reset_color%}"

ZSH_THEME_RUBY_PROMPT_PREFIX="%{$fg[red]%}‹"
ZSH_THEME_RUBY_PROMPT_SUFFIX="› %{$reset_color%}"

ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX="%{$fg[green]%}‹"
ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX="› %{$reset_color%}"
ZSH_THEME_VIRTUALENV_PREFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_PREFIX
ZSH_THEME_VIRTUALENV_SUFFIX=$ZSH_THEME_VIRTUAL_ENV_PROMPT_SUFFIX


source $ZSH/oh-my-zsh.sh

# Custom Zsh configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# Move to workspace
cd ~/workspace

eval "$(ssh-agent -s)"
ssh-add ~/.ssh/id_gh_daa

tput setaf 80

echo "
======================================
| Dev Academy Aotearoa               |
|                                    |
| Welcome curious learner!           |
|                                    |
| This is your working directory.    |
| You can use the command 'git clone'| 
| to download repositories and start |
| working on projects.               |
|                                    |
| Remember to be kind, curious,      |
| and have fun while you learn.      |
| Don't be afraid to make mistakes   |
| and ask for help when needed.      |
| Happy learning!                    |
|                                    |
| Remember to git iam                |
======================================
"
