local ioutils = require("modules.ioutils")
local repos = {
    "https://github.com/vim-airline/vim-airline",
    "https://github.com/dense-analysis/ale"
}

local hash = ""
for _, r in pairs(repos) do
    hash = hash .. ioutils.read_stdout(string.format("git ls-remote '%s' | grep 'HEAD' | cut -c 1-7", r))
end

local module = {
    version = hash,
    release = 1,
    name = "vim-plugins",
    upstream = "none",
}

local script = [[
#!/bin/sh
VIM_PACK="$HOME/.config/vim/pack/plugins/start"
VIM_DIR="$(dirname "$VIM_PACK")"

_vimlink() {
  [ ! -d "$VIM_DIR" ] &&  mkdir -p "$VIM_DIR"
  [ -e "$VIM_PACK" ] && [ "$(readlink "$VIM_PACK")" = "%s" ] && return
  rm -f "$VIM_PACK"
  ln -sf "%s" "$VIM_PACK"
}
_vimlink
]]

module.get = function() end

module.build = function(system, dest, env_file)
    local archive = string.format("%s/%s", system.cache, module.name)
    if not ioutils.execute(string.format("mkdir -p '%s'", archive)) then
        error(string.format("unable to make archive dir: %s", archive))
    end
    ioutils.prepare_directory(dest)
    for _, r in pairs(repos) do
        local base = ioutils.read_stdout(string.format("basename '%s'", r))
        local clone = string.format("%s/%s", archive, base)
        ioutils:git_clone(r, clone)
        local target = string.format("%s/%s", dest, base)
        if not ioutils.execute(string.format("cp -r '%s' '%s'", clone, target)) then
            error(string.format("unable to setup %s", r))
        end
        if not ioutils.execute(string.format("git -C '%s' log -n 1 > '%s/.githash'", target, target)) then
            error(string.format("unable to version %s", r))
        end
        if not ioutils.execute(string.format("rm -rf '%s/.git'", target)) then
            error(string.format("unable to clean %s", r))
        end
    end
    ioutils:write_env(env_file, string.format(script, dest, dest))
end

return module
