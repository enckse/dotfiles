local module = {
    version = "v0.10.0",
    name = "shellcheck",
    extension = ".tar.xz",
    hash = {
        darwin = "bbd2f14"
    },
    upstream = "https://github.com/koalaman/shellcheck"
}

module.get = function(system)
    system.download(string.format("%s/releases/download/%s/%s-%s.%s.%s%s",
                                  module.upstream,
                                  module.version,
                                  module.name,
                                  module.version,
                                  system.os,
                                  system.arch.main,
                                  module.extension))
end

local package = require("modules.utils")
module.build = package.create_untar_build(module, "1")

return module
