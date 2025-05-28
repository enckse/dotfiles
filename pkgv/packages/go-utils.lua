local module = {
    version = "0.0.1",
    name = "go-utils",
    release = 1,
    upstream = "none",
}

module.get = function()
end

module.build = function(_, dest, env_file)
    local ioutils = require("modules.ioutils")
    ioutils.prepare_directory(dest)
    for _, script in pairs({"go-lint", "go-mod-updates"}) do
        local contents = ioutils.read_file(string.format("src/%s.sh", script))
        ioutils.create_script(dest .. "/" .. script, contents)
    end
    ioutils.write_env(env_file, ioutils.make_path_export(dest))
end

return module
