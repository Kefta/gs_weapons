local Empty = function() end
local ReturnTrue = function() return true end
local tScopeTypes = {}

function code_gs.weapons.RegisterScope(sName, func)
	tScopeTypes[sName:lower()] = func
end

function code_gs.weapons.GetScope(sName)
	if (sName == "") then
		return ReturnTrue
	end
	
	return tScopeTypes[sName:lower()] or Empty
end

local matDust = Material("overlays/scope_lens")
local matArc = Material("sprites/scope_arc")
local uv1 = 1/512
local uv2 = 1 - uv1
local vert4 = {{}, {}, {}, {}}

code_gs.weapons.RegisterScope("css", function()
	local iHeight = ScrH()
	local iWidth = ScrW()
	
	// calculate the bounds in which we should draw the scope
	local y = iHeight / 2
	local x = iWidth / 2
	local y1 = iHeight / 16
	local x1 = (iWidth - iHeight) / 2 + y1
	local y2 = iHeight - y1
	local x2 = iWidth - x1
	
	surface.SetMaterial(matDust)
	surface.SetDrawColor(255, 255, 255, 255)
	
	local tVert = vert4[1]
	tVert.x = iWidth
	tVert.y = iHeight
	tVert.u = uv2
	tVert.v = uv1
	
	tVert = vert4[2]
	tVert.x = 0
	tVert.y = iHeight
	tVert.u = uv1
	tVert.v = uv1
	
	tVert = vert4[3]
	tVert.x = 0
	tVert.y = 0
	tVert.u = uv1
	tVert.v = uv2
	
	tVert = vert4[4]
	tVert.x = iWidth
	tVert.y = 0
	tVert.u = uv2
	tVert.v = uv2
	
	surface.DrawPoly(vert4)
	
	surface.SetDrawColor(0, 0, 0, 255)
	
	//Draw the reticle with primitives
	surface.DrawLine(x, 0, x, iHeight)
	surface.DrawLine(0, y, iWidth, y)
	
	// Draw the outline
	surface.SetMaterial(matArc)
	
	-- Major table conservation
	
	-- First quandrant
	--tVert = vect4[4]
	tVert.x = x - 1
	tVert.y = y + 1
	tVert.u = uv1
	tVert.v = uv1
	
	tVert = vert4[1]
	tVert.x = x - 1
	tVert.y = y1 - 1
	tVert.u = uv1
	tVert.v = uv2
	
	tVert = vert4[2]
	tVert.x = x2
	tVert.y = y1 - 1
	tVert.u = uv2
	tVert.v = uv2
	
	tVert = vert4[3]
	tVert.x = x2
	tVert.y = y + 1
	tVert.u = uv2
	tVert.v = uv1
	
	surface.DrawPoly(vert4)
	
	-- Second quandrant
	--tVert = vect4[3]
	tVert.x = x
	tVert.y = y
	tVert.u = uv1
	tVert.v = uv1
	
	tVert = vert4[1]
	tVert.x = x1 - 1
	tVert.y = y1 - 1
	tVert.u = uv2
	tVert.v = uv2
	
	tVert = vert4[2]
	tVert.x = x
	tVert.y = y1 - 1
	tVert.u = uv1
	tVert.v = uv2
	
	tVert = vert4[4]
	tVert.x = x1 - 1
	tVert.y = y
	tVert.u = uv2
	tVert.v = uv1
	
	surface.DrawPoly(vert4)
	
	-- Third quadrant
	--tVert = vect4[4]
	tVert.x = x1 - 1
	tVert.y = y2
	tVert.u = uv2
	tVert.v = uv2
	
	tVert = vert4[1]
	tVert.x = x1 - 1
	tVert.y = y
	tVert.u = uv2
	tVert.v = uv1
	
	tVert = vert4[2]
	tVert.x = x
	tVert.y = y
	tVert.u = uv1
	tVert.v = uv1
	
	tVert = vert4[3]
	tVert.x = x
	tVert.y = y2
	tVert.u = uv1
	tVert.v = uv2
	
	surface.DrawPoly(vert4)
	
	-- Fourth quadrant
	--tVert = vert4[3]
	tVert.x = x2
	tVert.y = y2
	tVert.u = uv2
	tVert.v = uv2
	
	tVert = vert4[1]
	tVert.x = x
	tVert.y = y
	tVert.u = uv1
	tVert.v = uv1
	
	tVert = vert4[2]
	tVert.x = x2
	tVert.y = y
	tVert.u = uv2
	tVert.v = uv1
	
	tVert = vert4[4]
	tVert.x = x
	tVert.y = y2
	tVert.u = uv1
	tVert.v = uv2
	
	surface.DrawPoly(vert4)
	
	surface.DrawRect(0, y1, x1, iHeight) -- Left
	surface.DrawRect(x2, y1, iWidth, iHeight) -- Right
	surface.DrawRect(0, 0, iWidth, y1) -- Top
	surface.DrawRect(0, y2, iWidth, iHeight) -- Bottom
	
	return true
end)
