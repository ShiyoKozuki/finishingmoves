addon.name      = 'FinishingMoves';
addon.author    = 'Shiyo';
addon.version   = '1.1';
addon.desc      = 'Displays number of finishing moves';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local fonts = require('fonts');
local settings = require('settings');

local default_settings = T{
	font = T{
        visible = true,
        font_family = 'Arial',
        font_height = 30,
        color = 0xFFFF00FF,
        position_x = 1,
        position_y = 1,
		background = T{
			visible = true,
			color = 0x80000000,
		}
    }
};

local finnishingmoves = T{
	settings = settings.load(default_settings)
};

local function GetFinishingMoves()
    local me = AshitaCore:GetMemoryManager():GetPlayer()
    local buffs = me:GetBuffs()
    
    for _, buff in pairs(buffs) do
        if buff == 381 then
          return 1
        elseif buff == 382 then
          return 2
        elseif buff == 383 then
          return 3
        elseif buff == 384 then
          return 4
        elseif buff == 385 then
          return 5
        elseif buff == 588 then
          return 6
        end
	end
    return 0;
end

ashita.events.register('load', 'load_cb', function ()
    finnishingmoves.font = fonts.new(finnishingmoves.settings.font);
end);

ashita.events.register('d3d_present', 'present_cb', function ()
	local mJob = AshitaCore:GetMemoryManager():GetPlayer():GetMainJob();
	local sJob = AshitaCore:GetMemoryManager():GetPlayer():GetSubJob();
	
	if mJob == 19 or sJob == 19 then
	  finnishingmoves.font.text = ('%d' ):fmt(GetFinishingMoves());    
	  finnishingmoves.settings.font.position_x = finnishingmoves.font:GetPositionX();
	  finnishingmoves.settings.font.position_y = finnishingmoves.font:GetPositionY();
	  finnishingmoves.font.visible = true;
	else
	  finnishingmoves.font.visible = false;
  end
end);

ashita.events.register('unload', 'unload_cb', function ()
    if (finnishingmoves.font ~= nil) then
        finnishingmoves.font:destroy();
    end
settings.save();
end);