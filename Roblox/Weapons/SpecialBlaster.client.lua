-- ÉXTASIS ESTELAR | Bláster especial (cliente)
-- Tipo: LocalScript
-- Colócalo dentro del mismo Tool SpecialBlaster, junto al Script de servidor.
-- Usa el apuntado estándar de Roblox; Activated funciona al hacer clic o tocar
-- el botón de usar herramienta en dispositivos móviles.

local Players = game:GetService("Players")

local player = Players.LocalPlayer
local tool = script.Parent
local remote = tool:WaitForChild("FireRemote", 10)

if not remote then
	warn("[Éxtasis Estelar] No se encontró FireRemote. Revisa el Script de servidor.")
	return
end

local mouse

tool.Equipped:Connect(function()
	mouse = player:GetMouse()
end)

tool.Activated:Connect(function()
	if not mouse then
		mouse = player:GetMouse()
	end

	if mouse and mouse.Hit then
		remote:FireServer(mouse.Hit.Position)
	end
end)

print("[Éxtasis Estelar] Controles del bláster listos.")
