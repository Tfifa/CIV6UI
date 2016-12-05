/*  
    ┌────────────────────────────────────────────────────────────────────────────────────────────┐
    │                                    Gossip settings                                         │
    ├────────────────────────────────────────────────────────────────────────────────────────────┤
    │These settings control the default state of the Gossip message checkboxes                   │
    │Valid values are 0 (disabled) or 1 (enabled). Don't change the names or the first line!     │
    └────────────────────────────────────────────────────────────────────────────────────────────┘
*/

INSERT INTO TQUI_gossips 
  VALUES  ("TQUI_TrimGossip", 1,"TQUI_TrimGossip"), --Trims the source from the start of gossip messages
     -- <!-- Diplo_gossips -->
	 ("TQUI_LOC_GOSSIP_DELEGATION", 0,"TQUI_Diplo_gossips"),
	 ("TQUI_LOC_GOSSIP_EMBASSY", 0,"TQUI_Diplo_gossips"),
	 ("TQUI_LOC_GOSSIP_CITY_STATE_INFLUENCE", 1,"TQUI_Diplo_gossips"),
	 ("TQUI_LOC_GOSSIP_DECLARED_FRIENDSHIP", 1,"TQUI_Diplo_gossips"),
	 ("TQUI_LOC_GOSSIP_ALLIED", 1,"TQUI_Diplo_gossips"),
	 ("TQUI_LOC_GOSSIP_RESEARCH_AGREEMENT", 0,"TQUI_Diplo_gossips"),
	 ("TQUI_LOC_GOSSIP_DENOUNCED", 1,"TQUI_Diplo_gossips"),
	 
	 -- <!-- City_gossips -->
	 ("TQUI_LOC_GOSSIP_TRAIN_SETTLER", 1,"TQUI_City_gossips"),
	 ("TQUI_LOC_GOSSIP_FOUND_CITY", 1,"TQUI_City_gossips"),
	 ("TQUI_LOC_GOSSIP_CITY_BESIEGED", 1,"TQUI_City_gossips"),
	 ("TQUI_LOC_GOSSIP_CONQUER_CITY", 1,"TQUI_City_gossips"),
	 ("TQUI_LOC_GOSSIP_CITY_RAZED", 1,"TQUI_City_gossips"),
	 ("TQUI_LOC_GOSSIP_CITY_LIBERATED", 1,"TQUI_City_gossips"),
	 
	 -- <!-- Military_gossips -->
	 ("TQUI_LOC_GOSSIP_MAKE_DOW", 1,"TQUI_Military_gossips"),
	 ("TQUI_LOC_GOSSIP_RECEIVE_DOW", 1,"TQUI_Military_gossips"),
	 ("TQUI_LOC_GOSSIP_TRAIN_UNIT", 1,"TQUI_Military_gossips"),
     ("TQUI_LOC_GOSSIP_TRAIN_UNIQUE_UNIT", 1,"TQUI_Military_gossips"),
	 ("TQUI_LOC_GOSSIP_LAND_UNIT_LEVEL", 0,"TQUI_Military_gossips"),
	 ("TQUI_LOC_GOSSIP_PILLAGE", 0,"TQUI_Military_gossips"),
	 ("TQUI_LOC_GOSSIP_WMD_BUILT", 1,"TQUI_Military_gossips"),
     ("TQUI_LOC_GOSSIP_WMD_STRIKE", 1,"TQUI_Military_gossips"),
	 
	  -- <!-- Construction_gossips -->
	 ("TQUI_LOC_GOSSIP_CONSTRUCT_DISTRICT", 1,"TQUI_Construction_gossips"),
	 ("TQUI_LOC_GOSSIP_WONDER_STARTED", 1,"TQUI_Construction_gossips"),
	 ("TQUI_LOC_GOSSIP_PROJECT_STARTED", 0,"TQUI_Construction_gossips"),
	 ("TQUI_LOC_GOSSIP_GREATPERSON_CREATED", 1,"TQUI_Construction_gossips"),
	 
	 -- <!-- CultureTech_gossips -->
	 ("TQUI_LOC_GOSSIP_ERA_CHANGED", 1,"TQUI_CultureTech_gossips"),
	 ("TQUI_LOC_GOSSIP_RESEARCH_TECH", 1,"TQUI_CultureTech_gossips"),
	 ("TQUI_LOC_GOSSIP_CULTURVATE_CIVIC", 1,"TQUI_CultureTech_gossips"), --Civic researched
	 ("TQUI_LOC_GOSSIP_POLICY_ENACTED", 1,"TQUI_CultureTech_gossips"),
	 ("TQUI_LOC_GOSSIP_CHANGE_GOVERNMENT", 1,"TQUI_CultureTech_gossips"),
	 ("TQUI_LOC_GOSSIP_ANARCHY_BEGINS", 1,"TQUI_CultureTech_gossips"),
	 
	  -- <!-- Trade_gossips -->
	 ("TQUI_LOC_GOSSIP_TRADE_DEAL", 0,"TQUI_Trade_gossips"),
     ("TQUI_LOC_GOSSIP_TRADE_RENEGE", 0,"TQUI_Trade_gossips"),
	  
	  -- <!-- Spy_gossips -->
	 ("TQUI_LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_DETECTED", 1,"TQUI_Spy_gossips"),
     ("TQUI_LOC_GOSSIP_SPY_DISRUPT_ROCKETRY_UNDETECTED", 1,"TQUI_Spy_gossips"),
     ("TQUI_LOC_GOSSIP_SPY_GREAT_WORK_HEIST_DETECTED", 0,"TQUI_Spy_gossips"),
     ("TQUI_LOC_GOSSIP_SPY_GREAT_WORK_HEIST_UNDETECTED", 0,"TQUI_Spy_gossips"),
     ("TQUI_LOC_GOSSIP_SPY_RECRUIT_PARTISANS_DETECTED", 1,"TQUI_Spy_gossips"),
     ("TQUI_LOC_GOSSIP_SPY_RECRUIT_PARTISANS_UNDETECTED", 1,"TQUI_Spy_gossips"),
     ("TQUI_LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_DETECTED", 1,"TQUI_Spy_gossips"),
     ("TQUI_LOC_GOSSIP_SPY_SABOTAGE_PRODUCTION_UNDETECTED", 1,"TQUI_Spy_gossips"),
     ("TQUI_LOC_GOSSIP_SPY_SIPHON_FUNDS_DETECTED", 1,"TQUI_Spy_gossips"),
     ("TQUI_LOC_GOSSIP_SPY_SIPHON_FUNDS_UNDETECTED", 1,"TQUI_Spy_gossips"),
     ("TQUI_LOC_GOSSIP_SPY_STEAL_TECH_BOOST_DETECTED", 1,"TQUI_Spy_gossips"),
     ("TQUI_LOC_GOSSIP_SPY_STEAL_TECH_BOOST_UNDETECTED", 1,"TQUI_Spy_gossips"),
	   -- <!-- Religion_gossips -->
	 ("TQUI_LOC_GOSSIP_CREATE_PANTHEON", 1,"TQUI_Religion_gossips"),
	 ("TQUI_LOC_GOSSIP_FOUND_RELIGION", 1,"TQUI_Religion_gossips"),
	 ("TQUI_LOC_GOSSIP_NEW_RELIGIOUS_MAJORITY", 1,"TQUI_Religion_gossips"),
     ("TQUI_LOC_GOSSIP_INQUISITION_LAUNCHED", 0,"TQUI_Religion_gossips"),
	  -- <!-- Tourism_gossips --> 
	 ("TQUI_LOC_GOSSIP_RELIC_RECEIVED", 0,"TQUI_Tourism_gossips"),
	 ("TQUI_LOC_GOSSIP_ARTIFACT_EXTRACTED", 0,"TQUI_Tourism_gossips"),
	 ("TQUI_LOC_GOSSIP_BEACH_RESORT_CREATED", 0,"TQUI_Tourism_gossips"),
	 ("TQUI_LOC_GOSSIP_NATIONAL_PARK_CREATED", 0,"TQUI_Tourism_gossips"),
	 -- <!-- AIspecific_gossips -->  
	 ("TQUI_LOC_GOSSIP_START_VICTORY_STRATEGY", 1,"TQUI_AIspecific_gossips"),
     ("TQUI_LOC_GOSSIP_STOP_VICTORY_STRATEGY", 1,"TQUI_AIspecific_gossips"),
	 ("TQUI_LOC_GOSSIP_AGENDA_KUDOS", 0,"TQUI_AIspecific_gossips"),
     ("TQUI_LOC_GOSSIP_AGENDA_WARNING", 1,"TQUI_AIspecific_gossips"), 
  	 ("TQUI_LOC_GOSSIP_LAUNCHING_ATTACK", 1,"TQUI_AIspecific_gossips"),
     ("TQUI_LOC_GOSSIP_WAR_PREPARATION", 1,"TQUI_AIspecific_gossips"),
	  -- <!-- Other_gossips -->
	 ("TQUI_LOC_GOSSIP_BARBARIAN_INVASION_STARTED", 1,"TQUI_Other_gossips"),
     ("TQUI_LOC_GOSSIP_BARBARIAN_RAID_STARTED", 1,"TQUI_Other_gossips"), 
     ("TQUI_LOC_GOSSIP_CLEAR_CAMP", 0,"TQUI_Other_gossips"),
     ("TQUI_LOC_GOSSIP_FIND_NATURAL_WONDER", 0,"TQUI_Other_gossips");
    
   
    
    
    
    
    
    
    
    
    
   
   
   
    
    
    
    
    
    
    
    
    
    
    
    
  
    