local tty = require("app.ui.tty.tty")

local function out_of_visible_range(elem)
   -- todo factory method required
   return {
      Key = elem.Key,
      value = "...",
   }
end

local function prepare_subset(raw_list, top_idx, curr_idx, bottom_idx)
   local res = {}
   for idx = top_idx, bottom_idx, 1 do
      table.insert(res, raw_list[idx])
   end

   if top_idx ~= 1 then
      res[1] = out_of_visible_range(res[1])
   end
   if bottom_idx ~= #raw_list then
      res[#res] = out_of_visible_range(res[#res])
   end

   return res, curr_idx - top_idx + 1
end

local function should_break(raw_list, top_idx, bottom_idx, max_size)
   local on_limits = max_size == bottom_idx - top_idx + 1

   local on_top = top_idx == 1
   local on_bottom = bottom_idx == #raw_list
   local both_borders = on_top and on_bottom

   return on_limits or both_borders
end

local function extend_context(raw_list, curr_idx, max_size)
   local top_idx, bottom_idx = curr_idx, curr_idx

   while true do
      if should_break(raw_list, top_idx, bottom_idx, max_size) then
         break
      end

      if top_idx > 1 then
         top_idx = top_idx - 1
      end

      if should_break(raw_list, top_idx, bottom_idx, max_size) then
         break
      end

      if bottom_idx < #raw_list then
         bottom_idx = bottom_idx + 1
      end
   end

   return prepare_subset(raw_list, top_idx, curr_idx, bottom_idx)
end

return {
   new_trimmed_list = function(color_active, color_default, raw_list, max_size)
      local curr_idx = 1

      return {
         pick_next = function()
            if curr_idx < #raw_list then
               curr_idx = curr_idx + 1
            end
         end,

         pick_prev = function()
            if curr_idx > 1 then
               curr_idx = curr_idx - 1
            end
         end,

         to_lines = function()
            local lines = {}
            local list, new_curr_idx = extend_context(raw_list, curr_idx, max_size)

            for idx, v in ipairs(list) do
               if idx == new_curr_idx then
                  table.insert(lines, tty.print_with_color(color_active, color_default, v.value))
               else
                  table.insert(lines, tty.print_with_color(color_default, color_default, v.value))
               end
            end

            return lines
         end,

         get_current = function()
            return raw_list[curr_idx]
         end,

         get_current_idx = function()
            return curr_idx
         end,
      }
   end,
}
