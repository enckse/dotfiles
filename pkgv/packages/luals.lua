local module = {
    version = "3.14.0",
    name = "luals",
    extension = ".tar.gz",
    hash = {
        darwin = "85d67a1"
    },
    upstream = "https://github.com/LuaLS/lua-language-server"
}

local script = [[
#!/bin/sh
TMPPATH="/tmp/lua-language-server-$(id -u)"
mkdir -p "$TMPPATH"
INSTANCEPATH=$(mktemp -d "$TMPPATH/instance.XXXX")
DEFAULT_LOGPATH="$INSTANCEPATH/log"
DEFAULT_METAPATH="$INSTANCEPATH/meta"
LUALS="%s"

exec $LUALS/bin/lua-language-server $LUALS/main.lua \
  --logpath="$DEFAULT_LOGPATH" \
  --metapath="$DEFAULT_METAPATH" \
  "$@"
]]

module.get = function(system)
    system.download(string.format("%s/releases/download/%s/lua-language-server-%s-%s-%s%s",
                                  module.upstream,
                                  module.version,
                                  module.version,
                                  system.os,
                                  system.arch.alternate,
                                  module.extension))
end

module.build = function(system, dest, env_file)
    system.untar(module, "", dest)
    system.create_script(dest .. "/lua-language-server", string.format(script, dest))
    system.write_env(env_file, system.make_path_export(dest))
end

return module
