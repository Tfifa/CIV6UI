-- Modified by HellBlazer on 2016-10-24

-- =========================================================================== 
-- Status Message Manager
-- Non-interactive messages that appear in the upper-center of the screen.
-- =========================================================================== 
include("InstanceManager");
include("SupportFunctions");

-- =========================================================================== 
--	CONSTANTS
-- =========================================================================== 
local DEFAULT_TIME_TO_DISPLAY :number = 10; -- Seconds to display the message


-- =========================================================================== 
--	VARIABLES
-- =========================================================================== 

local m_statusIM :table = InstanceManager:new("StatusMessageInstance", "Root", Controls.StackOfMessages);
local m_gossipIM :table = InstanceManager:new("GossipMessageInstance", "Root", Controls.StackOfMessages);
-- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN begin
local m_connectionIM :table = InstanceManager:new("ConnectionMessageInstance", "Root", Controls.StackOfMessages);

-- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN end

local PlayerConnectedChatStr :string = Locale.Lookup("LOC_MP_PLAYER_CONNECTED_CHAT");
local PlayerDisconnectedChatStr :string = Locale.Lookup("LOC_MP_PLAYER_DISCONNECTED_CHAT");
local PlayerKickedChatStr :string = Locale.Lookup("LOC_MP_PLAYER_KICKED_CHAT");

local m_kMessages :table = {};
--TQUI Members
local TQUI_trimGossip = true;
local TQUI_ignoredMessages = {};

function TQUI_OnSettingsUpdate()
    TQUI_trimGossip = GameConfiguration.GetValue("TQUI_TrimGossip");
    TQUI_ignoredMessages = TQUI_GetIgnoredGossipMessages();
end

LuaEvents.TQUI_gossipsUpdate.Add(TQUI_OnSettingsUpdate);
LuaEvents.TQUI_SettingsInitialized.Add(TQUI_OnSettingsUpdate);

