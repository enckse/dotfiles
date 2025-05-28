local module = {
    version = "0.0.1",
    name = "go-utils",
    release = 1,
    upstream = "none",
}

module.get = function()
end

module.build = function(system, dest, env_file)
    local utils = require("modules.utils")
    utils.prepare_directory(dest)
    for _, script in pairs({"go-lint", "go-mod-updates"}) do
        local contents = system.read_file(string.format("src/%s.sh", script))
        system.create_script(dest .. "/" .. script, contents)
    end
    system.write_env(env_file, system.make_path_export(dest))
end

return module
