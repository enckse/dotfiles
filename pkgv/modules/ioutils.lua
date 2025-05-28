module = {
    read_stdout = function(cmd)
        local file = io.popen(cmd, 'r')
        if file == nil then
            error(string.format("command failed: %s", cmd))
        end
        local text = file:read("*all")
        file:close()
        return string.gsub(text, "%s+", "")
    end,
    prepare_directory = function(dest)
        os.execute(string.format("rm -rf '%s' && mkdir -p '%s'", dest, dest))
    end,
    execute = function(cmd)
        local _, _, code = os.execute(cmd)
        return code == 0
    end,
    read_file = function(path)
        local file = io.open(path, "r")
        if file == nil then
            error(string.format("failed to open %s for reading", path))
        end
        local content = file:read("*all")
        file:close()
        return content
    end,
    write_file = function(path, content, mode)
        local file = io.open(path, "w")
        if file == nil then
            error(string.format("unable to open %s", path))
        end
        file:write(content)
        file:close()
        os.execute(string.format("chmod %s '%s'", mode, path))
    end
}
module.git_clone = function(repository, dest)
    if not module.execute(string.format("test -d '%s' || git clone --quiet '%s' '%s'", dest, repository, dest)) then
        error(string.format("failed to clone: %s", repository))
    end
    if not module.execute(string.format("git -C '%s' pull --quiet", dest)) then
        error(string.format("failed to pull: %s", repository))
    end
end
module.write_env = function(env_file, content)
    module.write_file(env_file, "#!/bin/sh\n" .. content, "644")
end
module.create_script = function(path, content)
    module.write_file(path, content, "755")
end

local make_export = function(key, value)
    return string.format("export %s=\"%s:$%s\"", key, value, key)
end

module.make_path_export = function(dest)
    return make_export("PATH", dest)
end

module.make_completion = function(dest)
    return string.format("source " .. dest)
end

module.make_path_and_completion = function(env_file, dest, completions)
    local contents = module.make_path_export(dest)
    contents = contents .. "\nsource '" .. completions .. "'"
    module.write_env(env_file, contents)
end

module.copy_source_scripts = function(dest, env_file, scripts, ext)
    module.prepare_directory(dest)
    for _, script in pairs(scripts) do
        local contents = module.read_file(string.format("src/%s.%s", script, ext))
        module.create_script(dest .. "/" .. script, contents)
    end
    module.write_env(env_file, module.make_path_export(dest))
end

return module
