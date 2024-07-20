
local res_list = {}

local function get_files_list_in_dir(path)
    local cur_dir = io.popen('ls -A "'..path..'"')
    local files_in_cur_dir = {}

    for file in cur_dir:lines() do
        table.insert(files_in_cur_dir, file)
    end
    cur_dir:close()
    
    return files_in_cur_dir
end

local function get_file_type(file_path)
    local tmp_file = io.popen('test -d "'..file_path..'" && echo "dir" || echo "file"')
    local file_type = tmp_file:read("*l")
    tmp_file:close()

    return file_type
end

local function build_list_files_recur(path, start_offset)
    local offset = start_offset or "   "
    local files_in_dir = get_files_list_in_dir(path)

    for key, file in pairs(files_in_dir) do
        local file_path = path .. "/" .. file
        local file_type = get_file_type(file_path)
        local cur_offset = ""
        local next_offset = ""

        if key == #files_in_dir then
            cur_offset = "└─"
            next_offset = offset .. "   "
        else
            cur_offset = "├─"
            next_offset = offset .. "│" .. "  "
        end

        if file_type == "dir" then            
            local string = offset .. cur_offset .. file .. ":"
            table.insert(res_list, string)

            build_list_files_recur(file_path, next_offset)
        else
            local string = offset .. cur_offset .. file
            table.insert(res_list, string)
        end
    end
end

local get_list_files_from_dir = function(dir)
    res_list = {}
    build_list_files_recur(dir)

    return res_list
end

return {
    Get_list = get_list_files_from_dir
}

