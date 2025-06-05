local results = {}
if os.getenv("PKGV_DEPLOYED_OS") == "darwin" then
  table.insert(results, {url = "https://github.com/kovidgoyal/kitty"})
  table.insert(results, {url = "https://github.com/rxhanson/Rectangle"})
end
table.insert(results, {url = "https://gitlab.alpinelinux.org/alpine/aports"})
return results
