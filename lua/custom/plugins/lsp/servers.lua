return {
  ts_ls = {
    on_attach = function(client)
      client.server_capabilities.documentFormattingProvider = false
      client.server_capabilities.documentRangeFormattingProvider = false
      client.server_capabilities.codeActionProvider = false
    end,
  },

  lua_ls = {
    settings = {
      Lua = {
        completion = {
          callSnippet = "Replace",
        },
      },
    },
  },

  gopls = {},

  pyright = {
    -- gebruik de .venv van het project (uv), of een geactiveerde venv
    before_init = function(_, config)
      local venv = os.getenv("VIRTUAL_ENV")
      if not venv and config.root_dir then
        local candidate = config.root_dir .. "/.venv"
        if vim.fn.isdirectory(candidate) == 1 then
          venv = candidate
        end
      end
      if venv then
        config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
          python = { pythonPath = venv .. "/bin/python" },
        })
      end
    end,
  },

  ruff = {
    on_attach = function(client)
      -- hover laten we aan pyright over
      client.server_capabilities.hoverProvider = false
    end,
  },
}
