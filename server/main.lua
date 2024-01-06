Codev = {}
Codev.Shared = {}
Codev.Functions = {}

exports('CodevLibrary', function()
    return Codev
end)

CreateThread(function()
    if CODEV.VersionCheck then
        print("^0Codeverse Library by ^1Codeverse^0 loaded successfully!")
        print("^0Checking for updates...")
    
        PerformHttpRequest("https://raw.githubusercontent.com/Codeverse-Scripts/codev-versions/main/versions.json", function(_, response, __)
            local resp = json.decode(response)
            local currentVersion = tostring(GetResourceMetadata(GetCurrentResourceName(), "version", 0))
            if currentVersion ~= tostring(resp.library) then
                print("^0Codeverse Library is Outdated!\nPlease Update to ^1Version: " .. resp.library .. "^7 at ^4https://github.com/Codeverse-Scripts/codev-lib (CTRL+CLICK) ^7")
            else
                print("^0You're running the ^1latest^0 version of Codeverse library!")
            end
        end, "GET", '[]', { ["Content-Type"] = "application/json" })
    end
end)