
local ENT = FindMetaTable("Entity")

function ENT:AddWUMAParent(limit)
	if not IsValid(self) then return end
	self.WUMAParents = istable(self.WUMAParents) and self.WUMAParents or {}

	self.WUMAParents[limit:GetUniqueID()] = limit
	self:CallOnRemove("NotifyWUMAParents", function(ent) ent:NotifyWUMAParents() end)
end

function ENT:RemoveWUMAParent(limit)
	if not IsValid(self) then return end
	self.WUMAParents[limit:GetUniqueID()] = nil
end

function ENT:GetWUMAParents()
	if not IsValid(self) then return end
	return self.WUMAParents
end

local WUMA_Error = "[ALERT] WUMA parent does not have DeleteEntity function! This is a bug, please report it to the author! Prop: %s | Model: %s | Owner: %s | Parent: %s\n"

function ENT:NotifyWUMAParents()
	if not IsValid(self) then return end
	for _, parent in pairs(self:GetWUMAParents()) do

		if parent.DeleteEntity and isfunction(parent.DeleteEntity) then
			parent:DeleteEntity(self:GetCreationID())
		else
			local format = string.format(WUMA_Error, tostring(self) or "NIL", tostring(self:GetModel()) or "NIL", tostring(CPPI and self:CPPIGetOwner() or self:GetOwner()) or "NIL", tostring(parent) or "NIL")
			ErrorNoHalt(format)
		end
	end
end
