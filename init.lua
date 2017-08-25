t = require('ds18b20')
t:setPin(3) -- gpio0 = 3, gpio2 = 4

local updateTimer
local temperature = nil

function parseRequest(request)
    local first = nil
    for line in string.gmatch(request, "[^\n]+") do
        if (first == nil) then
            first = line
        end
    end

    if (first == nil) then
        return
    end

    local method = nil
    local path = nil
    for part in string.gmatch(first, "[^ ]+") do
        if (method == nil) then
            method = part
        else
            if (path == nil) then
                path = part
            end
        end
    end

    local func = nil
    local arg = nil
    for part in string.gmatch(path, "[^ /]+") do
        if (func == nil) then
            func = part
        else
            if (arg == nil) then
                arg = part
            end
        end
    end

    return func, arg
end

function buildResponse(conn, code, response)
    local len = string.len(response)

    conn:on("sent", function(sck) sck:close() end)
    conn:send("HTTP/1.1 " .. code .. "\r\nConnection: close\r\nContent-Type: text/html\r\nContent-Length: " .. len .. "\r\n\r\n" .. response)
end

function receive(conn, payload)
    local func, arg = parseRequest(payload)

    local resp = "<html><head><meta name='viewport' content='width=device-width' /></head><body font='Arial' background='white' style='font-size: 80px'>";

    if temperature ~= nil then
        for addr, temp in pairs(temperature) do
            resp = resp .. string.format("<p onClick='location.reload();'>%02d°</p>", temp)
        end
    end

    resp = resp .. "</body></html>"

    buildResponse(conn, "200 OK", resp)
end

function connection(conn)
    conn:on("receive", receive)
end

function receivedTemperature(temp)
    temperature = temp
end

function beginReadTemperature(timer)
    t:readTemp(receivedTemperature)
end

function startServer()
    local ip = wifi.sta.getip()
    print("Got ip: " .. ip)

    if (srv) then
      srv:close()
    end
    print("Start server on port 80")
    srv=net.createServer(net.TCP, 30) 
    srv:listen(80, ip, connection)

    print("Start timer for temperature measurement")
    updateTimer = tmr.create()
    updateTimer:register(10000, tmr.ALARM_AUTO, beginReadTemperature)
    updateTimer:start()
end

wifi.eventmon.register(wifi.eventmon.STA_GOT_IP, startServer)
wifi.eventmon.register(wifi.eventmon.STA_DHCP_TIMEOUT, startServer)
wifi.setmode(wifi.STATION)
wifi.setphymode(wifi.PHYMODE_G)
local netId = "SAUNA-" .. node.chipid()
print("Setup WiFi as " .. netId)
wifi.sta.sethostname(netId)

local station_cfg = {}
station_cfg.ssid = "MyWiFi"
station_cfg.pwd = "high-secure-password"
wifi.sta.config(station_cfg)
