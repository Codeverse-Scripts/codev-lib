Codev = Codev or {}
Codev.Shared = Codev.Shared or {}

local StringCharset = {}
local NumberCharset = {}

for i = 48, 57 do NumberCharset[#NumberCharset + 1] = string.char(i) end
for i = 65, 90 do StringCharset[#StringCharset + 1] = string.char(i) end
for i = 97, 122 do StringCharset[#StringCharset + 1] = string.char(i) end

function Codev.Shared.Trim(text)
    if not text then return nil end
    return string.gsub(text, "^%s*(.-)%s*$", "%1")
end

function Codev.Shared.RandomStr(length)
    if length <= 0 then return '' end
    return Codev.Shared.RandomStr(length - 1) .. StringCharset[math.random(1, #StringCharset)]
end

function Codev.Shared.RandomInt(length)
    if length <= 0 then return '' end
    return Codev.Shared.RandomInt(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
end