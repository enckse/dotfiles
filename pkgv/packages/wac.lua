local ioutils = require("modules.ioutils")
local repo = "private:wac"
local hash = ioutils.read_stdout(string.format("git ls-remote '%s' | grep 'HEAD' | cut -c 1-7", repo))

local module = {
    version = hash,
    release = 1,
    name = "wac",
    upstream = "none",
}

module.get = function()
end

module.build = function(system, dest, env_file)
    ioutils:git_clone(repo, dest)
    local path = ""
    for _, k in pairs({"just", "go", "lb"}) do
        if path ~= "" then
            path = path .. ":"
        end
        path = path .. string.format("$(dirname '%s')", system.binaries[k])
    end
    path = path .. ":$PATH"
    if not ioutils.execute(string.format("cd '%s' && PATH=\"%s\" just", dest, path)) then
        error("failed to build")
    end
    ioutils:write_env(env_file, ioutils:make_path_export(dest .. "/target"))
end

return module
