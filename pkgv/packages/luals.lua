local module = {
    version = "3.14.0",
    name = "luals",
    release = 1,
    extension = ".tar.gz",
    hash = {
        darwin = "85d67a1"
    },
    upstream = "https://github.com/LuaLS/lua-language-server"
}

module.get = function(system)
    system.download(string.format("%s/releases/download/%s/lua-language-server-%s-%s-%s%s",
                                  module.upstream,
                                  module.version,
                                  module.version,
                                  system.os,
                                  system.arch.alternate,
                                  module.extension))
end

module.build = function(system, dest, env_file)
    system:untar(module, "", dest)
    local ioutils = require("modules.ioutils")
    ioutils:write_env(env_file, ioutils:make_path_export(dest .. "/bin"))
end

return module
