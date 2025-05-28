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

local utils = require("modules.utils")
local ioutils = require("modules.ioutils")
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
        utils.log("processing: " .. path)
        system.download = function(url)
            downloader.request({system = system, module = mod, url = url})
        end
        mod.get(system)
        local subdir = string.format("%s/%s", system.builds, mod.name)
        if not ioutils.execute(string.format("mkdir -p '%s'", subdir)) then
            error(string.format("unable to create subdirectory %s", subdir))
        end
        local dest = string.format("%s/%s/%s-%d", system.builds, mod.name, mod.version, mod.release)
        for sub in io.popen(string.format("ls '%s'", subdir)):lines() do
            local full = string.format("%s/%s", subdir, sub)
            if full ~= dest then
                local outdated = ioutils.read_stdout(string.format("find '%s' -maxdepth 0 -type d -mtime +30", full))
                if outdated ~= nil and outdated ~= "" then
                    utils.log("clearing old version: " .. outdated)
                    os.execute(string.format("find '%s' -delete", full))
                end
            end
        end
        local env_file = string.format("%s/.pkgv_env.sh", dest)
        if not ioutils.execute(string.format("test -s '%s'", env_file)) then
            utils.log("building: " .. path)
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
ioutils.write_file(system.env, envs, "644")
ioutils.write_file(system.pkglist, pkglist, "644")
os.execute(string.format("sort -o '%s' -u '%s'", system.pkglist, system.pkglist))
