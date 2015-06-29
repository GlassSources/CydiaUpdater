PLUGIN = nil

function sendHttpRequest(id)
local ConnectCallbacks =
{
OnConnected = function (a_Link)
  -- Connection succeeded, send the http request:
  a_Link:Send("GET / HTTP/1.0\r\nHost: " .. id .. "\r\n\r\n")
end,

OnError = function (a_Link, a_ErrorCode, a_ErrorMsg)
  -- nope not needed
end,

OnReceivedData = function (a_Link, a_Data)
  -- not needed to Log
  return a_Data
end,

OnRemoteClosed = function (a_Link)
  --  not needed
end,
}

-- Connect:
if not(cNetwork:Connect("". .. id .."", 80, ConnectCallbacks)) then
-- Highly unlikely, but better check for errors
LOG("Cannot queue connection to " .. id)
end
end

function Initialize(Plugin)
  Plugin:SetName("CydiaUpdateManager")
  Plugin:SetVersion(1)
  PLUGIN = Plugin
  plugins = cPluginManager:GetAllPlugins()
  for _,v in pairs(plugins) do
  if v == "CydiaScriptLoader" then
      local plugin = cPluginManager:GetPlugin("CydiaScriptLoader")
      if plugin:IsLoaded() then
        local pluginVersion = plugin:GetVersion()
        local networkVersion = sendHttpRequest("http://pastebin.com/raw.php?i=JkjbgncV")
        if pluginVersion > networkVersion then
          LOG("[CydiaScriptLoader] Detecting Plugin Code Modification, stopping plugin in-case of damage!")
          cPluginManager:UnloadPlugin("CydiaScriptLoader")
        end
        if pluginVersion < networkVersion then
          LOG("CydiaScriptLoader is outdated! Please update!")
        end
        if pluginVersion == networkVersion then
          LOG("CydiaScriptLoader is in the latest version. No worries!")
        end
      end
    break
  end
  end
  return true
end

function OnDisable()
  LOG("CydiaUpdateManager is disabled! Update systems are disabled!")
end
