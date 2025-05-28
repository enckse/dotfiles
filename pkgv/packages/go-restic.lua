local module = {
    version = "v0.18.0",
    name = "restic",
    upstream = "https://github.com/restic/restic"
}

local package = require("modules.utils")
module.get = function() end
module.build = package.create_go_build(module, "github.com/restic/restic/cmd/restic")

return module
