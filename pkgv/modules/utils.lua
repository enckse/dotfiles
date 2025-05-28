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
            local ioutils = require("modules.ioutils")
            system:untar(module, string.format("--strip-components=%s", offset), dest)
            ioutils:write_env(env_file, ioutils:make_path_export(dest))
        end
    end,
    create_go_build = function(module, url)
        return function(system, dest, env_file)
            system:go_install(url, module.version, dest, env_file)
        end
    end,
    log = function(msg)
        print(string.format("-> %s", msg))
    end,
    create_github_source_get = function(module)
        return function(system)
            local url = require("modules.utils").get_url(module.upstream)
            system.download(string.format("%s/archive/refs/tags/%s%s", url, module.version, module.extension))
        end
    end,
    get_url = function(object)
        local url = object
        local filter = ""
        if type(url) ~= "string" then
            url = object.url
            filter = string.format(" '%s'", object.filter)
        end
        return url, filter
    end
}
