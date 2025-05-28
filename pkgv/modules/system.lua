local ioutils = require("modules.ioutils")
local root = os.getenv("PKGV_STORE")
if root == nil then
    error("PKGV_STORE not set?")
end
local name = os.getenv("PKGV_OS")
local arch = os.getenv("PKGV_ARCH")

return {
    os = name,
    arch = (function()
        if arch == "arm64" then
            return {
                main = "aarch64",
                alternate = arch
            }
        end
        return {
            main = arch
        }
    end)(),
    cache = string.format("%s/archive", root),
    builds = string.format("%s/builds", root),
    pkglist = string.format("%s/pkglist", root),
    env = string.format("%s/env", root),
    shell = os.getenv("PKGV_SHELL"),
    binaries = {},
    name = (function()
        if name == "darwin" then
            return "apple"
        end
        return name
    end)(),
    os_identifier = name,
    file_archive = function(self, module)
        return string.format("%s/%s.%s%s", self.cache, module.name, module.version, module.extension)
    end,
    untar = function(self, module, tar_args, dest)
        local archive = self:file_archive(module)
        ioutils.prepare_directory(dest)
        if not ioutils.execute(string.format("tar xf '%s' %s -C '%s'", archive, tar_args, dest)) then
            error(string.format("unable to unpack: %s", archive))
        end
    end,
    go_install = function(self, url, version, dest, env_file)
        ioutils.prepare_directory(dest)
        if not ioutils.execute(string.format("cd \"%s\" && GOBIN=\"$PWD\" '%s' install %s@%s", dest, self.binaries["go"], url, version)) then
            error("failed to go install")
        end
        if env_file == nil then
            return
        end
        ioutils:write_env(env_file, ioutils:make_path_export(dest))
    end
}
