return {
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
    end,
    git_clone = function(self, repository, dest)
        if not self.execute(string.format("test -d '%s' || git clone --quiet '%s' '%s'", dest, repository, dest)) then
            error(string.format("failed to clone: %s", repository))
        end
        if not self.execute(string.format("git -C '%s' pull --quiet", dest)) then
            error(string.format("failed to pull: %s", repository))
        end
    end,
    write_env = function(self, env_file, content)
        self.write_file(env_file, "#!/bin/sh\n" .. content, "644")
    end,
    create_script = function(self, path, content)
        self.write_file(path, content, "755")
    end,
    make_export = function(key, value)
        return string.format("export %s=\"%s:$%s\"", key, value, key)
    end,
    make_path_export = function(self, dest)
        return self.make_export("PATH", dest)
    end,
    make_completion = function(dest)
        return string.format("source " .. dest)
    end,
    make_path_and_completion = function(self, env_file, dest, completions)
        local contents = self:make_path_export(dest)
        contents = contents .. "\nsource '" .. completions .. "'"
        self:write_env(env_file, contents)
    end,
    copy_source_scripts = function(self, dest, env_file, scripts, ext)
        self.prepare_directory(dest)
        for _, script in pairs(scripts) do
            local contents = self.read_file(string.format("src/%s.%s", script, ext))
            self:create_script(dest .. "/" .. script, contents)
        end
        self:write_env(env_file, self:make_path_export(dest))
    end,
    git_remote_head_hash = function(self, repository)
        return self.read_stdout(string.format("git ls-remote '%s' | grep 'HEAD' | cut -c 1-7", repository))
    end
}
