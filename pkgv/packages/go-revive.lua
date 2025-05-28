local module = {
    version = "v1.9.0",
    release = 1,
    name = "revive",
    upstream = "https://github.com/mgechev/revive"
}

local package = require("modules.utils")
module.get = function() end
module.build = package.create_go_build(module, "github.com/mgechev/revive")

return module
