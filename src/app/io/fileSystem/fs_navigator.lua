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

local offsets = {
    first_prefix = "║ ",
    middle_nested_prefix = "│  ",
    last_nested_prefix = "   ",
    middle_individual_prefix = "├─",
    last_individual_prefix = "└─",
    postfix_for_dir = "/",
}

local function new_record(full_path, rendered, is_dir)
    return {
        is_dir = is_dir,
        full_path = full_path,
        rendered = rendered,
    }
end

local function build_list_files_recur(path, offset, res)
    local files_in_dir = get_files_in_dir(path)

    for key, file in pairs(files_in_dir) do
        local file_path = path .. "/" .. file

        local cur_offset = offsets.middle_individual_prefix
        local nested_prefix = offset .. offsets.middle_nested_prefix
        if key == #files_in_dir then
            cur_offset = offsets.last_individual_prefix
            nested_prefix = offset .. offsets.last_nested_prefix
        end

        if is_path_to_dir(file_path) then
            local string = offset .. cur_offset .. file .. offsets.postfix_for_dir

            table.insert(res, new_record(file_path, string, true))
            res = build_list_files_recur(file_path, nested_prefix, res)
        else
            local string = offset .. cur_offset .. file

            table.insert(res, new_record(file_path, string, false))
        end
    end

    return res
end

return {
    get_list = function(dir)
        return build_list_files_recur(dir, offsets.first_prefix, {})
    end,
}
