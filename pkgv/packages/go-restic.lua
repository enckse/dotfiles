local module = {
    version = "v0.18.0",
    release = 1,
    name = "restic",
    upstream = "https://github.com/restic/restic"
}

local utils = require("modules.utils")
module.build = utils.create_go_build(module, "github.com/restic/restic/cmd/restic")

return module
