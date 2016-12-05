-- ===========================================================================
--	ReportScreen
--	All the data
--
-- ===========================================================================
include("CitySupport");
include("Civ6Common");
include("InstanceManager");
include("SupportFunctions");
include("TabSupport");



-- ===========================================================================
--	VARIABLES
-- ===========================================================================
-- Members
local m_tabs; --Add new options tabs to this in Initialize function


-- ===========================================================================
--	Single exit point for display
-- ===========================================================================
function Close()
	UIManager:DequeuePopup(ContextPtr);
	UI.PlaySound("UI_Screen_Close");
end


-- ===========================================================================
--	UI Callback
-- ===========================================================================
function OnCloseButton()
	Close();
end

-- ===========================================================================
--	Single entry point for display
-- ===========================================================================
function Open()
	UIManager:QueuePopup( ContextPtr, PopupPriority.Normal );
	Controls.ScreenAnimIn:SetToBeginning();
	Controls.ScreenAnimIn:Play();
	UI.PlaySound("UI_Screen_Open");


end

-- ===========================================================================
--	LUA Events
--	Opened via the top panel
-- ===========================================================================
function OnTopOpenTQUI()
	Open();
end

-- ===========================================================================
--	LUA Events
--	Closed via the top panel
-- ===========================================================================
function OnTopCloseTQUI()
	Close();	
end




	

-- ===========================================================================
--	UI Callback
-- ===========================================================================
function OnInputHandler( pInputStruct:table )
	local uiMsg :number = pInputStruct:GetMessageType();
	if uiMsg == KeyEvents.KeyUp then 
		local uiKey = pInputStruct:GetKey();
		if uiKey == Keys.VK_ESCAPE then
			if ContextPtr:IsHidden()==false then
				Close();
				return true;
			end
		end		
	end
	return false;
end


-- ===========================================================================
--	UI Event
-- ===========================================================================
function OnInit( isReload:boolean )
	if isReload then		
		if ContextPtr:IsHidden()==false then
			Open();
		end
	end
end


-- ===========================================================================
-- to set Y fullHeight and TODO IGE panel size x is fullWidth y is halfHeight
function Resize()
	local topPanelSizeY:number = 30;

	if m_debugFullHeight then
		x,y = UIManager:GetScreenSizeVal();
		Controls.Main:SetSizeY( y - topPanelSizeY );
		Controls.Main:SetOffsetY( topPanelSizeY * 0.5 );
	end
end
-- ==================================
-- TQUI FUNCTIONS
function PopulateComboBox(control, values, setting_name, tooltip)
  control:ClearEntries();
  local current_value = GameConfiguration.GetValue(setting_name);
  if(current_value == nil) then
  if(GameInfo.TQUI_gossips[setting_name]) then --LY Checks if this setting has a default state defined in the database
    current_value = GameInfo.TQUI_gossips[setting_name].Value; --reads the default value from the database. Set them in Settings.sql
  else current_value = 0;
  end
    GameConfiguration.SetValue(setting_name, current_value); --/LY
  end
  for i, v in ipairs(values) do
    local instance = {};
    control:BuildEntry( "InstanceOne", instance );
    instance.Button:SetVoid1(i);
        instance.Button:LocalizeAndSetText(v[1]);
    if(v[2] == current_value) then
      local button = control:GetButton();
      button:LocalizeAndSetText(v[1]);
    end
  end
  control:CalculateInternals();
  if(setting_name) then
    control:RegisterSelectionCallback(
      function(voidValue1, voidValue2, control)
        local option = values[voidValue1];
        local button = control:GetButton();
        button:LocalizeAndSetText(option[1]);
        GameConfiguration.SetValue(setting_name, option[2]);
        LuaEvents.TQUI_gossipsUpdate();
      end
    );
  end
  if(tooltip ~= nil)then
    control:SetToolTipString(tooltip);
  end
end

