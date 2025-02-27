local M = {}

-- Function to get the current date in YYYY-MM-DD format
local function get_current_date()
	return os.date("%Y-%m-%d")
end

-- Function to get the previous day's date in YYYY-MM-DD format
local function get_previous_date()
	local current_time = os.time()
	local previous_time = current_time - 86400 -- Subtract one day (86400 seconds)
	return os.date("%Y-%m-%d", previous_time)
end

-- Function to create or open the daily note
function M.open_daily_note()
	local current_date = get_current_date()
	local previous_date = get_previous_date()

	local current_file =
		vim.fn.expand("C:/Users/farrki01/OneDrive - Nidec/Documents/nvim/notes/" .. current_date .. ".md")
	local previous_file =
		vim.fn.expand("C:/Users/farrki01/OneDrive - Nidec/Documents/nvim/notes/" .. previous_date .. ".md")

	-- Check if the current file exists, if not create it and copy yesterdays stuff in
	if vim.fn.filereadable(current_file) == 0 then
		local new_content = {}
		-- Create the directory if it doesn't exist
		vim.fn.mkdir(vim.fn.expand("C:/Users/farrki01/OneDrive - Nidec/Documents/nvim/notes/"), "p")

		-- write the date as the title of the file
		table.insert(new_content, { "#" .. current_date, "\n\n", "## Tasks" })

		-- If the previous file exists, copy its Tasks
		if vim.fn.filereadable(previous_file) == 1 then
			local copy_tasks = false

			local previous_content = vim.fn.readfile(previous_file)

			for _, line in ipairs(previous_content) do
				-- Start copying when we find the "## Tasks" heading
				if line:match("^## Tasks") then
					copy_tasks = true
				else
					-- Stop copying when we find the next heading (starts with "##")
					if copy_tasks and line:match("^## ") then
						break
					end
					-- Copy the lines if we're in the "## Tasks" section
					if copy_tasks then
						table.insert(new_content, line)
					end
				end
			end
		end

		table.insert(new_content, { "## Todays Tasks" })

		vim.fn.writefile(new_content, current_file)
	-- if the file already exists then just open it
	else
		-- Open the current file in a new buffer
		vim.cmd("edit " .. current_file)
	end
end

return M
