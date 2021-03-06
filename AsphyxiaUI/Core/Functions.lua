---------------------------------------------------------------------------------------------
-- AddOn Name: AsphyxiaUI 6.0.0
-- License: MIT
-- Author: Sinaris @ Das Syndikat, Vaecia @ Blackmoore
-- Description: AsphyxiaUI, Editied Tukui Layout
---------------------------------------------------------------------------------------------

local S, C, L, G = unpack( Tukui )

S.ClassColor = RAID_CLASS_COLORS[S.myclass]

S.CreateFontString = function( normalfont )
	if( normalfont ) then
		return C["media"]["font"], 12, "THINOUTLINE"
	else
		if( S.client == "ruRU" ) then
			return C["media"]["pixel_ru"], 10, "MONOCHROMEOUTLINE"
		else
			return C["media"]["asphyxia"], 10, "MONOCHROMEOUTLINE"
		end
	end
end

S.UTF = function( string, i, dots )
	if( not string ) then return end

	local bytes = string:len()
	if( bytes <= i ) then
		return string
	else
		local len, pos = 0, 1
		while( pos <= bytes ) do
			len = len + 1
			local c = string:byte( pos )

			if( c > 0 and c <= 127 ) then
				pos = pos + 1
			elseif( c >= 192 and c <= 223 ) then
				pos = pos + 2
			elseif( c >= 224 and c <= 239 ) then
				pos = pos + 3
			elseif( c >= 240 and c <= 247 ) then
				pos = pos + 4
			end
			if( len == i ) then break end
		end

		if( len == i and pos <= bytes ) then
			return string:sub( 1, pos - 1 ) .. ( dots and "..." or "" )
		else
			return string
		end
	end
end

function S.SetModifiedBackdrop( self )
	self:SetBackdropColor( S.ClassColor.r * 0.15, S.ClassColor.g * 0.15, S.ClassColor.b * 0.15 )
	self:SetBackdropBorderColor( S.ClassColor.r, S.ClassColor.g, S.ClassColor.b )
end

function S.SetOriginalBackdrop( self )
	if( C["general"]["classcolortheme"] == true ) then
		self:SetBackdropBorderColor( S.ClassColor.r, S.ClassColor.g, S.ClassColor.b )
	else
		self:SetTemplate( "Default" )
	end
end

S.DataBarPoint = function( p, obj )
	obj:SetPoint( "TOPRIGHT", S.databars[p], "TOPRIGHT", -2, -2 )
	obj:SetPoint( "BOTTOMLEFT", S.databars[p], "BOTTOMLEFT", 2, 2 )
end

S.DataBarTooltipAnchor = function( barNum )
	local xoff = -S.databars[barNum]:GetWidth()
	local yoff = S.Scale(-5)
	
	if( C["databars"]["settings"]["vertical"] == true ) then
		xoff = S.Scale( 5 )
		yoff = S.databars[barNum]:GetHeight()
	end

	return xoff, yoff
end

function S.update_alpha( self )
	if( self.parent:GetAlpha() == 0 ) then
		self.parent:Hide()
		self:Hide()
	end
end

function S.fadeOut( self )
	UIFrameFadeOut( self, 0.4, 1, 0 )
	self.frame:Show()
end

function S.fadeIn( p )
	p.frame = CreateFrame( "Frame", nil, p )
	p.frame:Hide()
	p.frame.parent = p
	p.frame:SetScript( "OnUpdate", S.update_alpha )
	p:SetScript( "OnShow", function()
		p.frame:Hide()
		UIFrameFadeIn( p, 0.4, 0, 1 )
	end )
	p.fadeOut = S.fadeOut
end

function S.RoleIconUpdate( self, event )
	local lfdrole = self.LFDRole
	local role = UnitGroupRolesAssigned( self.unit )

	if( role == "TANK" or role == "HEALER" or role == "DAMAGER" ) and UnitIsConnected( self.unit ) then
		if( role == "TANK" ) then
			lfdrole:SetTexture( C["media"]["lfdrole_tank"] )
		elseif( role == "HEALER" ) then
			lfdrole:SetTexture( C["media"]["lfdrole_healer"] )
		elseif( role == "DAMAGER" ) then
			lfdrole:SetTexture( C["media"]["lfdrole_dps"] )
		end

		lfdrole:Show()
	else
		lfdrole:Hide()
	end
end

local MOVE_UI = false
local function MoveUI()
	if( InCombatLockdown() ) then return end

	if( MOVE_UI ) then
		MOVE_UI = false
	else
		MOVE_UI = true
	end

	local defsize = 16
	local w = tonumber( string.match( ( { GetScreenResolutions() } )[GetCurrentResolution()], "(%d+)x+%d" ) )
	local h = tonumber( string.match( ( { GetScreenResolutions() } )[GetCurrentResolution()], "%d+x(%d+)" ) )
	local x = tonumber( gridsize ) or defsize

	function Grid()
		ali = CreateFrame( "Frame", nil, UIParent )
		ali:SetFrameLevel( 0 )
		ali:SetFrameStrata( "BACKGROUND" )

		for i = - ( w / x / 2 ), w / x / 2 do
			local Aliv = ali:CreateTexture( nil, "BACKGROUND" )
			Aliv:SetTexture( 0.3, 0, 0, 0.7 )
			Aliv:Point( "CENTER", UIParent, "CENTER", i * x, 0 )
			Aliv:SetSize( 1, h )
		end

		for i = - ( h / x / 2 ), h / x / 2 do
			local Alih = ali:CreateTexture( nil, "BACKGROUND" )
			Alih:SetTexture( 0.3, 0, 0, 0.7 )
			Alih:Point( "CENTER", UIParent, "CENTER", 0, i * x )
			Alih:SetSize( w, 1 )
		end
	end

	if( Ali ) then
		if( ox ~= x ) then
			ox = x
			ali:Hide()
			Grid()
			Ali = true
			print( L.Grid_GRID_SHOW )
		else
			ali:Hide()
			print( L.Grid_GRID_HIDE )
			Ali = false
		end
	else
		ox = x
		Grid()
		Ali = true
		print( L.Grid_GRID_SHOW )
	end

	local PanelsToMove = {
		AsphyxiaUIUnitframesPlayerCastbarMover,
		RaidCD,
		MicroAnchormover,
	}

	if( AsphyxiaUIUnitframesPlayerCastbarMover ) then
		if( MOVE_UI ) then
			for _, panels in pairs( PanelsToMove ) do
				panels:Show()
			end
		else
			for _, panels in pairs( PanelsToMove ) do
				panels:Hide()
			end
		end
	end
end

hooksecurefunc( _G.SlashCmdList, "MOVING", MoveUI )