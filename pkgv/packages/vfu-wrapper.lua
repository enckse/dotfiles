local module = {
    release = 1,
    name = "vfu-wrapper",
    upstream = "none",
    version = "",
}

local ioutils = require("modules.ioutils")
local repo = "https://git.sr.ht/~enckse/vfu"
module.version = ioutils:git_remote_head_hash(repo)

module.build = function(system, dest, env_file)
    ioutils:git_clone(repo, dest)
    local contrib = dest .. "/contrib"
    if not ioutils.execute(string.format("cd '%s' && ./vfu completions > 'vfu.%s'", contrib, system.shell)) then
        error("unable to generate completions")
    end
    ioutils:make_path_and_completion(env_file, contrib, contrib .."/vfu." .. system.shell)
end

return module
