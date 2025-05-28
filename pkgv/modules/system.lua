local utils = require("modules.utils")
local root = os.getenv("PKGV_STORE")
if root == nil then
    error("PKGV_STORE not set?")
end
root = "/Users/enck/.local/pkgv"
local system = {
    os = os.getenv("PKGV_OS"),
    arch = {
        main = os.getenv("PKGV_ARCH")
    },
    cache = string.format("%s/archive", root),
    builds = string.format("%s/builds", root),
    pkglist = string.format("%s/pkglist", root),
    env = string.format("%s/env", root),
    shell = os.getenv("PKGV_SHELL"),
    binaries = {},
}

system.name = system.os
if system.name == "darwin" then
    system.os_identifier = system.os
    system.name = "apple"
end
if system.arch.main == "arm64" then
    system.arch.main = "aarch64"
    system.arch.alternate = "arm64"
end

system.execute = function(cmd)
    local _, _, code = os.execute(cmd)
    return code == 0
end

system.file_archive = function(module)
    return string.format("%s/%s.%s%s", system.cache, module.name, module.version, module.extension)
end

system.read_file = function(path)
    local file = io.open(path, "r")
    if file == nil then
        error(string.format("failed to open %s for reading", path))
    end
    local content = file:read("*all")
    file:close()
    return content
end


system.git_clone = function(repository, dest)
    if not system.execute(string.format("test -d '%s' || git clone --quiet '%s' '%s'", dest, repository, dest)) then
        error(string.format("failed to clone: %s", repository))
    end
    if not system.execute(string.format("git -C '%s' pull --quiet", dest)) then
        error(string.format("failed to pull: %s", repository))
    end
end

system.untar = function(module, tar_args, dest)
    local archive = system.file_archive(module)
    utils.prepare_directory(dest)
    if not system.execute(string.format("tar xf '%s' %s -C '%s'", archive, tar_args, dest)) then
        error(string.format("unable to unpack: %s", archive))
    end
end

system.write_file = function(path, content, mode)
    local file = io.open(path, "w")
    if file == nil then
        error(string.format("unable to open %s", path))
    end
    file:write(content)
    file:close()
    os.execute(string.format("chmod %s '%s'", mode, path))
end

system.write_env = function(env_file, content)
    system.write_file(env_file, "#!/bin/sh\n" .. content, "644")
end

system.create_script = function(path, content)
    system.write_file(path, content, "755")
end

local make_export = function(key, value)
    return string.format("export %s=\"%s:$%s\"", key, value, key)
end

system.make_path_export = function(dest)
    return make_export("PATH", dest)
end

system.make_completion = function(dest)
    return string.format("source " .. dest)
end

system.go_install = function(url, version, dest, env_file)
    utils.prepare_directory(dest)
    if not system.execute(string.format("cd \"%s\" && GOBIN=\"$PWD\" '%s' install %s@%s", dest, system.binaries["go"], url, version)) then
        error("failed to go install")
    end
    if env_file == nil then
        return
    end
    system.write_env(env_file, system.make_path_export(dest))
end

return system
