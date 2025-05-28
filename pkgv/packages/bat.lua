local module = {
    version = "v0.25.0",
    name = "bat",
    release = 1,
    extension = ".tar.gz",
    hash = {
        darwin = "b3ed5a7"
    },
    upstream = "https://github.com/sharkdp/bat"
}

local utils = require("modules.utils")
module.get = utils.create_rust_get(module)
module.build = utils.create_untar_build(module, "1")

return module