--Used to populate checkboxes
function PopulateCheckBox(control, setting_name, tooltip)
  local current_value = GameConfiguration.GetValue(setting_name);
  if(current_value == nil) then
  if(GameInfo.TQUI_gossips[setting_name]) then --LY Checks if this setting has a default state defined in the database
    if(GameInfo.TQUI_gossips[setting_name].Value == 0) then --because 0 is true in Lua
      current_value = false;
    else
      current_value = true;
    end
  else current_value = false;
  end
    GameConfiguration.SetValue(setting_name, current_value); --/LY
  end
    if(current_value == false) then
        control:SetSelected(false);
    else
        control:SetSelected(true);
    end
  control:RegisterCallback(Mouse.eLClick, 
    function()
      local selected = not control:IsSelected();
      control:SetSelected(selected);
      GameConfiguration.SetValue(setting_name, selected);
      LuaEvents.TQUI_gossipsUpdate();
    end
  );
  if(tooltip ~= nil)then
    control:SetToolTipString(tooltip);
  end
end

--Used to switch active panels/tabs in the settings panel
function ShowTab(button, panel)
  -- Unfocus all tabs and hide panels
  for i, v in ipairs(m_tabs) do
    v[2]:SetHide(true);
    v[1]:SetSelected(false);
  end 
  button:SetSelected(true);
  panel:SetHide(false);   
  --Controls.WindowTitle:SetText(Locale.Lookup("LOC_TQUI_NAME") .. ": " .. Locale.ToUpper(button:GetText()));
  --Controls.WindowTitle:SetText("TQUI: " .. Locale.ToUpper(button:GetText()));
end

