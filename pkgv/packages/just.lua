local module = {
    version = "1.40.0",
    name = "just",
    extension = ".tar.gz",
    hash = {
        darwin = "0fb2401"
    },
    upstream = "https://github.com/casey/just"
}

local package = require("modules.utils")
module.get = package.create_rust_get(module)

module.build = function(system, dest, env_file)
    system.untar(module, "", dest)
    local contents = system.make_path_export(dest)
    contents = contents .. "\n" .. system.make_completion(dest .. "/completions/just." .. system.shell)
    system.write_env(env_file, contents)
end

module.binary = function(dest)
    return dest .. "/just"
end

return module
