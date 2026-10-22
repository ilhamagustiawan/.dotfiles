# Disable greeting
set fish_greeting 

# Set Editor to neovim
set -gx EDITOR 'nvim'

# Open Plannotator reviews in Safari without changing the default browser
set -gx PLANNOTATOR_BROWSER 'Safari'

# Set neovim as the program to open manpages
set -gx MANPAGER 'nvim +Man!'

# Add dotfiles directory to PATH for 'dot' command
fish_add_path ~/.dotfiles
