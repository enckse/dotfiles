local module = {
    version = "4.9",
    name = "sed",
    extension = ".tar.xz",
    hash = {
        source = "6e226b7"
    },
    upstream = "https://github.com/mirror/sed"
}

module.get = function(system)
    system.download(string.format("https://ftp.gnu.org/pub/gnu/%s/%s-%s%s", module.name, module.name, module.version, module.extension))
end

module.build = function(system, dest, env_file)
    system.untar(module, "--strip-components=1", dest)
    if not system.execute(string.format("cd '%s' && ./configure --disable-i18n --disable-nls", dest)) then
        error("configure failed")
    end
    if not system.execute(string.format("cd '%s' && make", dest)) then
        error("build failed")
    end
    system.write_env(env_file, system.make_path_export(dest .. "/sed"))
end

return module
