local module = {
    version = "0.0.1",
    name = "transcode-media",
    release = 1,
    upstream = "none",
}

module.build = function(_, dest, env_file)
    require("modules.ioutils"):copy_source_scripts(dest, env_file, {"transcode-media"}, "sh")
end

return module
