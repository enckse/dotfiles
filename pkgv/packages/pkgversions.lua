local module = {
    version = "0.0.1",
    name = "pkgversions",
    release = 1,
    upstream = "none",
}

module.get = function()
end

module.build = function(system, dest, env_file)
    system.prepare_directory(dest)
    local contents = system.read_file("src/pkgversions.sh")
    system.create_script(dest .. "/pkgversions", contents)
    system.write_env(env_file, system.make_path_export(dest))
end

return module
