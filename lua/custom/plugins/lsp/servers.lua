-- LSP server configuraties
return {
	gopls = {},

	ts_ls = {
		root_dir = require("lspconfig.util").root_pattern("package.json", "tsconfig.json", "jsconfig.json", ".git"),
		init_options = {
			hostInfo = "neovim",
			preferences = {
				includePackageJsonAutoImports = "on",
				importModuleSpecifierPreference = "non-relative",
			},
		},
		settings = {
			typescript = {
				preferences = {
					includePackageJsonAutoImports = "on",
					importModuleSpecifierPreference = "non-relative",
				},
			},
			javascript = {
				preferences = {
					includePackageJsonAutoImports = "on",
					importModuleSpecifierPreference = "non-relative",
				},
			},
		},
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

	-- Voeg hier meer servers toe zoals:
	-- pyright = {},
	-- rust_analyzer = {},
	-- etc.
}
