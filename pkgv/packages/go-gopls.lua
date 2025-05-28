local module = {
    version = "v0.18.1",
    name = "gopls",
    release = 1,
    -- NOTE: while gopls would use a filter, tools is already tracked
    upstream = "none"
}

local package = require("modules.utils")
module.get = function() end
module.build = package.create_go_build(module, "golang.org/x/tools/gopls")

return module
