local editor = os.getenv("DOTFILES_EDITOR")
local is_helix = editor == "hx"
local is_vim = editor == "vim"
local is_nvim = editor == "nvim"
local editor_namespace = "[.]editors[.]"
return {
	enabled = function(name, system)
		local disabled = { cmake = is_nvim, mksquashfs = false, just = false, jj = false }
		if system.os == "linux" then
			disabled.sed = false
			disabled.container = false
		elseif system.os == "darwin" then
			disabled.age = false
		end
		if string.find(name, editor_namespace) then
			if string.find(name, editor_namespace .. "vim") then
				return is_vim and system.os ~= "linux"
			end
			if string.find(name, editor_namespace .. "nvim") then
				return is_nvim
			end
			if string.find(name, editor_namespace .. "plugins") then
				return is_nvim or is_vim
			end
			if string.find(name, editor_namespace .. "helix") then
				return is_helix
			end
			return false
		end
		for opt, allowed in pairs(disabled) do
			local match = "[.]" .. opt .. "[.]"
			if string.find(name, match) then
				return allowed
			end
		end
		return true
	end,
}
