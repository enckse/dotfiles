local module = {
    version = "v9.1.1415",
    name = "vim",
    extension = ".tar.gz",
    release = 1,
    hash = {
        source = "8543373"
    },
    upstream = {
        url = "https://github.com/vim/vim",
        filter = "(00|20|40|60|80)$"
    }
}

module.get = function(system)
    system.download(string.format("%s/archive/refs/tags/%s%s", module.upstream.url, module.version, module.extension))
end

module.build = function(system, dest, env_file)
    system:untar(module, "--strip-components=1", dest)
    local ioutils = require("modules.ioutils")
    if not ioutils.execute(string.format("cd '%s' && ./configure --enable-multibyte --with-tlib=ncurses --enable-terminal --disable-gui --without-x", dest)) then
        error("configure failed")
    end
    if not ioutils.execute(string.format("cd '%s' && make", dest)) then
        error("build failed")
    end
    local content = ioutils:make_path_export(dest .. "/src")
    content = content .. string.format("\nexport VIM=\"%s\"", dest)
    ioutils:write_env(env_file, content)
end

return module
