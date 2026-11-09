-- User-owned Voxtype controls. F10 is intercepted only while F9 is held.
-- F9 previously started/stopped ordinary push-to-talk through Omarchy defaults.
hl.unbind("F9")
local active_nonce = nil
local ai_latched = false
local ai_bind = nil
local control = "/usr/bin/python3 /home/majdoor/.config/voxtype/input_controls.py "

hl.bind("F9", function()
  if ai_bind then ai_bind:unbind() end
  active_nonce = tostring(os.time()) .. "-" .. tostring(math.random(100000000, 999999999))
  ai_latched = false
  local nonce = active_nonce
  ai_bind = hl.bind("F10", function()
    if active_nonce == nonce then
      ai_latched = true
      hl.exec_cmd(control .. "ai " .. nonce)
    end
  end, { description = "AI mode while holding F9" })
  hl.exec_cmd(control .. "start " .. nonce)
end, { description = "Hold for normal dictation" })

hl.bind("F9", function()
  if ai_bind then ai_bind:unbind(); ai_bind = nil end
  if active_nonce then
    local suffix = ai_latched and " ai" or ""
    hl.exec_cmd(control .. "stop " .. active_nonce .. suffix)
  end
  active_nonce = nil
  ai_latched = false
end, { description = "Finish dictation or AI instruction", release = true })
