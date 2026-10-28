-- ÉXTASIS ESTELAR | Rondas y rotación de mapas
-- Tipo: Script
-- Colócalo en: ServerScriptService
--
-- PREPARACIÓN OBLIGATORIA:
-- 1. Crea ServerStorage > Maps.
-- 2. Dentro de Maps coloca cada mapa como un Model distinto.
-- 3. Cada Model necesita al menos un SpawnLocation.
-- 4. Ancla las piezas del mapa que no deban moverse.
--
-- El servidor selecciona mapas aleatorios, evita repetir el último si puede,
-- mueve a los jugadores a los puntos de aparición y publica el estado de ronda
-- mediante atributos en Workspace: RoundMapName y RoundSecondsLeft.

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local ROUND_SECONDS = 180
local INTERMISSION_SECONDS = 10
local MAPS_FOLDER_NAME = "Maps"
local ACTIVE_FOLDER_NAME = "CurrentMap"

local mapsFolder = ServerStorage:WaitForChild(MAPS_FOLDER_NAME, 30)
if not mapsFolder then
	error("[Éxtasis Estelar] Falta ServerStorage > Maps. Crea la carpeta y coloca mapas dentro.")
end

local activeFolder = workspace:FindFirstChild(ACTIVE_FOLDER_NAME)
if not activeFolder then
	activeFolder = Instance.new("Folder")
	activeFolder.Name = ACTIVE_FOLDER_NAME
	activeFolder.Parent = workspace
end

local activeMap
local lastMapName
local roundStarting = false

local function getMapModels()
	local result = {}
	for _, child in ipairs(mapsFolder:GetChildren()) do
		if child:IsA("Model") then
			table.insert(result, child)
		end
	end
	return result
end

local function getSpawnPoints(map)
	local points = {}
	for _, descendant in ipairs(map:GetDescendants()) do
		if descendant:IsA("SpawnLocation") or descendant.Name == "PlayerSpawn" and descendant:IsA("BasePart") then
			table.insert(points, descendant)
		end
	end
	return points
end

local function teleportCharacter(character, map)
	if not character or not map then return end
	local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 8)
	if not root then return end

	local points = getSpawnPoints(map)
	if #points == 0 then
		warn("[Éxtasis Estelar] El mapa " .. map.Name .. " no tiene SpawnLocation ni BasePart llamada PlayerSpawn.")
		return
	end

	local spawnPoint = points[math.random(1, #points)]
	character:PivotTo(spawnPoint.CFrame + Vector3.new(0, 4, 0))
end

local function teleportAllPlayers(map)
	for _, player in ipairs(Players:GetPlayers()) do
		if player.Character then
			task.spawn(teleportCharacter, player.Character, map)
		end
	end
end

local function loadNextMap()
	local maps = getMapModels()
	if #maps == 0 then
		warn("[Éxtasis Estelar] No hay modelos dentro de ServerStorage > Maps.")
		return false
	end

	local choices = {}
	for _, map in ipairs(maps) do
		if #maps == 1 or map.Name ~= lastMapName then
			table.insert(choices, map)
		end
	end

	local selected = choices[math.random(1, #choices)]
	activeFolder:ClearAllChildren()

	activeMap = selected:Clone()
	activeMap.Name = selected.Name
	activeMap.Parent = activeFolder
	lastMapName = selected.Name

	workspace:SetAttribute("RoundMapName", activeMap.Name)
	teleportAllPlayers(activeMap)
	print("[Éxtasis Estelar] Mapa cargado: " .. activeMap.Name)
	return true
end

Players.PlayerAdded:Connect(function(player)
	player.CharacterAdded:Connect(function(character)
		task.wait(0.5)
		if activeMap then
			teleportCharacter(character, activeMap)
		end
	end)
end)

for _, player in ipairs(Players:GetPlayers()) do
	player.CharacterAdded:Connect(function(character)
		task.wait(0.5)
		if activeMap then
			teleportCharacter(character, activeMap)
		end
	end)
end

math.randomseed(os.time())

while true do
	workspace:SetAttribute("RoundMapName", "Intermission")
	for seconds = INTERMISSION_SECONDS, 1, -1 do
		workspace:SetAttribute("RoundSecondsLeft", seconds)
		task.wait(1)
	end

	if loadNextMap() then
		for seconds = ROUND_SECONDS, 1, -1 do
			workspace:SetAttribute("RoundSecondsLeft", seconds)
			task.wait(1)
		end
	else
		workspace:SetAttribute("RoundSecondsLeft", 0)
		task.wait(5)
	end
end
