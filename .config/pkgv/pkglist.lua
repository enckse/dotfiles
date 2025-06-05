local filter_darwin = function(config)
    return config.os == "darwin"
end
return {
  {url = "https://github.com/kovidgoyal/kitty", selector = filter_darwin},
  {url = "https://github.com/rxhanson/Rectangle", selector = filter_darwin},
  {url = "https://gitlab.alpinelinux.org/alpine/aports"}
}