-- =========================================================================== 
--	FUNCTIONS
-- =========================================================================== 
-- Gets a list of ignored gossip messages based on current settings
function TQUI_GetIgnoredGossipMessages() --Yeah... as far as I can tell there's no way to get these programatically, so I just made a script that grepped these from the LOC files
    local ignored :table = {};
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_AGENDA_KUDOS") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_AGENDA_KUDOS", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_AGENDA_WARNING") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_AGENDA_WARNING", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_ALLIED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_ALLIED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_ANARCHY_BEGINS") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_ANARCHY_BEGINS", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_ARTIFACT_EXTRACTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_ARTIFACT_EXTRACTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_BARBARIAN_INVASION_STARTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_BARBARIAN_INVASION_STARTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_BARBARIAN_RAID_STARTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_BARBARIAN_RAID_STARTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_BEACH_RESORT_CREATED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_BEACH_RESORT_CREATED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_CHANGE_GOVERNMENT") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_CHANGE_GOVERNMENT", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_CITY_BESIEGED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_CITY_BESIEGED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_CITY_LIBERATED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_CITY_LIBERATED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_CITY_RAZED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_CITY_RAZED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_CLEAR_CAMP") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_CLEAR_CAMP", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_CITY_STATE_INFLUENCE") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_CITY_STATE_INFLUENCE", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_CONQUER_CITY") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_CONQUER_CITY", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_CONSTRUCT_BUILDING") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_CONSTRUCT_BUILDING", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_CONSTRUCT_DISTRICT") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_CONSTRUCT_DISTRICT", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_CREATE_PANTHEON") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_CREATE_PANTHEON", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_CULTURVATE_CIVIC") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_CULTURVATE_CIVIC", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_DECLARED_FRIENDSHIP") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_DECLARED_FRIENDSHIP", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_DELEGATION") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_DELEGATION", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_DENOUNCED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_DENOUNCED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_EMBASSY") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_EMBASSY", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_ERA_CHANGED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_ERA_CHANGED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_FIND_NATURAL_WONDER") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_FIND_NATURAL_WONDER", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_FOUND_CITY") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_FOUND_CITY", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_FOUND_RELIGION") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_FOUND_RELIGION", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_GREATPERSON_CREATED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_GREATPERSON_CREATED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_LAUNCHING_ATTACK") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_LAUNCHING_ATTACK", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_WAR_PREPARATION") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_WAR_PREPARATION", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_INQUISITION_LAUNCHED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_INQUISITION_LAUNCHED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_LAND_UNIT_LEVEL") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_LAND_UNIT_LEVEL", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_MAKE_DOW") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_MAKE_DOW", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_NATIONAL_PARK_CREATED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_NATIONAL_PARK_CREATED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_NEW_RELIGIOUS_MAJORITY") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_NEW_RELIGIOUS_MAJORITY", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_PILLAGE") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_PILLAGE", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_POLICY_ENACTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_POLICY_ENACTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_RECEIVE_DOW") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_RECEIVE_DOW", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_RELIC_RECEIVED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_RELIC_RECEIVED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_RESEARCH_AGREEMENT") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_RESEARCH_AGREEMENT", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_RESEARCH_TECH") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_RESEARCH_TECH", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_DETECTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_DETECTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_UNDETECTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_UNDETECTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_SPY_GREAT_WORK_HEIST_DETECTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_SPY_GREAT_WORK_HEIST_DETECTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_SPY_GREAT_WORK_HEIST_UNDETECTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_SPY_GREAT_WORK_HEIST_UNDETECTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_SPY_RECRUIT_PARTISANS_DETECTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_SPY_RECRUIT_PARTISANS_DETECTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_SPY_RECRUIT_PARTISANS_UNDETECTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_SPY_RECRUIT_PARTISANS_UNDETECTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_DETECTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_DETECTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_UNDETECTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_UNDETECTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_SPY_SIPHON_FUNDS_DETECTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_SPY_SIPHON_FUNDS_DETECTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_SPY_SIPHON_FUNDS_UNDETECTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_SPY_SIPHON_FUNDS_UNDETECTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_SPY_STEAL_TECH_BOOST_DETECTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_SPY_STEAL_TECH_BOOST_DETECTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_SPY_STEAL_TECH_BOOST_UNDETECTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_SPY_STEAL_TECH_BOOST_UNDETECTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_TRADE_DEAL") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_TRADE_DEAL", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_TRADE_RENEGE") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_TRADE_RENEGE", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_TRAIN_SETTLER") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_TRAIN_SETTLER", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_TRAIN_UNIT") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_TRAIN_UNIT", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_TRAIN_UNIQUE_UNIT") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_TRAIN_UNIQUE_UNIT", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_PROJECT_STARTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_PROJECT_STARTED", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_START_VICTORY_STRATEGY") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_START_VICTORY_STRATEGY", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_STOP_VICTORY_STRATEGY") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_STOP_VICTORY_STRATEGY", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_WMD_BUILT") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_WMD_BUILT", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_WMD_STRIKE") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_WMD_STRIKE", "X", "Y", "Z", "1", "2", "3");
    end
    if (GameConfiguration.GetValue("TQUI_LOC_GOSSIP_WONDER_STARTED") == false) then
        ignored[#ignored + 1] = Locale.Lookup("LOC_GOSSIP_WONDER_STARTED", "X", "Y", "Z", "1", "2", "3");
    end
    return ignored;
end

--Trims source information from gossip messages. Returns nil if the message couldn't be trimmed (this usually means the provided string wasn't a gossip message at all)
function TQUI_TrimGossipMessage(str: string)

    if (tostring(Locale.GetCurrentLanguage().Type) == "zh_Hans_CN") then
        local pSplitstr = nil;
        pSplitstr = Split(str, "偶然听说:")[2];
        if (pSplitstr ~= nil) then
            return pSplitstr;
        else
            pSplitstr = Split(str, "获悉:")[2];
            if (pSplitstr ~= nil) then
                return pSplitstr;
            else
                pSplitstr = Split(str, "听说:")[2];
                if (pSplitstr ~= nil) then
                    return pSplitstr;
                else
                    pSplitstr = Split(str, "揭露:")[2];
                    if (pSplitstr ~= nil) then
                        return pSplitstr;
                    else
                        pSplitstr = Split(str, "查明:")[2];
                        if (pSplitstr ~= nil) then
                            return pSplitstr;
                        else
                            return str;   -- for difference chinese translation Text ,if cannot trim by keyword ,retun  origin str;
                        end
                    end
                end
            end
        end
    elseif (tostring(Locale.GetCurrentLanguage().Type) == "en_US") then
        local sourceSample = Locale.Lookup("LOC_GOSSIP_SOURCE_DELEGATE", "X", "Y", "Z");
        _, last = string.match(sourceSample, "(.-)%s(%S+)$");
        return Split(str, " " .. last .. " ", 2)[2];
    else
        return str;
    end
