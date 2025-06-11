local filter_darwin = function(config)
    return config.os == "darwin"
end
return {
  {url = "https://github.com/kovidgoyal/kitty", selector = filter_darwin},
  {url = "https://github.com/rxhanson/Rectangle", selector = function(config)
      local _, _, code = os.execute("test -d '/Applications/Rectangle.app'")
      if code == 0 then
          return filter_darwin(config)
      end
      return false
  end},
  {url = "https://gitlab.alpinelinux.org/alpine/aports"}
}
