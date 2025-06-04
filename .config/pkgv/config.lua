local editor = os.getenv("DOTFILES_EDITOR")
local is_helix = editor == "hx"
local is_vim = editor == "vim"
local editor_namespace = "[.]editors[.]"
return {
    enabled = function(name)
        if string.find(name, editor_namespace) then
            if string.find(name, editor_namespace .. "vim") then
                return is_vim
            else
                return is_helix
            end
        end
        if string.find(name, "[.]utils[.]mksquashfs") then
            return false
        end
        return true
    end
}
