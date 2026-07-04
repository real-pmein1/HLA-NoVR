DoIncludeScript("bindings.lua", nil)

_G.flashlight_on = "0"
_G.distillery_elev_called = 0
local distillery_elev_called_count = 0

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
                SendToConsole("snd_sos_start_soundevent Instructor.StartLesson")
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
	elseif GetMapName() == "a3_distillery" then
		if ( xpos > 611 and xpos < 667 ) and ( ypos > -934 and ypos < -895 ) then
			if _G.hold_mouth_shown == nil then
				local ent = SpawnEntityFromTableSynchronous("game_text", {["effect"]=2, ["spawnflags"]=1, ["color"]="230 230 230", ["color2"]="0 0 0", ["fadein"]=0, ["fadeout"]=0.15, ["fxtime"]=0.25, ["holdtime"]=5, ["x"]=-1, ["y"]=0.6})
				DoEntFireByInstanceHandle(ent, "SetText", "Hold [" .. COVER_MOUTH .. "] to Cover Mouth", 0, nil, nil)
				DoEntFireByInstanceHandle(ent, "Display", "", 0, nil, nil)
                SendToConsole("snd_sos_start_soundevent Instructor.StartLesson")
				_G.hold_mouth_shown = "1"
			end
		end
	elseif GetMapName() == "a4_c17_zoo" then
		if ( xpos > 5377 and xpos < 5414 ) and ( ypos > -1870 and ypos < -1868 ) and ( zpos > -90 and zpos < -80 ) then
			SendToConsole("setpos_player 1 5395.52 -1920.89 -115")
        elseif ( xpos > 5385 and xpos < 5405 ) and ( ypos > -1898 and ypos < -1888 ) and ( zpos > -90 and zpos < -85 ) then
			SendToConsole("setpos_player 1 5403.25 -1851.70 -115")
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
		elseif string.match(GetMapName(), "a3_hotel_interior_rooftop") then
			if ( xpos > 1855 and xpos < 1934 ) and ( ypos > -2528 and ypos < -2455 ) then
				SendToConsole("disable_flashlight")
				if Entities:FindByName(nil, "player_flashlight") then SendToConsole("ent_remove player_flashlight") end
				_G.flashlight_on = "0"
			end
		elseif string.match(GetMapName(), "a3_distillery") then
			if _G.distillery_elev_called == 1 then
				if distillery_elev_called_count < 260 then
					distillery_elev_called_count = distillery_elev_called_count + 1
				elseif distillery_elev_called_count == 260 then
					if _G.flashlight_on == "0" then
						SendToConsole("inv_flashlight")
						_G.flashlight_on = "1"
					end
					distillery_elev_called_count = 261
				end
			end
			if ( xpos > 150 and xpos < 430 ) and ( ypos > 1080 and ypos < 1500 ) and ( zpos > 250 and zpos < 400 ) then
				if _G.flashlight_on == "0" then
					SendToConsole("inv_flashlight")
					_G.flashlight_on = "1"
				end
			end
		elseif string.match(GetMapName(), "a4_c17_zoo") then
			if ( xpos > 7582 and xpos < 7720 ) and ( ypos > -3810 and ypos < -3380 ) then
				if _G.flashlight_on == "0" then
					SendToConsole("inv_flashlight")
					_G.flashlight_on = "1"
				end
			elseif ( xpos > 7274 and xpos < 7533 ) and ( ypos > -3772 and ypos < -3619 ) then
				SendToConsole("disable_flashlight")
				if Entities:FindByName(nil, "player_flashlight") then SendToConsole("ent_remove player_flashlight") end
				_G.flashlight_on = "0"
			elseif ( xpos > 4940 and xpos < 5033 ) and ( ypos > -1946 and ypos < -1739 ) then
				if _G.flashlight_on == "0" then
					SendToConsole("inv_flashlight")
					_G.flashlight_on = "1"
				end
			elseif ( xpos > 5071 and xpos < 5161 ) and ( ypos > -1843 and ypos < -1714 ) then
				SendToConsole("disable_flashlight")
				if Entities:FindByName(nil, "player_flashlight") then SendToConsole("ent_remove player_flashlight") end
				_G.flashlight_on = "0"
			end
		elseif string.match(GetMapName(), "a4_c17_tanker_yard") then
			if ( xpos > 6015 and xpos < 6073 ) and ( ypos > 3892 and ypos < 4044 ) and ( zpos > 380 and zpos < 430 ) then
				if _G.flashlight_on == "0" then
					SendToConsole("inv_flashlight")
					_G.flashlight_on = "1"
				end
			elseif ( xpos > 6124 and xpos < 6180 ) and ( ypos > 4171 and ypos < 4240 ) then
				SendToConsole("disable_flashlight")
				if Entities:FindByName(nil, "player_flashlight") then SendToConsole("ent_remove player_flashlight") end
				_G.flashlight_on = "0"
			end
		end
	end
	
	return 0.1
end