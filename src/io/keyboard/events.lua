local keymap = {
   [27] = "",
}

while true do
   os.execute("stty cbreak </dev/tty >/dev/tty 2>&1")
   if string.byte(io.read(1)) == 27 then
      print("27")
   end
   os.execute("stty -cbreak </dev/tty >/dev/tty 2>&1")
end

local observer = {
   _kommands = {
      [27] = {}, --  esc
      [127] = {}, --  backspace
      [10] = {}, -- enter
   },
}
