--[[
Name: Prat BottleCap
Author: Ethan Centaurai
Description: Converts ALL CAPS CHAT into all lower case chat for the end user
Dependencies: Prat-3.0
]]--

local PRAT_MODULE = Prat:RequestModuleName("BottleCap")
if PRAT_MODULE == nil then return end

local BottleCap = Prat:NewModule(PRAT_MODULE)


Prat:SetModuleDefaults(BottleCap.name, { profile = { on = true, verbose = false }})
Prat:SetModuleOptions(BottleCap, {
	name = "BottleCap",
	desc = "Converts ALL CAPS CHAT into all lower case chat for the end user",
	type = "group",
	args = {
		verbose = {
			name = "Verbose Mode",
			desc = "Convert all chat, regardless of case, into lowercase text (except if it has a link in it).",
			type = "toggle", order = 1,
		},
	},
})


function BottleCap:OnModuleEnable()
	Prat.RegisterChatEvent(self, "Prat_PreAddMessage")
end

function BottleCap:OnModuleDisable()
	Prat.UnregisterAllChatEvents(self)
end

function BottleCap:Prat_PreAddMessage(_, message, frame, event, t, r, g, b)
	local msg = message.MESSAGE

	if msg:find("|[Hh]") then return end -- ignore chat with hyperlinks, we screw it up otherwise

	if self.db.profile.verbose or msg == msg:upper() then
		-- Verbose Mode = all chat becomes lower case, regardless of original case
		-- else all ALL CAPS CHAT becomes lower case
		message.MESSAGE = msg:lower()
	end
end

