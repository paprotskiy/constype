local fs_navigator = require('app.io.fileSystem.fs_navigator')

local offsets = {
    first_prefix = " ║ ",
    middle_nested_prefix = " │  ",
    last_nested_prefix = "   ",
    middle_individual_prefix = " ├─",
    last_individual_prefix = " └─",
    postfix_for_dir = "/",
}

local function new_record(full_path, rendered, is_dir)
    return {
        full_path = full_path,
        rendered = rendered,
        is_dir = is_dir,
    }
end

local function build_list_files_recur(path, init_offset, cur_offset, alt_cur_offset, nest_prefix, alt_nest_prefix, res)
    local files_in_dir = fs_navigator.get_files_in_dir(path)

    for key, file in pairs(files_in_dir) do
        local file_path = path .. "/" .. file

        local current_offset = cur_offset
        -- local current_offset = offsets.middle_individual_prefix
        local nested_prefix = init_offset .. nest_prefix
        -- local nested_prefix = offset .. offsets.middle_nested_prefix
        if key == #files_in_dir then
            current_offset = alt_cur_offset
            -- current_offset = offsets.last_individual_prefix
            nested_prefix = init_offset .. alt_nest_prefix
            -- nested_prefix = offset .. offsets.last_nested_prefix
        end

        if fs_navigator.is_path_to_dir(file_path) then
            local string = init_offset .. current_offset .. file .. offsets.postfix_for_dir

            table.insert(res, new_record(file_path, string, true))
            res = build_list_files_recur(file_path, nested_prefix, offsets.middle_individual_prefix, offsets.last_individual_prefix, offsets.middle_nested_prefix, offsets.last_nested_prefix, res)
        else
            local string = init_offset .. current_offset .. file

            table.insert(res, new_record(file_path, string, false))
        end
    end

    return res
end

return {
    get_list = function(dir)
        return build_list_files_recur(dir, offsets.first_prefix, " ", " ", " ", " ", {})
    end,
}
