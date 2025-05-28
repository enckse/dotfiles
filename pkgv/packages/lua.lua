local module = {
    version = os.getenv("LUA_VERSION"),
    name = "lua",
    release = 1,
    extension = ".tar.gz",
    hash = {
        source = os.getenv("LUA_HASH")
    },
    upstream = "https://github.com/lua/lua"
}

module.get = function(system)
    system.download(os.getenv("LUA_URL"))
end

module.build = function(system, dest, env_file)
    system:untar(module, "--strip-components=1", dest)
    local ioutils = require("modules.ioutils")
    if not ioutils.execute(string.format("cd '%s' && make", dest)) then
        error("build failed")
    end
    ioutils:write_env(env_file, ioutils:make_path_export(dest .. "/src"))
end

return module
