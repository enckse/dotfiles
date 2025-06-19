local filter_darwin = function(app)
    return function(config)
        if config.run(string.format("test -d '/Applications/%s.app'", app)) then
            return config.os == "darwin"
        end
        return false
    end
end
return {
    { url = "https://github.com/kovidgoyal/kitty",         selector = filter_darwin("kitty") },
    { url = "https://github.com/rxhanson/Rectangle",       selector = filter_darwin("Rectangle") },
    { url = "https://gitlab.alpinelinux.org/alpine/aports" },
}
