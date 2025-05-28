local module = {
    version = "v0.18.1",
    release = 1,
    name = "modernize",
    upstream = "https://github.com/golang/tools"
}

local package = require("modules.utils")
module.get = function() end
module.build = package.create_go_build(module, "golang.org/x/tools/gopls/internal/analysis/modernize/cmd/modernize")

return module
