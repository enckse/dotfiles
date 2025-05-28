local module = {
    version = "4.6.1",
    name = "mksquashfs",
    release = 1,
    extension = ".tar.gz",
    hash = {
        source = "9420175",
    },
    upstream = "https://github.com/plougher/squashfs-tools"
}

module.get = require("modules.utils").create_github_source_get(module)
module.build = function(system, dest, env_file)
    local ioutils = require("modules.ioutils")
    system:untar(module, "--strip-components=1", dest)
    local sub = string.format("%s/%s", dest, "squashfs-tools")
    if not ioutils.execute(string.format("cd '%s' && make", sub)) then
        error("build failed")
    end
    ioutils:write_env(env_file, ioutils:make_path_export(sub))
end

return module
