local module = {
    version = "v0.33.0",
    name = "fieldassignment",
    release = 1,
    upstream = "https://github.com/golang/tools"
}

local package = require("modules.utils")
module.get = function() end
module.build = package.create_go_build(module, "golang.org/x/tools/go/analysis/passes/fieldalignment/cmd/fieldalignment")

return module