--Populates the status message panel checkboxes with appropriate strings
function InitializeGossipCheckboxes()
  Controls.LOC_GOSSIP_AGENDA_KUDOSCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_AGENDA_KUDOS", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_AGENDA_WARNINGCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_AGENDA_WARNING", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_ALLIEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_ALLIED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_ANARCHY_BEGINSCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_ANARCHY_BEGINS", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_ARTIFACT_EXTRACTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_ARTIFACT_EXTRACTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_BARBARIAN_INVASION_STARTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_BARBARIAN_INVASION_STARTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_BARBARIAN_RAID_STARTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_BARBARIAN_RAID_STARTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_BEACH_RESORT_CREATEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_BEACH_RESORT_CREATED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_CHANGE_GOVERNMENTCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_CHANGE_GOVERNMENT", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_CITY_BESIEGEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_CITY_BESIEGED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_CITY_LIBERATEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_CITY_LIBERATED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_CITY_RAZEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_CITY_RAZED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_CLEAR_CAMPCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_CLEAR_CAMP", "X", "Y", "Z", "1", "2", "3") .. " (" .. Locale.Lookup("LOC_IMPROVEMENT_BARBARIAN_CAMP_NAME") .. ")");
  Controls.LOC_GOSSIP_CITY_STATE_INFLUENCECheckbox:SetText(Locale.Lookup("LOC_GOSSIP_CITY_STATE_INFLUENCE", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_CONQUER_CITYCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_CONQUER_CITY", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_CONSTRUCT_DISTRICTCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_CONSTRUCT_DISTRICT", "X", "Y", "Z", "1", "2", "3") .. "  (" .. Locale.Lookup("LOC_DISTRICT_NAME") .. ")");
  Controls.LOC_GOSSIP_CREATE_PANTHEONCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_CREATE_PANTHEON", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_CULTURVATE_CIVICCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_CULTURVATE_CIVIC", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_DECLARED_FRIENDSHIPCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_DECLARED_FRIENDSHIP", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_DELEGATIONCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_DELEGATION", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_DENOUNCEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_DENOUNCED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_EMBASSYCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_EMBASSY", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_ERA_CHANGEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_ERA_CHANGED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_FIND_NATURAL_WONDERCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_FIND_NATURAL_WONDER", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_FOUND_CITYCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_FOUND_CITY", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_FOUND_RELIGIONCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_FOUND_RELIGION", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_GREATPERSON_CREATEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_GREATPERSON_CREATED", "X", "Y", "Z", "1", "2", "3") .. " (" .. Locale.Lookup("LOC_GREAT_PEOPLE_TAB_GREAT_PEOPLE") .. ")");
  Controls.LOC_GOSSIP_LAUNCHING_ATTACKCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_LAUNCHING_ATTACK", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_WAR_PREPARATIONCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_WAR_PREPARATION", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_INQUISITION_LAUNCHEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_INQUISITION_LAUNCHED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_LAND_UNIT_LEVELCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_LAND_UNIT_LEVEL", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_MAKE_DOWCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_MAKE_DOW", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_NATIONAL_PARK_CREATEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_NATIONAL_PARK_CREATED", "X", "Y", "Z", "1", "2", "3") .. " (" .. Locale.Lookup("LOC_NATIONAL_PARK_NAME", "") .. " )");
  Controls.LOC_GOSSIP_NEW_RELIGIOUS_MAJORITYCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_NEW_RELIGIOUS_MAJORITY", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_PILLAGECheckbox:SetText(Locale.Lookup("LOC_GOSSIP_PILLAGE", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_POLICY_ENACTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_POLICY_ENACTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_RECEIVE_DOWCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_RECEIVE_DOW", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_RELIC_RECEIVEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_RELIC_RECEIVED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_RESEARCH_AGREEMENTCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_RESEARCH_AGREEMENT", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_RESEARCH_TECHCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_RESEARCH_TECH", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_DETECTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_DETECTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_UNDETECTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_UNDETECTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_SPY_GREAT_WORK_HEIST_DETECTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_SPY_GREAT_WORK_HEIST_DETECTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_SPY_GREAT_WORK_HEIST_UNDETECTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_SPY_GREAT_WORK_HEIST_UNDETECTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_SPY_RECRUIT_PARTISANS_DETECTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_SPY_RECRUIT_PARTISANS_DETECTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_SPY_RECRUIT_PARTISANS_UNDETECTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_SPY_RECRUIT_PARTISANS_UNDETECTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_DETECTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_DETECTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_UNDETECTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_UNDETECTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_SPY_SIPHON_FUNDS_DETECTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_SPY_SIPHON_FUNDS_DETECTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_SPY_SIPHON_FUNDS_UNDETECTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_SPY_SIPHON_FUNDS_UNDETECTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_SPY_STEAL_TECH_BOOST_DETECTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_SPY_STEAL_TECH_BOOST_DETECTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_SPY_STEAL_TECH_BOOST_UNDETECTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_SPY_STEAL_TECH_BOOST_UNDETECTED", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_TRADE_DEALCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_TRADE_DEAL", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_TRADE_RENEGECheckbox:SetText(Locale.Lookup("LOC_GOSSIP_TRADE_RENEGE", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_TRAIN_SETTLERCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_TRAIN_SETTLER", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_TRAIN_UNITCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_TRAIN_UNIT", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_TRAIN_UNIQUE_UNITCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_TRAIN_UNIQUE_UNIT", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_PROJECT_STARTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_PROJECT_STARTED", "X", "Y", "Z", "1", "2", "3") .. " (" .. Locale.Lookup("LOC_PROJECT_NAME") .. ")");
  Controls.LOC_GOSSIP_START_VICTORY_STRATEGYCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_START_VICTORY_STRATEGY", "X", "Y", "Z", "1", "2", "3") .. " (" .. Locale.Lookup("LOC_VICTORY_DEFAULT_NAME") .. ")");
  Controls.LOC_GOSSIP_STOP_VICTORY_STRATEGYCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_STOP_VICTORY_STRATEGY", "X", "Y", "Z", "1", "2", "3") .. " (" .. Locale.Lookup("LOC_VICTORY_DEFAULT_NAME") .. ")");
  Controls.LOC_GOSSIP_WMD_BUILTCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_WMD_BUILT", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_WMD_STRIKECheckbox:SetText(Locale.Lookup("LOC_GOSSIP_WMD_STRIKE", "X", "Y", "Z", "1", "2", "3"));
  Controls.LOC_GOSSIP_WONDER_STARTEDCheckbox:SetText(Locale.Lookup("LOC_GOSSIP_WONDER_STARTED", "X", "Y", "Z", "1", "2", "3") .. " (" .. Locale.Lookup("LOC_WONDER_NAME") .. ")");

  PopulateCheckBox(Controls.LOC_GOSSIP_AGENDA_KUDOSCheckbox, "TQUI_LOC_GOSSIP_AGENDA_KUDOS");
  PopulateCheckBox(Controls.LOC_GOSSIP_AGENDA_WARNINGCheckbox, "TQUI_LOC_GOSSIP_AGENDA_WARNING");
  PopulateCheckBox(Controls.LOC_GOSSIP_ALLIEDCheckbox, "TQUI_LOC_GOSSIP_ALLIED");
  PopulateCheckBox(Controls.LOC_GOSSIP_ANARCHY_BEGINSCheckbox, "TQUI_LOC_GOSSIP_ANARCHY_BEGINS");
  PopulateCheckBox(Controls.LOC_GOSSIP_ARTIFACT_EXTRACTEDCheckbox, "TQUI_LOC_GOSSIP_ARTIFACT_EXTRACTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_BARBARIAN_INVASION_STARTEDCheckbox, "TQUI_LOC_GOSSIP_BARBARIAN_INVASION_STARTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_BARBARIAN_RAID_STARTEDCheckbox, "TQUI_LOC_GOSSIP_BARBARIAN_RAID_STARTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_BEACH_RESORT_CREATEDCheckbox, "TQUI_LOC_GOSSIP_BEACH_RESORT_CREATED");
  PopulateCheckBox(Controls.LOC_GOSSIP_CHANGE_GOVERNMENTCheckbox, "TQUI_LOC_GOSSIP_CHANGE_GOVERNMENT");
  PopulateCheckBox(Controls.LOC_GOSSIP_CITY_BESIEGEDCheckbox, "TQUI_LOC_GOSSIP_CITY_BESIEGED");
  PopulateCheckBox(Controls.LOC_GOSSIP_CITY_LIBERATEDCheckbox, "TQUI_LOC_GOSSIP_CITY_LIBERATED");
  PopulateCheckBox(Controls.LOC_GOSSIP_CITY_RAZEDCheckbox, "TQUI_LOC_GOSSIP_CITY_RAZED");
  PopulateCheckBox(Controls.LOC_GOSSIP_CLEAR_CAMPCheckbox, "TQUI_LOC_GOSSIP_CLEAR_CAMP");
  PopulateCheckBox(Controls.LOC_GOSSIP_CITY_STATE_INFLUENCECheckbox, "TQUI_LOC_GOSSIP_CITY_STATE_INFLUENCE");
  PopulateCheckBox(Controls.LOC_GOSSIP_CONQUER_CITYCheckbox, "TQUI_LOC_GOSSIP_CONQUER_CITY");
  PopulateCheckBox(Controls.LOC_GOSSIP_CONSTRUCT_DISTRICTCheckbox, "TQUI_LOC_GOSSIP_CONSTRUCT_DISTRICT");
  PopulateCheckBox(Controls.LOC_GOSSIP_CREATE_PANTHEONCheckbox, "TQUI_LOC_GOSSIP_CREATE_PANTHEON");
  PopulateCheckBox(Controls.LOC_GOSSIP_CULTURVATE_CIVICCheckbox, "TQUI_LOC_GOSSIP_CULTURVATE_CIVIC");
  PopulateCheckBox(Controls.LOC_GOSSIP_DECLARED_FRIENDSHIPCheckbox, "TQUI_LOC_GOSSIP_DECLARED_FRIENDSHIP");
  PopulateCheckBox(Controls.LOC_GOSSIP_DELEGATIONCheckbox, "TQUI_LOC_GOSSIP_DELEGATION");
  PopulateCheckBox(Controls.LOC_GOSSIP_DENOUNCEDCheckbox, "TQUI_LOC_GOSSIP_DENOUNCED");
  PopulateCheckBox(Controls.LOC_GOSSIP_EMBASSYCheckbox, "TQUI_LOC_GOSSIP_EMBASSY");
  PopulateCheckBox(Controls.LOC_GOSSIP_ERA_CHANGEDCheckbox, "TQUI_LOC_GOSSIP_ERA_CHANGED");
  PopulateCheckBox(Controls.LOC_GOSSIP_FIND_NATURAL_WONDERCheckbox, "TQUI_LOC_GOSSIP_FIND_NATURAL_WONDER");
  PopulateCheckBox(Controls.LOC_GOSSIP_FOUND_CITYCheckbox, "TQUI_LOC_GOSSIP_FOUND_CITY");
  PopulateCheckBox(Controls.LOC_GOSSIP_FOUND_RELIGIONCheckbox, "TQUI_LOC_GOSSIP_FOUND_RELIGION");
  PopulateCheckBox(Controls.LOC_GOSSIP_GREATPERSON_CREATEDCheckbox, "TQUI_LOC_GOSSIP_GREATPERSON_CREATED");
  PopulateCheckBox(Controls.LOC_GOSSIP_LAUNCHING_ATTACKCheckbox, "TQUI_LOC_GOSSIP_LAUNCHING_ATTACK");
  PopulateCheckBox(Controls.LOC_GOSSIP_WAR_PREPARATIONCheckbox, "TQUI_LOC_GOSSIP_WAR_PREPARATION");
  PopulateCheckBox(Controls.LOC_GOSSIP_INQUISITION_LAUNCHEDCheckbox, "TQUI_LOC_GOSSIP_INQUISITION_LAUNCHED");
  PopulateCheckBox(Controls.LOC_GOSSIP_LAND_UNIT_LEVELCheckbox, "TQUI_LOC_GOSSIP_LAND_UNIT_LEVEL");
  PopulateCheckBox(Controls.LOC_GOSSIP_MAKE_DOWCheckbox, "TQUI_LOC_GOSSIP_MAKE_DOW");
  PopulateCheckBox(Controls.LOC_GOSSIP_NATIONAL_PARK_CREATEDCheckbox, "TQUI_LOC_GOSSIP_NATIONAL_PARK_CREATED");
  PopulateCheckBox(Controls.LOC_GOSSIP_NEW_RELIGIOUS_MAJORITYCheckbox, "TQUI_LOC_GOSSIP_NEW_RELIGIOUS_MAJORITY");
  PopulateCheckBox(Controls.LOC_GOSSIP_PILLAGECheckbox, "TQUI_LOC_GOSSIP_PILLAGE");
  PopulateCheckBox(Controls.LOC_GOSSIP_POLICY_ENACTEDCheckbox, "TQUI_LOC_GOSSIP_POLICY_ENACTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_RECEIVE_DOWCheckbox, "TQUI_LOC_GOSSIP_RECEIVE_DOW");
  PopulateCheckBox(Controls.LOC_GOSSIP_RELIC_RECEIVEDCheckbox, "TQUI_LOC_GOSSIP_RELIC_RECEIVED");
  PopulateCheckBox(Controls.LOC_GOSSIP_RESEARCH_AGREEMENTCheckbox, "TQUI_LOC_GOSSIP_RESEARCH_AGREEMENT");
  PopulateCheckBox(Controls.LOC_GOSSIP_RESEARCH_TECHCheckbox, "TQUI_LOC_GOSSIP_RESEARCH_TECH");
  PopulateCheckBox(Controls.LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_DETECTEDCheckbox, "TQUI_LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_DETECTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_UNDETECTEDCheckbox, "TQUI_LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_UNDETECTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_SPY_GREAT_WORK_HEIST_DETECTEDCheckbox, "TQUI_LOC_GOSSIP_SPY_GREAT_WORK_HEIST_DETECTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_SPY_GREAT_WORK_HEIST_UNDETECTEDCheckbox, "TQUI_LOC_GOSSIP_SPY_GREAT_WORK_HEIST_UNDETECTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_SPY_RECRUIT_PARTISANS_DETECTEDCheckbox, "TQUI_LOC_GOSSIP_SPY_RECRUIT_PARTISANS_DETECTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_SPY_RECRUIT_PARTISANS_UNDETECTEDCheckbox, "TQUI_LOC_GOSSIP_SPY_RECRUIT_PARTISANS_UNDETECTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_DETECTEDCheckbox, "TQUI_LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_DETECTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_UNDETECTEDCheckbox, "TQUI_LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_UNDETECTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_SPY_SIPHON_FUNDS_DETECTEDCheckbox, "TQUI_LOC_GOSSIP_SPY_SIPHON_FUNDS_DETECTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_SPY_SIPHON_FUNDS_UNDETECTEDCheckbox, "TQUI_LOC_GOSSIP_SPY_SIPHON_FUNDS_UNDETECTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_SPY_STEAL_TECH_BOOST_DETECTEDCheckbox, "TQUI_LOC_GOSSIP_SPY_STEAL_TECH_BOOST_DETECTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_SPY_STEAL_TECH_BOOST_UNDETECTEDCheckbox, "TQUI_LOC_GOSSIP_SPY_STEAL_TECH_BOOST_UNDETECTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_TRADE_DEALCheckbox, "TQUI_LOC_GOSSIP_TRADE_DEAL");
  PopulateCheckBox(Controls.LOC_GOSSIP_TRADE_RENEGECheckbox, "TQUI_LOC_GOSSIP_TRADE_RENEGE");
  PopulateCheckBox(Controls.LOC_GOSSIP_TRAIN_SETTLERCheckbox, "TQUI_LOC_GOSSIP_TRAIN_SETTLER");
  PopulateCheckBox(Controls.LOC_GOSSIP_TRAIN_UNITCheckbox, "TQUI_LOC_GOSSIP_TRAIN_UNIT");
  PopulateCheckBox(Controls.LOC_GOSSIP_TRAIN_UNIQUE_UNITCheckbox, "TQUI_LOC_GOSSIP_TRAIN_UNIQUE_UNIT");
  PopulateCheckBox(Controls.LOC_GOSSIP_PROJECT_STARTEDCheckbox, "TQUI_LOC_GOSSIP_PROJECT_STARTED");
  PopulateCheckBox(Controls.LOC_GOSSIP_START_VICTORY_STRATEGYCheckbox, "TQUI_LOC_GOSSIP_START_VICTORY_STRATEGY");
  PopulateCheckBox(Controls.LOC_GOSSIP_STOP_VICTORY_STRATEGYCheckbox, "TQUI_LOC_GOSSIP_STOP_VICTORY_STRATEGY");
  PopulateCheckBox(Controls.LOC_GOSSIP_WMD_BUILTCheckbox, "TQUI_LOC_GOSSIP_WMD_BUILT");
  PopulateCheckBox(Controls.LOC_GOSSIP_WMD_STRIKECheckbox, "TQUI_LOC_GOSSIP_WMD_STRIKE");
  PopulateCheckBox(Controls.LOC_GOSSIP_WONDER_STARTEDCheckbox, "TQUI_LOC_GOSSIP_WONDER_STARTED");
end
---- TQUI FUNCTIONS
-- ===========================================================================
--
-- ===========================================================================
function Initialize()

	--Resize();	
  --Adding/binding tabs...
  m_tabs = {
   
    {Controls.GossipTab, Controls.GossipOptions}
   
  };
 for i, tab in ipairs(m_tabs) do
    local button = tab[1];
    local panel = tab[2];
    button:RegisterCallback(Mouse.eLClick, function() ShowTab(button, panel); end);
  end
   PopulateCheckBox(Controls.TrimGossipCheckbox, "TQUI_TrimGossip", Locale.Lookup("LOC_TQUI_GOSSIP_TRIMMESSAGE_TOOLTIP"));
    InitializeGossipCheckboxes();
  
  --Setting up panel controls
  ShowTab(m_tabs[1][1], m_tabs[1][2]); --Show General Settings on start
  LuaEvents.TQUI_SettingsInitialized();
	-- UI Callbacks
	ContextPtr:SetInitHandler( OnInit );
	ContextPtr:SetInputHandler( OnInputHandler, true );
	Controls.CloseButton:RegisterCallback( Mouse.eLClick, OnCloseButton );
	Controls.CloseButton:RegisterCallback(	Mouse.eMouseEnter, function() UI.PlaySound("Main_Menu_Mouse_Over"); end);
	
	-- Events
	LuaEvents.TopPanel_OpenTQUIScreen.Add( OnTopOpenTQUI );
	LuaEvents.TopPanel_CloseTQUIScreen.Add( OnTopCloseTQUI );
end
Initialize();
