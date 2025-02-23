# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Path for GNU tools
#PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
#PATH="$(brew --prefix)/opt/gawk/libexec/gnubin:$PATH"
#PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
#PATH="$(brew --prefix)/opt/gnu-tar/libexec/gnubin:$PATH"

# Path for Ansible Lint
#PATH="$(brew --prefix)/opt/ansible-lint/bin:$PATH"

# ZSH modules
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# fzf
#source <(fzf --zsh)

# direnv
#eval "$(direnv hook zsh)"

# Powerlevel10k
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# kubectl
#[[ $commands[kubectl] ]] && source <(kubectl completion zsh)
#alias k=kubectl
#complete -o default -F __start_kubectl k

### Alias
#############
alias myip="curl http://ipecho.net/plain; echo"
alias l="lsd -alh"
