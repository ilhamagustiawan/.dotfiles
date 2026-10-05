# CodeCompanion community configuration examples

These examples were fetched directly from public GitHub dotfiles. They are inspiration, not drop-in configurations for the current plugin API.

## Examples

### olimorris/dotfiles — plugin author's personal configuration

[Source at inspected commit](https://github.com/olimorris/dotfiles/blob/c7dc89c3721b13791f4b412a29816964cc6768ef/.config/nvim/lua/plugins/coding.lua)

- Declares Fidget for status display and VectorCode for repository indexing/search.
- Configures chat send keys (`Ctrl-Enter`, `Ctrl-s`), completion (`Ctrl-x`), and buffer/fetch/image shortcuts.
- Uses `mini_diff` as its diff display provider.
- Includes a multi-step prompt workflow and several HTTP adapter overrides.
- This snapshot uses legacy `strategies` syntax and Copilot; it does not demonstrate Codex subscription authentication.

### JuanCrg90/dotfiles — platform-specific adapter selection

[Source at inspected commit](https://github.com/JuanCrg90/dotfiles/blob/475d55f529f705587a655855f845e957925781e2/nvim/nvim/lua/plugins/codecompanion.lua)

- Defaults to OpenAI / `gpt-4.1`, switching to Ollama / `qwen3` on ARM macOS.
- Customizes chat role labels and uses Telescope for the action palette and context selection.
- Tunes Ollama context size, thinking, and keep-alive settings.
- Uses legacy `strategies` and adapter configuration; do not copy directly into the current setup.

### meetorion/astronvim_config — MCPHub extension

[Source](https://github.com/meetorion/astronvim_config/blob/master/lua/plugins/codecompanion.lua)

- Adds `ravitemer/mcphub.nvim` as a dependency.
- Configures its CodeCompanion extension to display tool results in chat and expose variables/slash commands.
- This example is primarily an extension setup, not an adapter or chat UI configuration. The linked branch can change.

## Implications for this repository

Useful ideas to consider: progress feedback, explicit send keys, context-selection shortcuts, and diff review. MCPHub/VectorCode add dependencies and are optional; adopt them only for a concrete need.

Keep the current Codex ChatGPT authentication, Luna model/reasoning selection, Blink completion, and disabled chat line numbers. None of the inspected community files demonstrates that full combination.

Use current upstream APIs when adapting older examples:

- [Current CodeCompanion config source](https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/config.lua): `interactions`, separate `adapters.http` and `adapters.acp`, and chat window options.
- [Codex adapter source](https://github.com/olimorris/codecompanion.nvim/blob/main/lua/codecompanion/adapters/acp/codex.lua): `codex-acp` command and `chat-gpt` authentication option.
- [Current plugin help](https://github.com/olimorris/codecompanion.nvim/blob/main/doc/codecompanion.txt): ACP is chat-only; Blink integration is detected automatically and can be explicitly selected.

No runtime configuration was changed as part of this comparison.
