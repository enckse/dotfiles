local module = {
    version = "0.0.1",
    name = "go-utils",
    release = 2,
    upstream = "none",
}

module.build = function(_, dest, env_file)
    require("modules.ioutils"):copy_source_scripts(dest, env_file, {"go-lint", "go-mod-updates"}, "sh")
end

return module
