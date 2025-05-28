local module = {
    version = "14.1.1",
    name = "ripgrep",
    extension = ".tar.gz",
    hash = {
        darwin = "24ad767"
    },
    upstream = "https://github.com/BurntSushi/ripgrep"
}

local package = require("modules.utils")
module.get = package.create_rust_get(module)
module.build = package.create_untar_build(module, "1")

return module
