local remote = -- remoteevent

local args = {

	-- args

}

local mt = getrawmetatable(game)
setreadonly(mt, false)

local old
old = hookmetamethod(game, "__namecall", function(self, ...)
	local method = getnamecallmethod()

	if self == remote and (method == "InvokeServer" or method == "FireServer") then
		return old(self, table.unpack(args))
	end

	return old(self, ...)
end)

setreadonly(mt, true)
