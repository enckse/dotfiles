local module = {
    version = "v1.4.5",
    release = 1,
    name = "lb",
    upstream = "https://git.sr.ht/~enckse/lockbox"
}

module.build = function(system, dest, env_file)
    local ioutils = require("modules.ioutils")
    system:go_install("git.sr.ht/~enckse/lockbox/cmd/lb", module.version, dest, nil)
    if not ioutils.execute(string.format("cd '%s' && SHELL='%s' ./lb completions > 'lb.%s'", dest, system.shell, system.shell)) then
        error("unable to generate completions")
    end
    ioutils:make_path_and_completion(env_file, dest, dest .."/lb." .. system.shell)
end

module.binary = function(dest)
    return dest .. '/lb'
end

return module
