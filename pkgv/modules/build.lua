local downloader = require("modules.download")
local system = require("modules.system")
for _, dir in pairs({system.cache, system.builds}) do
    os.execute(string.format("mkdir -p '%s'", dir))
end

local concat = function(input, add)
    local str = input
    if str ~= "" then
        str = str .. "\n"
    end
    return str .. add
end

local pkglist = ""
local envs = ""
for path in io.popen("find packages/ -type f -name '*.lua' | sed 's/\\.lua$//g' | sort"):lines() do
    local req = string.gsub(path, "/", ".")
    local mod = require(req)
    if mod.version == nil or mod.name == nil or mod.upstream == nil or mod.release == nil then
        error(string.format("%s no version/name/upstream/release? -> %s", req, path))
    end
    local enabled = true
    if mod.status ~= nil then
        if mod.status ~= "enabled" then
            if mod.status == "disabled" then
                enabled = false
            else
                error(string.format("unknown status for %s (%s)", req, mod.status))
            end
        end
    end
    if enabled then
        system.log("processing: " .. path)
        system.download = function(url)
            downloader.request({system = system, module = mod, url = url})
        end
        mod.get(system)
        local dest = string.format("%s/%s/%s-%d", system.builds, mod.name, mod.version, mod.release)
        local env_file = string.format("%s/.pkgv_env.sh", dest)
        if not system.execute(string.format("test -s '%s'", env_file)) then
            system.log("building: " .. path)
            mod.build(system, dest, env_file)
        end
        envs = concat(envs, string.format("source '%s'", env_file))
        if mod.binary ~= nil then
            system.binaries[mod.name] = mod.binary(dest)
        end
        if mod.upstream ~= "none" then
            local url = mod.upstream
            local filter = ""
            if type(url) ~= "string" then
                url = mod.upstream.url
                filter = string.format(" '%s'", mod.upstream.filter)
            end
            pkglist = concat(pkglist, string.format("check_version '%s'%s", url, filter))
        end
    end
end
system.write_file(system.env, envs, "644")
system.write_file(system.pkglist, pkglist, "644")
os.execute(string.format("sort -o '%s' -u '%s'", system.pkglist, system.pkglist))
