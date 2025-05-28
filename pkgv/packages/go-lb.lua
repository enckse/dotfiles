local module = {
    version = "v1.4.5",
    release = 1,
    name = "lb",
    upstream = "https://git.sr.ht/~enckse/lockbox"
}

module.get = function() end
module.build = function(system, dest, env_file)
    system.go_install("git.sr.ht/~enckse/lockbox/cmd/lb", module.version, dest, nil)
    if not system.execute(string.format("cd '%s' && SHELL='%s' ./lb completions > 'lb.%s'", dest, system.shell, system.shell)) then
        error("unable to generate completions")
    end
    local contents = system.make_path_export(dest)
    contents = contents .. "\n" .. system.make_completion(dest .. "/lb." .. system.shell)
    system.write_env(env_file, contents)
end

module.binary = function(dest)
    return dest .. '/lb'
end

return module
