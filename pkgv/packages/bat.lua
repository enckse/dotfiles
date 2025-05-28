local module = {
    version = "v0.25.0",
    name = "bat",
    extension = ".tar.gz",
    hash = {
        darwin = "b3ed5a7"
    },
    upstream = "https://github.com/sharkdp/bat"
}

local package = require("modules.utils")
module.get = package.create_rust_get(module)
module.build = package.create_untar_build(module, "1")

return module
