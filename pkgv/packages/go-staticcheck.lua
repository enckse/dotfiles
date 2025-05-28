local module = {
    version = "v0.6.1",
    release = 1,
    name = "staticcheck",
    upstream = "https://github.com/dominikh/go-tools"
}

local package = require("modules.utils")
module.get = function() end
module.build = package.create_go_build(module, "honnef.co/go/tools/cmd/staticcheck")

return module
