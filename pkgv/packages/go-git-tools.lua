local module = {
    version = "v0.3.1",
    name = "git-tools",
    release = 1,
    upstream = "https://git.sr.ht/~enckse/git-tools"
}

local utils = require("modules.utils")
module.get = function() end
module.build = utils.create_go_build(module, "git.sr.ht/~enckse/git-tools/cmd/...")

return module
