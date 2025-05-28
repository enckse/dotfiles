local module = {
    version = "v0.8.0",
    name = "gofumpt",
    release = 1,
    upstream = "https://github.com/mvdan/gofumpt"
}

local utils = require("modules.utils")
module.build = utils.create_go_build(module, "mvdan.cc/gofumpt")

return module
