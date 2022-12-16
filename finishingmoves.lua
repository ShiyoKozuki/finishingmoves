addon.name      = 'FinishingMoves';
addon.author    = 'Shiyo';
addon.version   = '1.1';
addon.desc      = 'Displays number of finishing moves';
addon.link      = 'https://ashitaxi.com/';

require('common');
local chat = require('chat');
local fonts = require('fonts');
local settings = require('settings');

local windowWidth = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0001', 1024);
local windowHeight = AshitaCore:GetConfigurationManager():GetFloat('boot', 'ffxi.registry', '0002', 768);

local default_settings = T{
	font = T{
        visible = true,
        font_family = 'Arial',
        font_height = 30,
        color = 0xFFFF00FF,
        position_y = 800,
        position_x = 1368,
		background = T{
			visible = true,
			color = 0x80000000,
		}
    }
};

local finishingmoves = T{
	settings = settings.load(default_settings)
};

local UpdateSettings = function(settings)
  finishingmoves.settings = settings;
  if (finishingmoves.font ~= nil) then
      finishingmoves.font:apply(finishingmoves.settings.font)
  end
end

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
  finishingmoves.font = fonts.new(finishingmoves.settings.font);
  settings.register('settings', 'settingchange', UpdateSettings);
end);

ashita.events.register('d3d_present', 'present_cb', function ()
	local mJob = AshitaCore:GetMemoryManager():GetPlayer():GetMainJob();
	local sJob = AshitaCore:GetMemoryManager():GetPlayer():GetSubJob();

  local fontObject = finishingmoves.font;
  if (fontObject.position_x > windowWidth) then
    fontObject.position_x = 0;
  end
  if (fontObject.position_y > windowHeight) then
    fontObject.position_y = 0;
  end
  if (fontObject.position_x ~= finishingmoves.settings.font.position_x) or (fontObject.position_y ~= finishingmoves.settings.font.position_y) then
      finishingmoves.settings.font.position_x = fontObject.position_x;
      finishingmoves.settings.font.position_y = fontObject.position_y;
      settings.save()
  end

	if mJob == 19 or sJob == 19 then
	  finishingmoves.font.text = ('%d' ):fmt(GetFinishingMoves());    
	  finishingmoves.font.visible = true;
	else
	  finishingmoves.font.visible = false;
  end
end);

ashita.events.register('unload', 'unload_cb', function ()
    if (finishingmoves.font ~= nil) then
        finishingmoves.font:destroy();
    end
settings.save();
end);