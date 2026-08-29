# Oh-My-Zsh settings that must be set before $ZSH/oh-my-zsh.sh is
# sourced. See pre-omz/05_omz_path.zsh for the ZSH= path itself.
#
# ZSH_CUSTOM is left unset here: Oh-My-Zsh defaults it to $ZSH/custom,
# which is now the same on every OS and matches where
# bootstrap/install-zsh-plugins.sh installs plugins.

ZSH_THEME="powerlevel10k/powerlevel10k"
CASE_SENSITIVE="true"

plugins=(
    git
    zsh-autosuggestions
    zsh-syntax-highlighting
    fzf-tab
)
