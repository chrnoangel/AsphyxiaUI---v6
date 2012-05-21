---------------------------------------------------------------------------------------------
-- AsphyxiaUI
---------------------------------------------------------------------------------------------

local S, C, L, G = unpack( Tukui )

G.Install.Frame:SetTemplate( "Transparent" )

local InstallFrameIconLeft = CreateFrame( "Frame", "InstallFrameIconLeft", G.Install.Frame )
InstallFrameIconLeft:CreatePanel( "Default", 58, 58, "BOTTOMLEFT", G.Install.Frame, "TOPLEFT", 0, 3 )
InstallFrameIconLeft:SetFrameStrata( "HIGH" )
InstallFrameIconLeft:CreateShadow( "Default" )
InstallFrameIconLeft:SetTemplate( "Transparent" )

local InstallFrameIconRight = CreateFrame( "Frame", "InstallFrameIconRight", G.Install.Frame )
InstallFrameIconRight:CreatePanel( "Default", 58, 58, "BOTTOMRIGHT", G.Install.Frame, "TOPRIGHT", 0, 3 )
InstallFrameIconRight:SetFrameStrata( "HIGH" )
InstallFrameIconRight:CreateShadow( "Default" )
InstallFrameIconRight:SetTemplate( "Transparent" )

local InstallFrameTitle = CreateFrame( "Frame", "InstallFrameTitle", G.Install.Frame )
InstallFrameTitle:CreatePanel( nil, G.Install.Frame:GetWidth( ) - 122, 30, "BOTTOM", G.Install.Frame, "TOP", 0, 3 )
InstallFrameTitle:SetFrameStrata( "HIGH" )
InstallFrameTitle:CreateShadow( "Default" )
InstallFrameTitle:SetTemplate( "Transparent" )

local AsphyxiaUIOnLogon = CreateFrame( "Frame" )
AsphyxiaUIOnLogon:RegisterEvent( "PLAYER_ENTERING_WORLD" )
AsphyxiaUIOnLogon:SetScript( "OnEvent", function( self, event )
	self:UnregisterEvent( "PLAYER_ENTERING_WORLD" )

	if( TukuiSaved == nil ) then
		TukuiSaved = {}
		TukuiSaved = {
			["bottomrows"] = 1,
			["rightbars"] = 1,
			["splitbars"] = false,
			["actionbarsLocked"] = false,
		}
	end

	if( C["global"]["welcomemessage"] == true ) then
		print( "L.welcomemessage_1" )
		print( "L.welcomemessage_2" )
	end
end )