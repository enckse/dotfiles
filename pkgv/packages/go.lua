local module = {
    version = "1.24.3",
    name = "go",
    extension = ".tar.gz",
    hash = {
        darwin = "64a3fa2"
    },
    upstream = "https://github.com/golang/go"
}

module.get = function(system)
    system.download(string.format("https://go.dev/dl/go%s.%s-%s%s", module.version, system.os, system.arch.alternate, module.extension))
end

local binary = function(dest)
    return dest .. "/bin"
end

module.build = function(system, dest, env_file)
    system.untar(module, "--strip-components=1", dest)
    system.write_env(env_file, system.make_path_export(binary(dest)))
end

module.binary = function(dest)
    return binary(dest) .. "/go"
end

return module
