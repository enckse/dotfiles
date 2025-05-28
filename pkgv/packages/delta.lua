local module = {
    version = "0.18.2",
    name = "delta",
    release = 1,
    extension = ".tar.gz",
    hash = {
        darwin = "6ba38dc"
    },
    upstream = "https://github.com/dandavison/delta"
}

local utils = require("modules.utils")
module.get = utils.create_rust_get(module)
module.build = utils.create_untar_build(module, "1")

return module
