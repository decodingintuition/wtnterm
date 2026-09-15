local parsers = {
	"astro",
	"bash",
	"c",
	"cpp",
	"css",
	"diff",
	"html",
	"java",
	"javascript",
	"json",
	"lua",
	"luadoc",
	"markdown",
	"markdown_inline",
	"python",
	"query",
	"regex",
	"rust",
	"sql",
	"toml",
	"tsx",
	"typescript",
	"vim",
	"vimdoc",
	"yaml",
}

return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter").install(parsers)

		vim.api.nvim_create_autocmd("FileType", {
			group = vim.api.nvim_create_augroup("user_treesitter", { clear = true }),
			callback = function(event)
				local lang = vim.treesitter.language.get_lang(vim.bo[event.buf].filetype)
				if not lang or not vim.list_contains(parsers, lang) then
					return
				end

				local started = pcall(vim.treesitter.start, event.buf, lang)
				if started and lang ~= "c" and lang ~= "cpp" then
					vim.bo[event.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
