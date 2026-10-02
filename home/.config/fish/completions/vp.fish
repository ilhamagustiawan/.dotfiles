# Vite+ dynamic completion registration, lazy-loaded by Fish on completion.
complete --keep-order --exclusive --command vp --arguments "(VP_COMPLETE=fish command vp -- (commandline --current-process --tokenize --cut-at-cursor) (commandline --current-token))"
