require "libs.helper-functions"


if not figui then figui = {} end

function figui.mod_init()
	if not settings.global["food-industry-calculate"].value then
		local leftGui = player.gui.left
		if not leftGui.frame then
			leftGui.frame.destroy()
		end
		return
	end

    --if not global.settings then global.settings = {} end
    --if not global.settings.update_delay then global.settings.update_delay = 60 end
	for index,player in pairs(game.players) do
		if player.connected then
			fi_global_variables_init()
			figui.create(index, player)
		end
	end
	writeDebug("Init ...OK")
	return
	--for index, player in pairs(game.players) do
	--	if player.valid and player.connected then
	--		-- remove old GUI types
	--		local leftGui = player.gui.left
	--		if leftGui.frame.energylabel then  -- destroy all old frame GUI
	--			leftGui.frame.destroy()
	--			player.print("figui: old frame of GUI destroed!")
	--		end
	--	end
		
        --evogui.create_player_globals(player)
        --evogui.create_sensor_display(player)
	--end
end

--/c game.player.print(game.player.gui.left.frame.energylabel.name)


-- creation or recreation FI GUI
function figui.create(index, player)
	local leftGui = player.gui.left
	if not settings.global["food-industry-calculate"].value then
		if not leftGui.frame then
			leftGui.frame.destroy()
		end
		return
	end

	
	if leftGui.bar then
		leftGui.bar.destroy()
	end


	-- initialize main .frame
	if not leftGui.frame then
		leftGui.add{type = "frame", name = "frame", direction = "vertical"}
	end

	-- initialize .flow0
	if not leftGui.frame.flow0 then
		leftGui.frame.add{type = "flow", name = "flow0", right_padding = 0, left_padding = 0, width=16, height=16, direction = "horizontal"}
	end
	if not leftGui.frame.flow0.sprite_fi_logo then
		--leftGui.frame.flow0.add{type="sprite", name="sprite_fi_logo", SpritePath="__FoodIndustry__/graphics/icons/fi-icon-x16.png", width=16, height=16, scaleable=false, align="right",}
		leftGui.frame.flow0.add{type="sprite", name="sprite_fi_logo", SpritePath="item/fi-logo-x32", width=16, height=16, scaleable=false, align="right",}
	end
	
	-- initialize labels and bars of .flow1
	if not leftGui.frame.flow1 then
		leftGui.frame.add{type = "flow", name = "flow1", right_padding = 0, left_padding = 0, direction = "horizontal"}
	end
	if not leftGui.frame.flow1.energylabel then
		--leftGui.frame.flow1.add({type="sprite", name="sprite_fi_logo", SpritePath="__FoodIndustry__/graphics/icons/fi-icon-x32.png", width=32, height=32, scaleable=false, align="right",})
		-- "Energy: " .. energylabel .. " (usage: ".. usagelabel .."%)"
		leftGui.frame.flow1.add({type="label", name="label_energy", caption={'label.label-energy', ": "}, style = "fi-label", align="right",})
		--leftGui.frame.flow1.add({type="label", name="label_energy1", caption=": ", style = "fi-label", align="left",})
		leftGui.frame.flow1.add({type="label", name="energylabel", caption="", tooltip = {'label.label-energylabel-tooltip', global.energy_max[index]}, style = "fi-label"})
		--leftGui.frame.flow1.energylabel.tooltip = {'label.label-energylabel-tooltip', global.energy_max[index]}
		--leftGui.frame.flow1.add({type="label", name="label_usage1", caption=" (", left_padding=0, right_padding=0,})
		leftGui.frame.flow1.add({type="label", name="label_usage", caption={'label.label-usage', " (", ": "}, style = "fi-label",})
		--leftGui.frame.flow1.add({type="label", name="label_usage2", caption=": ", left_padding=0, right_padding=0,})
		--leftGui.frame.flow1.add({type="label", name="usagelabel", caption={"", 'label.label-percent', ")"}, left_padding=0, right_padding=0,})
		leftGui.frame.flow1.add({type="label", name="usagelabel", caption="", style = "fi-label",})
		--leftGui.frame.flow1.add({type="label", name="label_percent", caption={'label.label-percent', "%)"}, style = "fi-label",})
		leftGui.frame.flow1.add({type="label", name="label_percent", caption="%)", style = "fi-label",})
		--leftGui.frame.flow1.add({type="label", name="label_percent1", caption=")", left_padding=0, right_padding=0,})
		-- TODO make fat icon
		--if not leftGui.frame.flow12 then
		--	leftGui.frame.add{type = "flow", name = "flow12", right_padding = 0, left_padding = 0, direction = "horizontal"}
		--end
		--if not leftGui.frame.flow1.flow12.label_fat then
		--	leftGui.frame.flow1.flow12.add({type="sprite", name="sprite_fat", sprite=)
		--	leftGui.frame.flow1.flow12.add({type="label", name="label_fat", caption="")
		--end
	end
	if not leftGui.frame.energybar then
		leftGui.frame.add({type="progressbar", name="energybar"})
		leftGui.frame.energybar.style.width = 200
	end	


	-- initialize labels and bars of .flow22 - drinks
	if not leftGui.frame.flow22 then
		leftGui.frame.add{type = "flow", name = "flow22", direction = "horizontal"}
	end
	if not leftGui.frame.flow22.drinkslabel then
		-- "Drinks: " .. drinklabel .. " (usage: ".. usagelabel .."%)"
		leftGui.frame.flow22.add({type="label", name="label_drinks", caption={'label.label-drinks', ": "}, style = "fi-label", align="right",})
		leftGui.frame.flow22.add({type="label", name="drinkslabel", caption="", tooltip = {'label.label-drinkslabel-tooltip', global.drinks_max[index]}, style = "fi-label"})
		--leftGui.frame.flow22.add({type="label", name="thirstlabel", caption="")
		leftGui.frame.add({type="progressbar", name="drinksbar"})
		leftGui.frame.drinksbar.style.width = 200
		leftGui.frame.drinksbar.style.color = {r=0.2, g=0.2, b=1, a=1}
	end	

	-- DEBUG check this
	if player.connected and player.character then -- if not sandbox mode
		-- initialize labels and bars of .flow2
		if not leftGui.frame.flow2 then
			leftGui.frame.add{type = "flow", name = "flow2", direction = "horizontal"}
		end
		if not leftGui.frame.flow2.fullnesslabel then
			--"Fullness: " .. fullnessbar .."%"
			leftGui.frame.flow2.add({type="label", name="label_fullness", caption={'label.label-fullness', ": "},})
			--leftGui.frame.flow2.add({type="label", name="label_fullness1", caption=": ",})
			leftGui.frame.flow2.add({type="label", name="fullnesslabel", caption=""})
			--leftGui.frame.flow2.add({type="label", name="label_percent", caption={'label.label-percent'},})
			leftGui.frame.flow2.add({type="label", name="label_percent", caption="%",})
		end	
		if not leftGui.frame.fullnessbar then
			leftGui.frame.add({type="progressbar", name="fullnessbar"})
			leftGui.frame.fullnessbar.style.width = 200
			leftGui.frame.fullnessbar.style.color = {r = 1, g = 0.6, a = 1}
		end
		
		-- .flow 3,4,5 rezerved for "Balance of Substances"
		if not leftGui.frame.flow3 then
			leftGui.frame.add{type = "flow", name = "flow3", direction = "horizontal"}
		end
		if not leftGui.frame.flow3.flow33 then
			leftGui.frame.flow3.add{type="flow", name="flow33", direction="vertical"}
			--leftGui.frame.flow3.flow33.style.left_padding=10
			leftGui.frame.flow3.flow33.add({type="label", name="label_substances", caption={'label.label-substances', ": "}, tooltip={'label.label-substances-tooltip',"-10","100"}})
		end
		
		if not leftGui.frame.flow3.flow33.flow331 then
			leftGui.frame.flow3.flow33.add{type="flow", name="flow331", tooltip={'label.label-substancesbar_v-tooltip'}, style="fi-substances-flow"}
			if not leftGui.frame.flow3.flow33.flow331.substancesbar_v then
				--leftGui.frame.flow3.flow33.flow331.add({type="label", name="label_substancesbar_v", caption={'label.label-substancesbar_v'},})
				leftGui.frame.flow3.flow33.flow331.add({type="progressbar", name="substancesbar_v", style="fi-substances-bar"})
				leftGui.frame.flow3.flow33.flow331.substancesbar_v.style.color = {r=0.388235294, g=1, b=0.317647059, a=1}
				leftGui.frame.flow3.flow33.flow331.add({type="label", name="label_substancesbar_v", caption="0", tooltip={'label.label-substancesbar_v-tooltip'}, style="fi-label-mini"})
				leftGui.frame.flow3.flow33.flow331.label_substancesbar_v.style.font_color = {r=0.388235294, g=1, b=0.317647059, a=1}
			end
		end
		if not leftGui.frame.flow3.flow33.flow332 then
			leftGui.frame.flow3.flow33.add{type = "flow", name = "flow332", tooltip={'label.label-substancesbar_m-tooltip'}, style="fi-substances-flow"}
			if not leftGui.frame.flow3.flow33.flow332.substancesbar_m then
				--leftGui.frame.flow3.flow33.flow332.add({type="label", name="label_substancesbar_m", caption={'label.label-substancesbar_m'},})
				leftGui.frame.flow3.flow33.flow332.add({type="progressbar", name="substancesbar_m", style="fi-substances-bar"})
				leftGui.frame.flow3.flow33.flow332.substancesbar_m.style.color = {r=1, g=0.996078431, b=0.047058824, a=1}
				leftGui.frame.flow3.flow33.flow332.add({type="label", name="label_substancesbar_m", caption="0", tooltip={'label.label-substancesbar_m-tooltip'}, style="fi-label-mini"})
				leftGui.frame.flow3.flow33.flow332.label_substancesbar_m.style.font_color = {r=1, g=0.996078431, b=0.047058824, a=1}
			end
		end
		if not leftGui.frame.flow3.flow33.flow333 then
			leftGui.frame.flow3.flow33.add{type = "flow", name = "flow333", tooltip={'label.label-substancesbar_c-tooltip'}, style="fi-substances-flow"}
			if not leftGui.frame.flow3.flow33.flow333.substancesbar_c then
				--leftGui.frame.flow3.flow33.flow333.add({type="label", name="label_substancesbar_c", caption={'label.label-substancesbar_c'},})
				leftGui.frame.flow3.flow33.flow333.add({type="progressbar", name="substancesbar_c", style="fi-substances-bar"})
				leftGui.frame.flow3.flow33.flow333.substancesbar_c.style.color = {r=1, g=0.552941176, b=0.937254902, a=1}
				leftGui.frame.flow3.flow33.flow333.add({type="label", name="label_substancesbar_c", caption="0", tooltip={'label.label-substancesbar_c-tooltip'}, style="fi-label-mini"})
				leftGui.frame.flow3.flow33.flow333.label_substancesbar_c.style.font_color = {r=1, g=0.552941176, b=0.937254902, a=1}
			end
		end
		if not leftGui.frame.flow3.flow33.flow334 then
			leftGui.frame.flow3.flow33.add{type = "flow", name = "flow334", tooltip={'label.label-substancesbar_f-tooltip'}, style="fi-substances-flow"}
			if not leftGui.frame.flow3.flow33.flow334.substancesbar_f then
				--leftGui.frame.flow3.flow33.flow334.add({type="label", name="label_substancesbar_f", caption={'label.label-substancesbar_f'},})
				leftGui.frame.flow3.flow33.flow334.add({type="progressbar", name="substancesbar_f", style="fi-substances-bar"})
				leftGui.frame.flow3.flow33.flow334.substancesbar_f.style.color = {r=0.301960784, g=0.882352941, b=0.984313725, a=1}
				leftGui.frame.flow3.flow33.flow334.add({type="label", name="label_substancesbar_f", caption="0", tooltip={'label.label-substancesbar_f-tooltip'}, style="fi-label-mini"})
				leftGui.frame.flow3.flow33.flow334.label_substancesbar_f.style.font_color = {r=0.301960784, g=0.882352941, b=0.984313725, a=1}
			end
		end

		-- Effects display
		if not leftGui.frame.flow3.flow34 then
			leftGui.frame.flow3.add{type="flow", name="flow34", direction="vertical"}
		end
		if not leftGui.frame.flow3.flow34.flow341 then
			leftGui.frame.flow3.flow34.add{type="flow", name="flow341", direction="horizontal"}
			leftGui.frame.flow3.flow34.flow341.style.maximal_width=80
			leftGui.frame.flow3.flow34.flow341.add({type="label", name="label_effects", caption={'label.label-effects', ": "},})
			leftGui.frame.flow3.flow34.flow341.add({type="label", name="label_effects_count", caption="0",})
		end
		-- TODO Add Effects icons function
		if not leftGui.frame.flow3.flow34.flow342 then
			leftGui.frame.flow3.flow34.add{type="flow", name="flow342", direction="horizontal"}
			leftGui.frame.flow3.flow34.flow342.style.maximal_width=80
		end
		
		-- initialize labels and bars of .flow6
		if not leftGui.frame.flow6 then
			leftGui.frame.add{ type = "flow", name = "flow6", direction = "horizontal", width = 200, align = "right"}
		end
		-- TODO "eat-button-ongui" by Oceanel
		if player.force.technologies["fi-tech-eatout-button"] and player.force.technologies["fi-tech-eatout-button"].researched then
			if not leftGui.frame.flow6.eat_button then
				leftGui.frame.flow6.add{
				type = "button",
				name = "eat_button",
				caption = {'button.eatout'},
				tooltip = {'button.eatout-tooltip'},
				align = "right",
				vertical_align = "bottom",
				--horizontally_stretchable = true,
				--key_sequence = "SHIFT + E",
				height = 20,
				width = 25}
			end
			else
			leftGui.frame.flow6.destroy()
		end
	end

end


-- Update GUI gadgets: Energy, Drinks, Fullness
function figui.update(index, player)
	local leftGui = player.gui.left
	
	if leftGui == nil or leftGui.frame == nil then
		return
	end
	
	
	if leftGui.frame.flow1.energylabel then
		if pcall(function () leftGui.frame.flow1.usagelabel.caption = (math.floor((100 * settings.global["food-industry-hunger-speed"].value * global.usage[index] / global.update_delay[index]) * (1 + global.fi_energy_ussage_modifier[index]) + 0.5) * 0.01) end) then
			-- "Energy: " ... " (usage: "..."%)"
			leftGui.frame.flow1.energylabel.caption = math.floor(global.energy[index])
			leftGui.frame.flow1.usagelabel.caption = (math.floor((100 * settings.global["food-industry-hunger-speed"].value * global.usage[index] / global.update_delay[index]) * (1 + global.fi_energy_ussage_modifier[index]) + 0.5) * 0.01)
		else
			--  "Energy: " ... " (usage: ---%)"
			leftGui.frame.flow1.energylabel.caption = global.energy[index]
			leftGui.frame.flow1.usagelabel.caption = "---"
		end
		leftGui.frame.energybar.value = math.abs(global.energy[index]/global.energy_max[index])
		if global.energy[index] >= global.energy_max[index] * 0.91 then -- >=91%
			leftGui.frame.energybar.style.color = {g = 0.8, b=1, a = 1}
		elseif global.energy[index] >= global.energy_max[index] * 0.30 then -- >=30%
			leftGui.frame.energybar.style.color = {g = 1, a = 1}
		elseif global.energy[index] >= global.energy_max[index] * 0.20 then -- >=20%
			leftGui.frame.energybar.style.color = {r = 1, g = 1, a = 1}
		elseif global.energy[index] >= 0 then
			leftGui.frame.energybar.style.color = {r = 1, g = 0.6, a = 1}
		else 
			leftGui.frame.energybar.style.color = {r = 1, a = 1}
		end
	end

	
	if leftGui.frame.flow22.drinkslabel then
		if global.drinks[index] > 0 then
			leftGui.frame.flow22.drinkslabel.caption = math.floor(global.drinks[index])
			leftGui.frame.flow22.drinkslabel.style.font_color = {r=1, g=1, b=1, a=1}
			leftGui.frame.drinksbar.value = math.abs(global.drinks[index]/global.drinks_max[index])
			if global.drinks[index] >= global.drinks_max[index] * 0.91 then -- >=91%
				leftGui.frame.drinksbar.style.color = {r=0.227450980, g=0, b=0.745098039, a=1}
			elseif global.drinks[index] >= global.drinks_max[index] * 0.5 then -- >=50%
				leftGui.frame.drinksbar.style.color = {r=0.2, g=0.2, b=1, a=1}
			elseif global.drinks[index] >= global.drinks_max[index] * 0.4 then -- >=40%
				leftGui.frame.drinksbar.style.color = {r=0.2, g=0.2, b=1, a=0.9}
			elseif global.drinks[index] >= global.drinks_max[index] * 0.3 then -- >=30%
				leftGui.frame.drinksbar.style.color = {r=0.2, g=0.2, b=1, a=0.8}
			elseif global.drinks[index] >= global.drinks_max[index] * 0.2 then -- >=20%
				leftGui.frame.drinksbar.style.color = {r=0.2, g=0.2, b=1, a=0.7}
			elseif global.drinks[index] >= global.drinks_max[index] * 0.1 then -- >=10%
				leftGui.frame.drinksbar.style.color = {r=0.2, g=0.2, b=1, a=0.6}
			elseif global.drinks[index] >= 0 then
				leftGui.frame.drinksbar.style.color = {r=0.2, g=0.2, b=1, a=0.5}
			end
		else
			-- TODO add thirst viewing
			if global.effects[index]["thirst"][1] and global.effects[index]["thirst"][2] == 1 then -- thirst preparation
				leftGui.frame.flow22.drinkslabel.caption = {'label.label-predisposition-to-thirst', math.floor(global.drinks[index])}
				leftGui.frame.flow22.drinkslabel.style.font_color = {r=1, g=89/255, b=136/255, a=190/255}
				leftGui.frame.drinksbar.value = global.effects[index]["thirst"][3]/21600
				leftGui.frame.drinksbar.style.color = {r=0.5, g=0.5, b=0.5, a = 0.6}
			elseif global.effects[index]["thirst"][1] and global.effects[index]["thirst"][2] == 2 then
				leftGui.frame.flow22.drinkslabel.caption = {'label.label-thirst', math.floor(global.drinks[index]), math.ceil(math.abs(global.effects[index]["thirst"][3])/108000*100)}
				leftGui.frame.flow22.drinkslabel.style.font_color = {r=1, g=140/255, b=140/255, a=1}
				leftGui.frame.drinksbar.value = math.abs(global.effects[index]["thirst"][3])/108000
				leftGui.frame.drinksbar.style.color = {r = 1, a = 1}
			else
				leftGui.frame.flow22.drinkslabel.caption = 0
				leftGui.frame.flow22.drinkslabel.style.font_color = {r=1, g=1, b=1, a=1}
			end
		end
	end


	if leftGui.frame.flow2.fullnesslabel then
		--player.print("[Debug] fullness: "..global.fullness[index])
		-- here Overeating
		local fullness_storage = global.fullness[index]
		if global.fullness[index] > 100 then
			--writeDebug("fullnesslabel "..global.fullness[index])
			--leftGui.frame.flow2.label_fullness.caption = ({'label.label-overeating', ": "})
			leftGui.frame.flow2.fullnesslabel.caption = {'label.label-overeating', math.ceil(global.fullness[index]), "%", math.ceil(global.effects[index]["overeating"][4])}
			leftGui.frame.flow2.fullnesslabel.style.font_color = {r=1, g=38/255, b=45/255, a=1}
			leftGui.frame.flow2.label_percent.style.font_color = {r=1, g=38/255, b=45/255, a=1}
			leftGui.frame.fullnessbar.value = (global.fullness[index] - 100)/100
			leftGui.frame.fullnessbar.style.color = {r=1, a=1}
		-- here normal Fullness
		elseif global.fullness[index] <= 100 then
			if global.effects[index]["overeating"][4] > 0 then
				leftGui.frame.flow2.fullnesslabel.caption = {'label.label-overeating', math.ceil(global.fullness[index]), "%", math.ceil(global.effects[index]["overeating"][4])}
				leftGui.frame.flow2.fullnesslabel.style.font_color = {r=255/255, g=76/255, b=82/255, a=1}
				leftGui.frame.flow2.label_percent.style.font_color = {r=255/255, g=76/255, b=82/255, a=1}
			else
				leftGui.frame.flow2.fullnesslabel.caption = math.ceil(math.abs(global.fullness[index]))
				leftGui.frame.flow2.fullnesslabel.style.font_color = {r=1, g=1, b=1, a=1}
				leftGui.frame.flow2.label_percent.style.font_color = {r=1, g=1, b=1, a=1}
			end
			leftGui.frame.fullnessbar.value = global.fullness[index]/100
			leftGui.frame.fullnessbar.style.color = {r=1, g=0.6, a=1}
			if global.fullness[index] < 20 then
				--writeDebug("fullness "..global.fullness[index].." < 20")
				leftGui.frame.fullnessbar.style.color = {r=127/255, g=76/255, a=1}
			elseif global.fullness[index] < 40 then
				leftGui.frame.fullnessbar.style.color = {r=153/255, g=91/255, a=1}
			elseif global.fullness[index] < 60 then
				leftGui.frame.fullnessbar.style.color = {r=188/255, g=113/255, a=1}
			elseif global.fullness[index] < 80 then
				leftGui.frame.fullnessbar.style.color = {r=229/255, g=137/255, a=1}
			end
		--else
		--	game.players[index].print("[Debug] Warning: Fullness "..fullness_storage.." - is not good!")
		--	return
		end
	end
	
end


-- Update GUI gadgets: balances of Substances
function figui.update_substances(index, player)
	local leftGui = player.gui.left
	
	if leftGui == nil then
		return
	end
	
	-- if substances > 0 then a=0.7
	-- if substances < 0 then make bar darker
	-- else (include substances = 0) then make font grayer
	if leftGui.frame.flow3.flow33.flow331.substancesbar_v then
		leftGui.frame.flow3.flow33.flow331.substancesbar_v.value = math.abs(global.substances[index]["v"]/100)
		leftGui.frame.flow3.flow33.flow331.label_substancesbar_v.caption = math.floor(global.substances[index]["v"])
		if global.substances[index]["v"] > 60 then
			leftGui.frame.flow3.flow33.flow331.substancesbar_v.style.color = {r=0.388235294, g=1, b=0.317647059, a=1}
		elseif global.substances[index]["v"] > 40 then
			leftGui.frame.flow3.flow33.flow331.substancesbar_v.style.color = {r=0.388235294, g=1, b=0.317647059, a=0.9}
		elseif global.substances[index]["v"] > 20 then
			leftGui.frame.flow3.flow33.flow331.substancesbar_v.style.color = {r=0.388235294, g=1, b=0.317647059, a=0.8}
		elseif global.substances[index]["v"] > 0 then
			leftGui.frame.flow3.flow33.flow331.substancesbar_v.style.color = {r=0.388235294, g=1, b=0.317647059, a=0.7}
			leftGui.frame.flow3.flow33.flow331.label_substancesbar_v.style.font_color = {r=0.388235294, g=1, b=0.317647059, a=1}
		elseif global.substances[index]["v"] < 0 then
			leftGui.frame.flow3.flow33.flow331.substancesbar_v.value = math.abs(global.substances[index]["v"]/100*10)
			leftGui.frame.flow3.flow33.flow331.substancesbar_v.style.color = {r=0.388235294, g=0.549019608, b=0.317647059, a=0.9} -- darker bar
			leftGui.frame.flow3.flow33.flow331.label_substancesbar_v.caption = math.ceil(global.substances[index]["v"])
			leftGui.frame.flow3.flow33.flow331.label_substancesbar_v.style.font_color = {r=1.0, g=0.17, b=0, a=1}
		else
			leftGui.frame.flow3.flow33.flow331.substancesbar_v.style.color = {r=0.388235294, g=1, b=0.317647059, a=1}
			leftGui.frame.flow3.flow33.flow331.label_substancesbar_v.style.font_color = {r=0.152941176, g=0.388235294, b=0.121568627, a=1} -- grey font
		end
	end

	if leftGui.frame.flow3.flow33.flow332.substancesbar_m then
		leftGui.frame.flow3.flow33.flow332.substancesbar_m.value = math.abs(global.substances[index]["m"]/100)
		leftGui.frame.flow3.flow33.flow332.label_substancesbar_m.caption = math.floor(global.substances[index]["m"])
		if global.substances[index]["m"] > 60 then
			leftGui.frame.flow3.flow33.flow332.substancesbar_m.style.color = {r=1, g=0.996078431, b=0.047058824, a=1}
		elseif global.substances[index]["m"] > 40 then
			leftGui.frame.flow3.flow33.flow332.substancesbar_m.style.color = {r=1, g=0.996078431, b=0.047058824, a=0.9}
		elseif global.substances[index]["m"] > 20 then
			leftGui.frame.flow3.flow33.flow332.substancesbar_m.style.color = {r=1, g=0.996078431, b=0.047058824, a=0.8}
		elseif global.substances[index]["m"] > 0 then
			leftGui.frame.flow3.flow33.flow332.substancesbar_m.style.color = {r=1, g=0.996078431, b=0.047058824, a=0.7}
			leftGui.frame.flow3.flow33.flow332.label_substancesbar_m.style.font_color = {r=1, g=0.996078431, b=0.047058824, a=1}
		elseif global.substances[index]["m"] < 0 then
			leftGui.frame.flow3.flow33.flow332.substancesbar_m.value = math.abs(global.substances[index]["m"]/100*10)
			leftGui.frame.flow3.flow33.flow332.substancesbar_m.style.color = {r=1, g=0.470588235, b=0.047058824, a=0.9} -- darker bar
			leftGui.frame.flow3.flow33.flow332.label_substancesbar_m.caption = math.ceil(global.substances[index]["m"])
			leftGui.frame.flow3.flow33.flow332.label_substancesbar_m.style.font_color = {r=1.0, g=0.17, b=0, a=1}
		else
			leftGui.frame.flow3.flow33.flow332.substancesbar_m.style.color = {r=1, g=0.996078431, b=0.047058824, a=1}
			leftGui.frame.flow3.flow33.flow332.label_substancesbar_m.style.font_color = {r=0.447058824, g=0.439215686, b=0.019607843, a=1} -- grey font
		end
	end

	if leftGui.frame.flow3.flow33.flow333.substancesbar_c then
		leftGui.frame.flow3.flow33.flow333.substancesbar_c.value = math.abs(global.substances[index]["c"]/100)
		leftGui.frame.flow3.flow33.flow333.label_substancesbar_c.caption = math.floor(global.substances[index]["c"])
		if global.substances[index]["c"] > 60 then
			leftGui.frame.flow3.flow33.flow333.substancesbar_c.style.color = {r=1, g=0.552941176, b=0.937254902, a=1}
		elseif global.substances[index]["c"] > 40 then
			leftGui.frame.flow3.flow33.flow333.substancesbar_c.style.color = {r=1, g=0.552941176, b=0.937254902, a=0.9}
		elseif global.substances[index]["c"] > 20 then
			leftGui.frame.flow3.flow33.flow333.substancesbar_c.style.color = {r=1, g=0.552941176, b=0.937254902, a=0.8}
		elseif global.substances[index]["c"] > 0 then
			leftGui.frame.flow3.flow33.flow333.substancesbar_c.style.color = {r=1, g=0.552941176, b=0.937254902, a=0.7}
			leftGui.frame.flow3.flow33.flow333.label_substancesbar_c.style.font_color = {r=1, g=0.552941176, b=0.937254902, a=1}
		elseif global.substances[index]["c"] < 0 then
			leftGui.frame.flow3.flow33.flow333.substancesbar_c.value = math.abs(global.substances[index]["c"]/100*10)
			leftGui.frame.flow3.flow33.flow333.substancesbar_c.style.color = {r=0.760784314, g=0.607843137, b=0.937254902, a=0.9} -- darker bar
			leftGui.frame.flow3.flow33.flow333.label_substancesbar_c.caption = math.ceil(global.substances[index]["c"])
			leftGui.frame.flow3.flow33.flow333.label_substancesbar_c.style.font_color = {r=1.0, g=0.17, b=0, a=1}
		else
			leftGui.frame.flow3.flow33.flow333.substancesbar_c.style.color = {r=1, g=0.552941176, b=0.937254902, a=1}
			leftGui.frame.flow3.flow33.flow333.label_substancesbar_c.style.font_color = {r=0.509803922, g=0.290196078, b=0.478431373, a=1} -- grey font
		end
	end
	
	if leftGui.frame.flow3.flow33.flow334.substancesbar_f then
		leftGui.frame.flow3.flow33.flow334.substancesbar_f.value = math.abs(global.substances[index]["f"]/100)
		leftGui.frame.flow3.flow33.flow334.label_substancesbar_f.caption = math.floor(global.substances[index]["f"])
		if global.substances[index]["f"] > 60 then
			leftGui.frame.flow3.flow33.flow334.substancesbar_f.style.color = {r=0.301960784, g=0.882352941, b=0.984313725, a=1}
		elseif global.substances[index]["f"] > 40 then
			leftGui.frame.flow3.flow33.flow334.substancesbar_f.style.color = {r=0.301960784, g=0.882352941, b=0.984313725, a=0.9}
		elseif global.substances[index]["f"] > 20 then
			leftGui.frame.flow3.flow33.flow334.substancesbar_f.style.color = {r=0.301960784, g=0.882352941, b=0.984313725, a=0.8}
		elseif global.substances[index]["f"] > 0 then
			leftGui.frame.flow3.flow33.flow334.substancesbar_f.style.color = {r=0.301960784, g=0.882352941, b=0.984313725, a=0.7}
			leftGui.frame.flow3.flow33.flow334.label_substancesbar_f.style.font_color = {r=0.301960784, g=0.882352941, b=0.984313725, a=1}
		elseif global.substances[index]["f"] < 0 then
			leftGui.frame.flow3.flow33.flow334.substancesbar_f.value = math.abs(global.substances[index]["f"]/100*10)
			leftGui.frame.flow3.flow33.flow334.substancesbar_f.style.color = {r=0.301960784, g=0.443137255, b=0.984313725, a=0.9} -- darker bar
			leftGui.frame.flow3.flow33.flow334.label_substancesbar_f.caption = math.ceil(global.substances[index]["f"])
			leftGui.frame.flow3.flow33.flow334.label_substancesbar_f.style.font_color = {r=1.0, g=0.17, b=0, a=1}
		else
			leftGui.frame.flow3.flow33.flow334.substancesbar_f.style.color = {r=0.301960784, g=0.882352941, b=0.984313725, a=1}
			leftGui.frame.flow3.flow33.flow334.label_substancesbar_f.style.font_color = {r=0.137254902, g=0.4, b=0.439215686, a=1} -- grey font
		end
	end
	

end


function figui.add_effect_to_gui(index, player, effect_name)
	local leftGui = player.gui.left
	local new_flow = ''
	-- new sub flow of current effect
	if effect_name == "speed" then
		--leftGui.frame.flow3.flow34.flow342.add{type="flow", name="speed", direction="vertical"}
		--leftGui.frame.flow3.flow34.flow342.speed.add({type="sprite", name="unknown_gray", tooltip=""})
		--leftGui.frame.flow3.flow34.flow342.speed.add({type="label", name="label_"..effect_name, caption="--:--", style="fi-substances-bar"})
	end
	if not leftGui.frame.flow3.flow34.flow342.effect_name then
		--leftGui.frame.flow3.flow34.flow342.add{type="flow", name=effect_name, direction="vertical"}

		-- добавить иконку в зависимости от типа эфекта
		--new_flow = 'leftGui.frame.flow3.flow34.flow342.'..effect_name..'.add({type="sprite", name="unknown_gray", tooltip=""})'
		-- добавить время действия эфекта
		--new_flow = 'leftGui.frame.flow3.flow34.flow342.'..effect_name..'.add({type="label", name="label_"..effect_name, caption="--:--", style="fi-substances-bar"})'
	end
	
end
function figui.remove_effect_from_gui(index, player)
end

-- Update GUI gadgets: Effects
function figui.update_effects(index, player)
	local leftGui = player.gui.left
	
	local active_effects_count = 0
	for i,effect in pairs(global.effects[index]) do
		if not effect[5] == nil then
			active_effects_count = active_effects_count + table.maxn(effect[5])
		end
	end
	--leftGui.frame.flow3.flow34.label_effects_count.caption = active_effects_count

	-- TODO Update GUI Effects
	for i,effect in pairs(global.effects[index]) do
		-- if effect is active
		--	if effect[1] then

	end

end


-- --------------- debugging GUI -----------------------
function figui.debug_create(index, player)
	local centerGui = player.gui.top
	if not settings.get_player_settings(player)["food-industry-debug-gui"].value then
		if centerGui.frame then
			centerGui.frame.destroy()
		end
		return
	end

	if centerGui.bar then
		centerGui.bar.destroy()
	end


	-- initialize main .frame
	if not centerGui.frame then
		centerGui.add{type = "frame", name = "frame", direction = "vertical"}
	end

	-- moving speed
	if not centerGui.frame.flow1 then
		centerGui.frame.add{type = "flow", name = "flow1", right_padding = 0, center_padding = 0, direction = "horizontal"}
	end
	if not centerGui.frame.flow1.label1c then
		centerGui.frame.flow1.add({type="label", name="label1", caption="speed:", style = "fi-label", align="right",})
		centerGui.frame.flow1.add({type="label", name="label1c", caption="", style = "fi-label", align="right",})

		centerGui.frame.flow1.add({type="label", name="label2", caption="/", style = "fi-label", align="right",})
		centerGui.frame.flow1.add({type="label", name="label2c", caption="", style = "fi-label", align="right",})
	end
	-- crafting speed
	if not centerGui.frame.flow2 then
		centerGui.frame.add{type = "flow", name = "flow2", right_padding = 0, center_padding = 0, direction = "horizontal"}
	end
	if not centerGui.frame.flow2.label1c then
		centerGui.frame.flow2.add({type="label", name="label1", caption="crafting:", style = "fi-label", align="right",})
		centerGui.frame.flow2.add({type="label", name="label1c", caption="", style = "fi-label", align="right",})
	end
	-- mining speed
	if not centerGui.frame.flow2.label2c then
		centerGui.frame.flow2.add({type="label", name="label2", caption=" mining:", style = "fi-label", align="right",})
		centerGui.frame.flow2.add({type="label", name="label2c", caption="", style = "fi-label", align="right",})
	end
	-- long reach
	if not centerGui.frame.flow3 then
		centerGui.frame.add{type = "flow", name = "flow3", right_padding = 0, center_padding = 0, direction = "horizontal"}
	end
	if not centerGui.frame.flow3.label1c then
		centerGui.frame.flow3.add({type="label", name="label1", caption="build: ", style = "fi-label", align="right",})
		centerGui.frame.flow3.add({type="label", name="label1c", caption="", style = "fi-label", align="right",})
		centerGui.frame.flow3.add({type="label", name="label2", caption="item_drop:", style = "fi-label", align="right",})
		centerGui.frame.flow3.add({type="label", name="label2c", caption="", style = "fi-label", align="right",})
		centerGui.frame.flow3.add({type="label", name="label3", caption="reach:", style = "fi-label", align="right",})
		centerGui.frame.flow3.add({type="label", name="label3c", caption="", style = "fi-label", align="right",})
	end

	if not centerGui.frame.flow4 then
		centerGui.frame.add{type = "flow", name = "flow4", right_padding = 0, center_padding = 0, direction = "horizontal"}
	end
	if not centerGui.frame.flow4.label40 then
		centerGui.frame.flow4.add({type="label", name="label40", caption="Energy: ", style = "fi-label", align="right",})
		centerGui.frame.flow4.label40.style.font_color = {r=255/255, g=155/255, b=33/255, a=1}
		centerGui.frame.flow4.add({type="label", name="label41", caption="", style = "fi-label", align="right",})
		centerGui.frame.flow4.add({type="label", name="label42", caption="Drinks: ", style = "fi-label", align="right",})
		centerGui.frame.flow4.label42.style.font_color = {r=66/255, g=226/255, b=255/255, a=1}
		centerGui.frame.flow4.add({type="label", name="label43", caption="", style = "fi-label", align="right",})
	end

	-- effects table
	if not centerGui.frame.flow5 then
		centerGui.frame.add{type = "flow", name = "flow5", right_padding = 0, center_padding = 0, direction = "horizontal"}
	end
	if not centerGui.frame.flow5.label52 then
		centerGui.frame.flow5.add({type="label", name="label52", caption="global.effects[thirst]: ", style = "fi-label", align="right",})
		centerGui.frame.flow5.add({type="label", name="etable5", caption="", style = "fi-label", align="right",})
	end
	----------------
	if not centerGui.frame.flow6 then
		centerGui.frame.add{type = "flow", name = "flow6", right_padding = 0, center_padding = 0, direction = "horizontal"}
	end
	if not centerGui.frame.flow6.label62 then
		centerGui.frame.flow6.add({type="label", name="label62", caption="global.effects[sleep]: ", style = "fi-label", align="right",})
		centerGui.frame.flow6.add({type="label", name="etable6", caption="", style = "fi-label", align="right",})
	end
	----------------
	if not centerGui.frame.flow7 then
		centerGui.frame.add{type = "flow", name = "flow7", right_padding = 0, center_padding = 0, direction = "horizontal"}
	end
	if not centerGui.frame.flow7.label72 then
		centerGui.frame.flow7.add({type="label", name="label72", caption="global.effects[fat]: ", style = "fi-label", align="left",})
		centerGui.frame.flow7.add({type="label", name="label73", caption="", style = "fi-label", align="right",})
		centerGui.frame.flow7.add({type="label", name="label74", caption="/", style = "fi-label", align="right",})
		centerGui.frame.flow7.add({type="label", name="etable7", caption="", style = "fi-label", align="right",})
	end
	----------------
	if not centerGui.frame.flow8 then
		centerGui.frame.add{type = "flow", name = "flow8", right_padding = 0, center_padding = 0, direction = "horizontal"}
	end
	if not centerGui.frame.flow8.label82 then
		centerGui.frame.flow8.add({type="label", name="label82", caption="global.effects[speed]: ", style = "fi-label", align="right",})
		centerGui.frame.flow8.add({type="label", name="etable8", caption="", style = "fi-label", align="right",})
		centerGui.frame.flow8.add({type="label", name="etable8a", caption="", style = "fi-label", align="right",})
	end
	----------------
	if not centerGui.frame.flow9 then
		centerGui.frame.add{type = "flow", name = "flow9", right_padding = 0, center_padding = 0, direction = "horizontal"}
	end
	if not centerGui.frame.flow9.label92 then
		centerGui.frame.flow9.add({type="label", name="label92", caption="global.effects[overeating]: ", style = "fi-label", align="right",})
		centerGui.frame.flow9.add({type="label", name="etable9", caption="", style = "fi-label", align="right",})
	end

end
function figui.debug_update(index, player)
	local centerGui = player.gui.top
	if not settings.get_player_settings(player)["food-industry-debug-gui"].value then
		return
	end
    if player == nil then
        return
    end

	centerGui.frame.flow1.label1c.caption = player.character_running_speed_modifier
	centerGui.frame.flow1.label2c.caption = player.force.character_running_speed_modifier
	centerGui.frame.flow2.label1c.caption = player.character_crafting_speed_modifier
	centerGui.frame.flow2.label2c.caption = player.character_mining_speed_modifier
	
	centerGui.frame.flow3.label1c.caption = player.character_build_distance_bonus
	centerGui.frame.flow3.label2c.caption = player.character_item_drop_distance_bonus
	centerGui.frame.flow3.label3c.caption = player.character_reach_distance_bonus

	centerGui.frame.flow4.label41.caption = global.energy[index]
	centerGui.frame.flow4.label43.caption = global.drinks[index]
	centerGui.frame.flow5.etable5.caption = dump(global.effects[index]["thirst"])
	centerGui.frame.flow6.etable6.caption = dump(global.effects[index]["sleep"])
	centerGui.frame.flow7.label73.caption = global.fi_character_fat_modifier[index]
	centerGui.frame.flow7.etable7.caption = dump(global.effects[index]["fat"])
	--centerGui.frame.flow8.etable8.caption = dump(global.effects[index]["speed"])
	centerGui.frame.flow8.etable8.caption = tostring(global.effects[index]["speed"][1])..", "..global.effects[index]["speed"][2]..", "..global.effects[index]["speed"][3]..", "..global.effects[index]["speed"][4]
	centerGui.frame.flow8.etable8a.caption = serpent.block(global.effects[index]["speed"][5])
	centerGui.frame.flow9.etable9.caption = dump(global.effects[index]["overeating"])
end
