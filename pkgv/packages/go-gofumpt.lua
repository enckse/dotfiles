local module = {
    version = "v0.8.0",
    name = "gofumpt",
    release = 1,
    upstream = "https://github.com/mvdan/gofumpt"
}

local package = require("modules.utils")
module.get = function() end
module.build = package.create_go_build(module, "mvdan.cc/gofumpt")

return module
