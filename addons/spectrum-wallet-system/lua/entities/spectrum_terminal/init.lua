AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")


util.AddNetworkString("terminal.request")

function ENT:Initialize()
    self:SetModel("models/hunter/plates/plate025x05.mdl")
    self:PhysicsInit(SOLID_VPHYSICS)

    self:SetMoveType(MOVETYPE_VPHYSICS)
    self:SetSolid(SOLID_VPHYSICS)
    self:SetUseType(SIMPLE_USE)
    
    self:SetMaterial("models/rendertarget")
    // self:SetMaterial("models/shiny")
    // self:SetColor(Color(255, 191, 0))
    

    local phys = self:GetPhysicsObject()

    phys:SetMass(15)
    if (phys:IsValid()) then 
        phys:Wake() 
    end
end 

function ENT:SpawnFunction( ply, tr, ClassName )
    ply:SetNWEntity("owner", ply)


	if ( !tr.Hit ) then return end

	local SpawnPos = tr.HitPos + tr.HitNormal * 16
	local ent = ents.Create( "spectrum_terminal" )

	ent:SetPos( SpawnPos )
	ent:Spawn()
	ent:Activate()

	return ent
end


function ENT:Use(activator, caller)
    if (CurTime() < NextUsing) then return end
    NextUsing = (CurTime() + 1)    
    
    
    net.Start("terminal.request")
    local tbl =  {
        owner = caller:GetNWEntity("owner"),
        user = caller
    }
    net.WriteTable( tbl )  
    net.Send(activator)
end