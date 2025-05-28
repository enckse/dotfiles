local module = {
    version = "0.0.1",
    name = "pkgversions",
    release = 1,
    upstream = "none",
}

module.get = function()
end

module.build = function(_, dest, env_file)
    local ioutils = require("modules.ioutils")
    ioutils.prepare_directory(dest)
    local contents = ioutils.read_file("src/pkgversions.sh")
    ioutils.create_script(dest .. "/pkgversions", contents)
    ioutils.write_env(env_file, ioutils.make_path_export(dest))
end

return module
