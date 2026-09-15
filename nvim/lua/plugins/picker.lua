return {
	"folke/snacks.nvim",
	opts = {
		picker = {
			win = {
				input = {
					keys = {
						["<C-s>"] = require("util.flash").anymode,
					},
				},
			},
		},
	},
	keys = {
		-- Top-level
		{ "<leader>n", function() Snacks.picker.notifications() end, desc = "Notification History" },

		-- Find
		{ "<leader>fb", function() Snacks.picker.buffers() end, desc = "Buffers" },
		{ "<leader>fB", function() Snacks.picker.buffers({ hidden = true, nofile = true }) end, desc = "Buffers (all)" },
		{ "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Config File" },
		{ "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files" },
		{ "<leader>fF", function() Snacks.picker.files({ cwd = vim.fn.getcwd() }) end, desc = "Find Files (cwd)" },
		{ "<leader>fp", function() Snacks.picker.projects() end, desc = "Projects" },

		-- Git
		{ "<leader>gd", function() Snacks.picker.git_diff() end, desc = "Git Diff (hunks)" },
		{ "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git Status" },

		-- Grep
		{ "<leader>sg", function() Snacks.picker.grep() end, desc = "Grep" },
		{ "<leader>sG", function() Snacks.picker.grep({ cwd = vim.fn.getcwd() }) end, desc = "Grep (cwd)" },
		{ "<leader>sb", function() Snacks.picker.grep_buffers() end, desc = "Grep Open Buffers" },

		-- Search
		{ '<leader>s"', function() Snacks.picker.registers() end, desc = "Registers" },
		{ '<leader>s/', function() Snacks.picker.search_history() end, desc = "Search History" },
		{ "<leader>sa", function() Snacks.picker.autocmds() end, desc = "Autocmds" },
		{ "<leader>s;", function() Snacks.picker.command_history() end, desc = "Command History" },
		{ "<leader>s:", function() Snacks.picker.commands() end, desc = "Commands" },
		{ "<leader>sd", function() Snacks.picker.diagnostics() end, desc = "Diagnostics" },
		{ "<leader>sD", function() Snacks.picker.diagnostics_buffer() end, desc = "Buffer Diagnostics" },
		{ "<leader>sh", function() Snacks.picker.help() end, desc = "Help Pages" },
		{ "<leader>sH", function() Snacks.picker.highlights() end, desc = "Highlights" },
		{ "<leader>si", function() Snacks.picker.icons() end, desc = "Icons" },
		{ "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Keymaps" },
		{ "<leader>sm", function() Snacks.picker.marks() end, desc = "Marks" },
		{ "<leader>su", function() Snacks.picker.undo() end, desc = "Undotree" },
		{ "<leader>sC", function() Snacks.picker.colorschemes() end, desc = "Colorschemes" },
	},
}
