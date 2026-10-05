if command -q mise
    if not functions -q __mise_env_eval
        mise activate fish | source
    end
end
