local module = {
    version = os.getenv("LUA_VERSION"),
    name = "lua",
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
    system.untar(module, "--strip-components=1", dest)
    if not system.execute(string.format("cd '%s' && make", dest)) then
        error("build failed")
    end
    system.write_env(env_file, system.make_path_export(dest .. "/src"))
end

return module
