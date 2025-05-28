local module = {
    version = "1.40.0",
    name = "just",
    release = 1,
    extension = ".tar.gz",
    hash = {
        darwin = "0fb2401"
    },
    upstream = "https://github.com/casey/just"
}

local utils = require("modules.utils")
module.get = utils.create_rust_get(module)

module.build = function(system, dest, env_file)
    system:untar(module, "", dest)
    require("modules.ioutils"):make_path_and_completion(env_file, dest, dest .."/completions/just." .. system.shell)
end

module.binary = function(dest)
    return dest .. "/just"
end

return module