end

-- Returns true if the given message is disabled in settings
function TQUI_IsGossipMessageIgnored(str: string) --Heuristics for figuring out if the given message should be ignored
    if (str == nil) then return false; end --str will be nil if the last word from the gossip source string can't be found in message. Generally means the incoming message wasn't gossip at all
    local strwords = Split(str, " "); --Split into component words
    for _, message in ipairs(TQUI_ignoredMessages) do
        message = Split(message, " ");
        for _, strword in ipairs(strwords) do
            local tally = 0; --Tracks how many words from the ignored message were matched in comparison to the real message
            for i, messageword in ipairs(message) do
                if (messageword == strword or string.find(messageword, "X") or string.find(messageword, "Y") or string.find(messageword, "Z")) then --Ignores words containing the given placeholder letters. Has some chance for false positives, but it's very unlikely this will every actually make much difference
                    tally = tally + 1;
                end
            end
            if (tally >= #message - 1) then --If every single word from the ignored message matched the real message, return true
                return true;
            end
        end
    end
    return false;
end

-- ===========================================================================
-- ===========================================================================
function OnStatusMessage(str: string, fDisplayTime:number, type:number)

    -- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN begin
    if (type == 99 or type == ReportingStatusTypes.GOSSIP or type == ReportingStatusTypes.DEFAULT) then -- A type we handle?
        -- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN old code
        --	if (type == ReportingStatusTypes.DEFAULT or
        --		type == ReportingStatusTypes.GOSSIP) then	-- A type we handle?
        -- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN end
        if (type == ReportingStatusTypes.GOSSIP) then
            print("start trimgossip origin is " .. str)
            local trimmed = TQUI_TrimGossipMessage(str);
            print("start trimgossip trimmed is ", trimmed)
            if (trimmed ~= nil) then
                if (TQUI_IsGossipMessageIgnored(trimmed)) then
                    return; --If the message is supposed to be ignored, give up!
                elseif (TQUI_trimGossip) then

                    str = trimmed
                end
            end
        end
        local kTypeEntry :table = m_kMessages[type];
        if (kTypeEntry == nil) then
            -- New type
            m_kMessages[type] = {
                InstanceManager = nil,
                MessageInstances = {}
            };
            kTypeEntry = m_kMessages[type];

            -- Link to the instance manager and the stack the UI displays in
            if (type == ReportingStatusTypes.GOSSIP) then
                kTypeEntry.InstanceManager = m_gossipIM;

                -- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN begin
            elseif (type == 99) then
                kTypeEntry.InstanceManager = m_connectionIM;
                -- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN end
            elseif (type == 98) then
                kTypeEntry.InstanceManager = m_DiploIM;
            else
                kTypeEntry.InstanceManager = m_statusIM;
            end
        end

        -- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN begin
        if (type == ReportingStatusTypes.DEFAULT) then
            fDisplayTime = 3;
        end
        -- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN end

        local pInstance :table = kTypeEntry.InstanceManager:GetInstance();
        table.insert(kTypeEntry.MessageInstances, pInstance);

        local timeToDisplay :number = (fDisplayTime > 0) and fDisplayTime or DEFAULT_TIME_TO_DISPLAY;

        if (type == ReportingStatusTypes.GOSSIP) then
            pInstance.StatusGrid:SetColor(0xFFFFFFFF);
        end

        pInstance.StatusLabel:SetText(str);
        pInstance.Anim:SetEndPauseTime(timeToDisplay);
        pInstance.Anim:RegisterEndCallback(function() OnEndAnim(kTypeEntry, pInstance) end);
        pInstance.Anim:SetToBeginning();
        pInstance.Anim:Play();

        Controls.StackOfMessages:CalculateSize();
        Controls.StackOfMessages:ReprocessAnchoring();
    end
end

-- ===========================================================================
function OnEndAnim(kTypeEntry: table, pInstance:table)
    pInstance.Anim:ClearEndCallback();
    Controls.StackOfMessages:CalculateSize();
    Controls.StackOfMessages:ReprocessAnchoring();
    kTypeEntry.InstanceManager:ReleaseInstance(pInstance)
end

-- ===========================================================================

----------------------------------------------------------------
function OnMultplayerPlayerConnected(playerID)
    if (ContextPtr:IsHidden() == false and GameConfiguration.IsNetworkMultiplayer()) then
        local pPlayerConfig = PlayerConfigurations[playerID];
        local statusMessage = pPlayerConfig:GetPlayerName() .. " " .. PlayerConnectedChatStr;
        -- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN begin
        OnStatusMessage(statusMessage, DEFAULT_TIME_TO_DISPLAY, 99);
        -- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN old code
        --		OnStatusMessage( statusMessage, DEFAULT_TIME_TO_DISPLAY, ReportingStatusTypes.DEFAULT );
        -- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN end
    end
end

----------------------------------------------------------------
function OnMultiplayerPrePlayerDisconnected(playerID)
    if (ContextPtr:IsHidden() == false and GameConfiguration.IsNetworkMultiplayer()) then
        local pPlayerConfig = PlayerConfigurations[playerID];
        local statusMessage = Locale.Lookup(pPlayerConfig:GetPlayerName());
        if (Network.IsPlayerKicked(playerID)) then
            statusMessage = statusMessage .. " " .. PlayerKickedChatStr;
        else
            statusMessage = statusMessage .. " " .. PlayerDisconnectedChatStr;
        end
        -- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN begin
        OnStatusMessage(statusMessage, DEFAULT_TIME_TO_DISPLAY, 99);
        -- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN old code
        --		OnStatusMessage(statusMessage, DEFAULT_TIME_TO_DISPLAY, ReportingStatusTypes.DEFAULT);
        -- TAG_FIX_WAR_MESSAGE_BLOCKING_SCREEN end
    end
end

-- ===========================================================================
--	Testing: When on the "G" and "D" keys generate messages.
-- ===========================================================================
function Test()
    -- OnStatusMessage("Testing out A message", 10, ReportingStatusTypes.GOSSIP);
    local teststrstr = "您勇敢的记者，茉莉，得知  埃及03建立了城市";
    local pSplitstr = nil;
    if (tostring(Locale.GetCurrentLanguage().Type) == "zh_Hans_CN") then
        pSplitstr = Split(teststrstr, "发现了")[2];
        if (pSplitstr ~= nil) then
            
        else
            pSplitstr = Split(teststrstr, "偷听到")[2];
            if (pSplitstr ~= nil) then
                
            else
                pSplitstr = Split(teststrstr, "得知")[2];
                if (pSplitstr ~= nil) then
                    
                else
                    pSplitstr = Split(teststrstr, "听说")[2];
                    if (pSplitstr ~= nil) then
                        
                    end
                end
            end
        end
    end
    print(pSplitstr);
    -- local pteststrstr = Split(teststrstr, "发现了")[2];
    -- print(pteststrstr);

    -- local cLanguage=tostring(Locale.GetCurrentLanguage().Type);

    -- print("now local languages is" .. Locale.GetCurrentLanguage().Type);

    -- ContextPtr:SetInputHandler(function(pInputStruct)
    -- local uiMsg = pInputStruct:GetMessageType();
    -- if uiMsg == KeyEvents.KeyUp then
    -- local key = pInputStruct:GetKey();
    -- if key == Keys.G then OnStatusMessage(pteststrstr, 10, ReportingStatusTypes.GOSSIP); return true; end
    -- end
    -- return false;
    -- end, true);
end


-- ===========================================================================
function Initialize()
    Events.StatusMessage.Add(OnStatusMessage);
    Events.MultiplayerPlayerConnected.Add(OnMultplayerPlayerConnected);
    Events.MultiplayerPrePlayerDisconnected.Add(OnMultiplayerPrePlayerDisconnected);
    --Test();
end

Initialize();