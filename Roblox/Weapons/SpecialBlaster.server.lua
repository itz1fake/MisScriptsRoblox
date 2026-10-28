-- ÉXTASIS ESTELAR | Bláster especial (servidor)
-- Tipo: Script
-- Colócalo dentro del Tool llamado SpecialBlaster en StarterPack.
-- El Tool debe contener una Part llamada Handle y un LocalScript llamado SpecialBlaster.client.lua.
-- Este script valida la herramienta, el alcance y la cadencia en el servidor.

local Players = game:GetService("Players")

local tool = script.Parent
if not tool:IsA("Tool") then
	error("[Éxtasis Estelar] SpecialBlaster.server.lua debe estar dentro de un Tool.")
end

tool.RequiresHandle = true
tool.CanBeDropped = false

local DAMAGE = 25
local MAX_RANGE = 250
local COOLDOWN = 0.45
local lastShotAt = {}

local remote = tool:FindFirstChild("FireRemote")
if not remote then
	remote = Instance.new("RemoteEvent")
	remote.Name = "FireRemote"
	remote.Parent = tool
end

local function findHumanoidFromPart(part)
	local current = part
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

remote.OnServerEvent:Connect(function(player, targetPosition)
	if typeof(targetPosition) ~= "Vector3" then return end
	local character = player.Character
	if not character or tool.Parent ~= character then return end

	local now = os.clock()
	if lastShotAt[player] and now - lastShotAt[player] < COOLDOWN then return end
	lastShotAt[player] = now

	local head = character:FindFirstChild("Head")
	if not head then return end

	local origin = head.Position
	local offset = targetPosition - origin
	if offset.Magnitude < 1 then return end
	local direction = offset.Unit * math.min(offset.Magnitude, MAX_RANGE)

	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.FilterDescendantsInstances = { character, tool }
	params.IgnoreWater = true

	local result = workspace:Raycast(origin, direction, params)
	if not result then return end

	local humanoid, targetModel = findHumanoidFromPart(result.Instance)
	if not humanoid or not targetModel or targetModel == character or humanoid.Health <= 0 then return end

	local targetPlayer = Players:GetPlayerFromCharacter(targetModel)
	-- Evita daño entre compañeros cuando los dos jugadores tienen el mismo Team.
	if targetPlayer and player.Team ~= nil and targetPlayer.Team == player.Team then
		return
	end

	humanoid:TakeDamage(DAMAGE)
end)

Players.PlayerRemoving:Connect(function(player)
	lastShotAt[player] = nil
end)

print("[Éxtasis Estelar] Bláster PvP del servidor listo.")
