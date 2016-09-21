include( "shared.lua" )

ENT.Category = "Source" -- Category in the spawn menu the entity should appear in. This must be defined in every entity!
ENT.AutomaticFrameAdvance = false -- Advances animation frames - set to true for animated entities
--ENT.RenderGroup = RENDERGROUP_OPAQUE -- April 2016: "RenderGroup of SENTs and SWEPs is now defaulted to engine default unless overridden ( instead of defaulting to RG_OPAQUE )"