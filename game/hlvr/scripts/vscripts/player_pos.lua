DoIncludeScript("bindings.lua", nil)

_G.flashlight_on = "0"
function Spawn()
	-- Registers a function to get called each time the entity updates, or "thinks"
	thisEntity:SetContextThink(nil, MainThinkFunc, 0)
end

function MainThinkFunc()
	local playerEnt_pos = Entities:GetLocalPlayer()
	local startVector = playerEnt_pos:EyePosition()
	local playerHealth = playerEnt_pos:GetHealth()
	local traceTable =
	{
		startpos = startVector;
		endpos = startVector + RotatePosition(Vector(0,0,0), playerEnt_pos:EyeAngles(), Vector(200, 0, 0));
		ignore = playerEnt_pos;
		mask =  33636363; -- TRACE_MASK_PLAYER_SOLID from L4D2 script API, may not be correct for Source 2.
	}
	local fullpos = string.sub(string.format("%s", startVector),26,-2)
	--print(fullpos)
	local xpos_index = string.find(fullpos, " ")
	--print(xpos_index)
	local xpos = tonumber(string.sub(fullpos,0,xpos_index - 1))
	--print("Current x position: " .. xpos)
	local ypos_index = string.find(fullpos, " ", xpos_index + 1)
	--print(ypos_index)
	local ypos = tonumber(string.sub(fullpos,xpos_index + 1,ypos_index - 1))
	--print("Current y position: " .. ypos)
	local zpos = tonumber(string.sub(fullpos,ypos_index + 1,fullpos:len()))
	--print("Current z position: " .. zpos)
	
	-- POSITION
	if GetMapName() == "a1_intro_world" then
		if ( xpos > 464 and xpos < 519 ) and ( ypos > -2374 and ypos < -2303 ) then
			if _G.end_vent_shown == nil then
				local ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="230 230 230", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=5, ["x"]=-1, ["y"]=0.6})
				DoEntFireByInstanceHandle(ent, "SetText", "Press [" .. INTERACT .. "] to open the vent\n\nPress [" .. CROUCH .. "] and [" .. JUMP .. "] to get into the vent", 0, nil, nil)
				DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
				_G.end_vent_shown = "1"
			end
		elseif ( xpos > 562 and xpos < 655 ) and ( ypos > -2359 and ypos < -2310 ) then
			SendToConsole("ent_fire 563_vent_phys_hinge setoffset 0")
		end
	elseif GetMapName() == "a1_intro_world_2" then
		if ( xpos > -1370.55 and xpos < -1366.44 ) and ( ypos > 2295 and ypos < 2343 ) and ( zpos > -100 and zpos < -90 ) then
			SendToConsole("setpos_player 1 -1408 2307 -114")
			SendToConsole("ent_fire 4962_car_door_left_front open")
		elseif ( xpos > -1745 and xpos < -1710 ) and ( ypos > 324 and ypos < 327 ) and ( zpos > 140 and zpos < 143 ) then
			SendToConsole("setpos_player 1 -1727.60 303.17 94.03")
		end
	elseif GetMapName() == "a3_station_street" then
		if ( xpos > 1436 and xpos < 1462 ) and ( ypos > -1370 and ypos < -1366 ) then
			SendToConsole("setpos_player 1 1449.94 -1393.25 160.53")
			SendToConsole("ent_fire 2860_window_wedge break")
			SendToConsole("ent_fire 2860_window_sliding1 wake")
		end
	elseif GetMapName() == "a3_hotel_interior_rooftop" then
		if ( xpos > 753.8 and xpos < 765 ) and ( ypos > -1440 and ypos < -1407 ) then
			SendToConsole("setpos_player 1 791.77 -1425.97 576.66")
			SendToConsole("ent_fire zombieparty_window_slideconstraint setoffset 0")
		end
	end
	
	-- FLASHLIGHT
	if playerEnt_pos:Attribute_GetIntValue("auto_flashlight", 1) == 1 then
		if Entities:GetLocalPlayer():Attribute_GetIntValue("flashlight_on", 0) == 1 and _G.flashlight_on == "0" then -- to help with turning on the auto flashlight after reload
			SendToConsole("disable_flashlight; inv_flashlight")
		end
		if string.match(GetMapName(), "a2_headcrabs_tunnel") then
			if ( xpos > 991 and xpos < 1072 ) and ( ypos > -2456 and ypos < -2375 ) then
				Entities:GetLocalPlayer():Attribute_SetIntValue("flashlight_on", 0) -- make sure the flashlight is turned off on the next map
				_G.flashlight_on = "0"
			elseif (xpos > 1107 and xpos < 1212 ) and ( ypos > -2424 and ypos < -2375 ) then
				if Entities:GetLocalPlayer():Attribute_GetIntValue("flashlight_on", 0) == 0 then
					SendToConsole("inv_flashlight")
				end
			end
		elseif string.match(GetMapName(), "a2_drainage") then
			if (xpos > 1405 and xpos < 1477 ) and ( ypos > -1842 and ypos < -1794 ) then
				Entities:GetLocalPlayer():Attribute_SetIntValue("flashlight_on", 0) -- make sure the flashlight is turned off on the next map
				_G.flashlight_on = "0"
			elseif ( xpos > 883 and xpos < 960 ) and ( ypos > -2600 and ypos < -2400 ) and ( zpos > 100 and zpos < 210 ) then
				if Entities:GetLocalPlayer():Attribute_GetIntValue("flashlight_on", 0) == 0 then
					SendToConsole("inv_flashlight")
				end
			elseif ( xpos > 1313 and xpos < 1362 ) and ( ypos > -1940 and ypos < -1838 ) then
				if Entities:GetLocalPlayer():Attribute_GetIntValue("flashlight_on", 0) == 0 then
					SendToConsole("inv_flashlight")
				end
			end
		end
	end
	
	return 0.2
end