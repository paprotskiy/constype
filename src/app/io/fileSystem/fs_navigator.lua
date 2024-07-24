local function get_files_in_dir(path)
    local cur_dir = io.popen('ls -A "' .. path .. '"')
    local files_in_cur_dir = {}

    for file in cur_dir:lines() do
        table.insert(files_in_cur_dir, file)
    end
    cur_dir:close()

    return files_in_cur_dir
end

local function is_path_to_dir(file_path)
    local tmp_file = io.popen('test -d "' .. file_path .. '" && echo "dir" || echo "file"')
    local file_type = tmp_file:read("*l")
    tmp_file:close()

    return file_type == "dir"
end

return {
    get_files_in_dir = get_files_in_dir,
    is_path_to_dir = is_path_to_dir
}