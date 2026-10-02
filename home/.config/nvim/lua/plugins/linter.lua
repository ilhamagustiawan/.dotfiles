local check_by_ft = function(tools)
  local result = {} ---@type table<string, string[]>
  for name, tool in pairs(tools) do
    local cmd = tool.cmd or name
    if vim.fn.executable(cmd) == 1 then
      for _, filetype in ipairs(tool.filetypes) do
        local active = result[filetype] or {}
        if #active == 0 then
          result[filetype] = active
        end
        active[#active + 1] = name
        table.sort(active)
      end
    end
  end
  return result
end

return {
  "mfussenegger/nvim-lint",
  opts = {},
  config = function(_, opts)
    local lint = require "lint"
    local default_by_ft = {
      go = { "golangcilint" },
      svelte = { "oxlint" },
      typescript = { "oxlint" },
      typescriptreact = { "oxlint" },
      json = { "oxlint" },
      javascript = { "oxlint" },
      javascriptreact = { "oxlint" },
    }
    lint.linters_by_ft = default_by_ft

    local by_ft = check_by_ft(opts)
    if vim.tbl_isempty(by_ft) then
      by_ft = default_by_ft
    end

    local run_lint = function()
      local result = {} ---@type string[]
      local linters = by_ft[vim.bo.filetype] or {}
      for _, linter in ipairs(linters) do
        local linter_opts = opts[linter]
        local condition = linter_opts and linter_opts.condition
        if not condition or condition() then
          result[#result + 1] = linter
        end
      end
      if #result > 0 then
        lint.try_lint(result)
      end
    end

    lint.linters_by_ft = by_ft
    for name, tool in pairs(opts) do
      if tool.override then
        local linter = lint.linters[name]
        assert(type(linter) ~= "function")
        tool.override(linter)
      end
    end

    local lint_events = { "BufRead", "BufWritePost", "InsertLeave" }
    vim.api.nvim_create_autocmd(lint_events, {
      group = vim.api.nvim_create_augroup("user.lint", {}),
      callback = run_lint,
    })

    vim.api.nvim_create_user_command("Lint", run_lint, {})

    vim.keymap.set("n", "<leader>cl", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })
  end,
}
