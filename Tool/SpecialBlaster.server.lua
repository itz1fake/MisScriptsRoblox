-- ÉXTASIS ESTELAR
-- Archivo: SpecialBlaster.server.lua
-- Ubicación: dentro de un Tool llamado "SpecialBlaster".
--
-- PREPARACIÓN:
-- 1. Crea un Tool llamado SpecialBlaster en StarterPack.
-- 2. Dentro del Tool, crea una pieza Part llamada Handle.
-- 3. Inserta este Script dentro del Tool.
--
-- Es un bláster inicial: dispara en la dirección hacia la que mira
-- el personaje, hace 25 de daño y tiene un alcance de 250 studs.

local tool = script.Parent
local Players = game:GetService("Players")

local DAMAGE = 25
local RANGE = 250
local COOLDOWN = 0.6
local lastShot = {}

if not tool:IsA("Tool") then
	warn("SpecialBlaster.server.lua debe estar dentro de un Tool.")
	return
end

local function getHumanoidFromHit(hit)
	local current = hit
	while current and current ~= workspace do
		if current:IsA("Model") then
			local humanoid = current:FindFirstChildOfClass("Humanoid")
			if humanoid then
				return humanoid, current
			end
		end
		current = current.Parent
	end
	return nil, nil
end

tool.Activated:Connect(function()
	local character = tool.Parent
	local player = Players:GetPlayerFromCharacter(character)
	if not player then
		return
	end

	local now = os.clock()
	if lastShot[player] and now - lastShot[player] < COOLDOWN then
		return
	end
	lastShot[player] = now

	local head = character:FindFirstChild("Head")
	if not head then
		return
	end

	local origin = head.Position
	local direction = head.CFrame.LookVector * RANGE

	local rayParams = RaycastParams.new()
	rayParams.FilterType = Enum.RaycastFilterType.Exclude
	rayParams.FilterDescendantsInstances = { character }

	local result = workspace:Raycast(origin, direction, rayParams)
	if not result then
		return
	end

	local humanoid, targetModel = getHumanoidFromHit(result.Instance)
	if humanoid and targetModel ~= character and humanoid.Health > 0 then
		humanoid:TakeDamage(DAMAGE)
	end
end)

Players.PlayerRemoving:Connect(function(player)
	lastShot[player] = nil
end)
