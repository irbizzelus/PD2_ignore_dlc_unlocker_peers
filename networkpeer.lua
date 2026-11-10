local warn_in_chat = true -- customize this true/false

local anti_dlc_unlocker_tag_players = {[1] = false,[2] = false,[3] = false,[4] = false}
local anti_dlc_unlocker_tag_NP_MC_orig = NetworkPeer.mark_cheater
Hooks:OverrideFunction(NetworkPeer, "mark_cheater", function (self, reason, auto_kick)
	
	if Application:editor() or IS_CONSOLE then
		return
	end
	
	if VoteManager and VoteManager.REASON then
		local ignored_reasons = {
			[VoteManager.REASON.invalid_job] = "invalid_job",
			[VoteManager.REASON.invalid_mask] = "invalid_mask",
			[VoteManager.REASON.invalid_weapon] = "invalid_weapon",
			[VoteManager.REASON.invalid_character] = "invalid_character",
			[VoteManager.REASON.invalid_player_style] = "invalid_player_style",
			[VoteManager.REASON.invalid_glove_id] = "invalid_glove_id",
			[VoteManager.REASON.invalid_weapon_color] = "invalid_weapon_color",
			-- [VoteManager.REASON.invalid_henchmen] = "invalid_henchmen", -- checks if host's bots have valid upgrades, in addition to DLC outfits/guns so we dont ignore it. people who cheat dlc weapons *tend* to do it for themselves, not for bots
		}
		if ignored_reasons[reason] then
			if warn_in_chat and not anti_dlc_unlocker_tag_players[self:id()] then -- only warn once per player
				anti_dlc_unlocker_tag_players[self:id()] = true
				managers.chat:feed_system_message(ChatManager.GAME, "Ignored cheater tag application for \""..tostring(ignored_reasons[reason]).."\" on peer: "..tostring(self:name()))
			end
			for i=1,3 do
				log("[ANTI PEER DLC UNLOCKER CHEATER TAG] Ignored cheater tag application for \""..tostring(ignored_reasons[reason]).."\" on peer: "..tostring(self:name()))
			end
			return
		end
	end
	
	anti_dlc_unlocker_tag_NP_MC_orig(self, reason, auto_kick)
	
end)

-- reset report status on peer updates
Hooks:Add("BaseNetworkSessionOnPeerRemoved", "anti_dlc_unlocker_tag_onpeerremoved", function(peer, peer_id, reason)
	anti_dlc_unlocker_tag_players[peer_id] = false
end)