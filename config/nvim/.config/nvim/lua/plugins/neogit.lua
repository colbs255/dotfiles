return {
	"TimUntersberger/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	-- Won't load neogit until we call this mapping
	keys = {
		{
			"<Leader>gg",
			function()
				require("neogit").open()
			end,
		},
	},
	config = function()
		require("neogit").setup({
			disable_commit_confirmation = true,
		})
	end,
}
