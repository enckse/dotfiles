local module = {
    version = "14.1.1",
    name = "ripgrep",
    release = 1,
    extension = ".tar.gz",
    hash = {
        darwin = "24ad767"
    },
    upstream = "https://github.com/BurntSushi/ripgrep"
}

local utils = require("modules.utils")
module.get = utils.create_rust_get(module)
module.build = utils.create_untar_build(module, "1")

return module
