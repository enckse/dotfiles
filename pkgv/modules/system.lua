local ioutils = require("modules.ioutils")
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

system.file_archive = function(self, module)
    return string.format("%s/%s.%s%s", self.cache, module.name, module.version, module.extension)
end

system.untar = function(self, module, tar_args, dest)
    local archive = self:file_archive(module)
    ioutils.prepare_directory(dest)
    if not ioutils.execute(string.format("tar xf '%s' %s -C '%s'", archive, tar_args, dest)) then
        error(string.format("unable to unpack: %s", archive))
    end
end

system.go_install = function(self, url, version, dest, env_file)
    ioutils.prepare_directory(dest)
    if not ioutils.execute(string.format("cd \"%s\" && GOBIN=\"$PWD\" '%s' install %s@%s", dest, self.binaries["go"], url, version)) then
        error("failed to go install")
    end
    if env_file == nil then
        return
    end
    ioutils:write_env(env_file, ioutils:make_path_export(dest))
end

return system
