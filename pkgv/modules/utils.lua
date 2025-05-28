return {
    create_rust_get = function(module)
        return function(system)
            system.download(string.format("%s/releases/download/%s/%s-%s-%s-%s-%s%s",
                                            module.upstream,
                                            module.version,
                                            module.name,
                                            module.version,
                                            system.arch.main,
                                            system.name,
                                            system.os,
                                            module.extension))
        end
    end,
    create_untar_build = function(module, offset)
        return function(system, dest, env_file)
            system.untar(module, string.format("--strip-components=%s", offset), dest)
            system.write_env(env_file, system.make_path_export(dest))
        end
    end,
    create_go_build = function(module, url)
        return function(system, dest, env_file)
            system.go_install(url, module.version, dest, env_file)
        end
    end,
    read_stdout = function(cmd)
        local file = io.popen(cmd, 'r')
        if file == nil then
            error(string.format("command failed: %s", cmd))
        end
        local text = file:read("*all")
        file:close()
        return string.gsub(text, "%s+", "")
    end,
    log = function(msg)
        print(string.format("-> %s", msg))
    end
}
