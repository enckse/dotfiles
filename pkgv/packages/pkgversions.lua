local module = {
    version = "0.0.1",
    name = "pkgversions",
    release = 2,
    upstream = "none",
}

module.get = function() end

module.build = function(_, dest, env_file)
    require("modules.ioutils"):copy_source_scripts(dest, env_file, {"pkgversions"}, "sh")
end

return module
