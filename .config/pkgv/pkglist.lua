local filter_darwin = function(app)
    return function(config)
        local _, _, code = os.execute(string.format("test -d '/Applications/%s.app'", app))
        if code == 0 then
            return config.os == "darwin"
        end
        return false
    end
end
return {
  {url = "https://github.com/kovidgoyal/kitty", selector = filter_darwin("kitty")},
  {url = "https://github.com/rxhanson/Rectangle", selector = filter_darwin("Rectangle")},
  {url = "https://gitlab.alpinelinux.org/alpine/aports"}
}
