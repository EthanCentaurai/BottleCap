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
			desc = "Convert all chat, regardless of original case, into lowercase text.",
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
	if event == "CHAT_MSG_SYSTEM" then return end

	local msg = message.MESSAGE

	if self.db.profile.verbose or msg == msg:upper() then
		-- Verbose Mode = all chat becomes lower case, regardless of original case
		-- else all ALL CAPS CHAT becomes lower case
		msg = msg:lower()
	end

	-- Fix links
	msg = msg:gsub("|hitem", "|Hitem")
	msg = msg:gsub("|hquest", "|Hquest")
	msg = msg:gsub("|hspell", "|Hspell")
	msg = msg:gsub("|htalent", "|Htalent")
	msg = msg:gsub("|hachievement", "|Hachievement")
	msg = msg:gsub("|htrade", "|Htrade")
	msg = msg:gsub("|henchant", "|Henchant")

	message.MESSAGE = msg
end

