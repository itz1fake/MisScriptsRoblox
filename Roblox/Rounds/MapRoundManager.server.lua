-- ÉXTASIS ESTELAR | Rondas y rotación de mapas
-- Tipo: Script
-- Ubicación prevista: ServerScriptService
--
-- Preparación necesaria:
-- 1. Crea ServerStorage > Maps.
-- 2. Dentro coloca uno o más Model de mapas.
-- 3. En cada Model, crea una carpeta llamada Spawns.
-- 4. Dentro de Spawns coloca una o más Parts ancladas donde aparecerán los jugadores.
--
-- Este script gestiona temporizador y rotación. No determina ganadores ni crea mapas automáticamente.

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local INTERMISSION_SECONDS = 10
local ROUND_SECONDS = 180
local MAPS_FOLDER_NAME = "Maps"
local CURRENT_MAP_NAME = "CurrentMap"

local function getOrCreateValue(className, name, defaultValue)
	local value = ReplicatedStorage:FindFirstChild(name)
	if not value then
		value = Instance.new(className)
		value.Name = name
		value.Value = defaultValue
		value.Parent = ReplicatedStorage
	end
	return value
end

local roundStatus = getOrCreateValue("StringValue", "RoundStatus", "Preparando")
local timeLeft = getOrCreateValue("IntValue", "RoundTimeLeft", 0)
local currentMapName = getOrCreateValue("StringValue", "CurrentMapName", "")

local function setStatus(message, seconds)
	roundStatus.Value = message
	timeLeft.Value = seconds or 0
end

local function getMaps()
	local folder = ServerStorage:FindFirstChild(MAPS_FOLDER_NAME)
	if not folder then
		warn("Éxtasis Estelar: falta ServerStorage > Maps.")
		return {}
	end

	local maps = {}
	for _, item in folder:GetChildren() do
		if item:IsA("Model") then
			table.insert(maps, item)
		end
	end
	return maps
end

local function teleportPlayersToMap(map)
	local spawnsFolder = map:FindFirstChild("Spawns", true)
	local spawnParts = {}

	if spawnsFolder then
		for _, item in spawnsFolder:GetDescendants() do
			if item:IsA("BasePart") then
				table.insert(spawnParts, item)
			end
		end
	end

	for _, player in Players:GetPlayers() do
		local character = player.Character
		if character then
			local root = character:FindFirstChild("HumanoidRootPart")
			if root then
				if #spawnParts > 0 then
					local spawnPart = spawnParts[math.random(1, #spawnParts)]
					character:PivotTo(spawnPart.CFrame + Vector3.new(0, 3, 0))
				else
					warn("Éxtasis Estelar: el mapa " .. map.Name .. " no tiene Parts en la carpeta Spawns.")
				end
			end
		end
	end
end

local function countdown(message, duration)
	for remaining = duration, 1, -1 do
		setStatus(message, remaining)
		task.wait(1)
	end
	timeLeft.Value = 0
end

while true do
	local maps = getMaps()

	if #maps == 0 then
		currentMapName.Value = ""
		setStatus("Añade mapas en ServerStorage > Maps", 0)
		task.wait(5)
	else
		countdown("Próxima ronda", INTERMISSION_SECONDS)

		local template = maps[math.random(1, #maps)]
		local previousMap = Workspace:FindFirstChild(CURRENT_MAP_NAME)
		if previousMap then
			previousMap:Destroy()
		end

		local activeMap = template:Clone()
		activeMap.Name = CURRENT_MAP_NAME
		activeMap.Parent = Workspace
		currentMapName.Value = template.Name

		task.wait(0.5)
		teleportPlayersToMap(activeMap)
		countdown("Ronda en curso", ROUND_SECONDS)

		setStatus("Ronda terminada", 3)
		task.wait(3)

		if activeMap.Parent then
			activeMap:Destroy()
		end
		currentMapName.Value = ""
	end
end
