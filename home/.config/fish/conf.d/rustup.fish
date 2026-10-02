for rustup_bin in /opt/homebrew/opt/rustup/bin /usr/local/opt/rustup/bin
    if test -d "$rustup_bin"
        fish_add_path --path "$rustup_bin"
        break
    end
end

if test -f "$HOME/.cargo/env.fish"
    source "$HOME/.cargo/env.fish"
end
