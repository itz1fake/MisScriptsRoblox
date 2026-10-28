-- ÉXTASIS ESTELAR
-- Archivo: MapRotation.server.lua
-- Ubicación en Roblox Studio: ServerScriptService
--
-- PREPARACIÓN:
-- 1. En ServerStorage crea una carpeta llamada "Maps".
-- 2. Dentro de "Maps", guarda cada mapa como un Model distinto.
-- 3. Cada mapa debe tener al menos un SpawnLocation.
--
-- El servidor elige un mapa aleatorio y lo cambia cada 3 minutos.

local Players = game:GetService("Players")
local ServerStorage = game:GetService("ServerStorage")

local mapsFolder = ServerStorage:WaitForChild("Maps", 15)
if not mapsFolder then
	warn("Falta ServerStorage > Maps. Crea esa carpeta y añade tus mapas.")
	return
end

local currentMapFolder = workspace:FindFirstChild("CurrentMap")
if not currentMapFolder then
	currentMapFolder = Instance.new("Folder")
	currentMapFolder.Name = "CurrentMap"
	currentMapFolder.Parent = workspace
end

local ROUND_LENGTH = 180
local lastMapName = nil

local function getMaps()
	local maps = {}
	for _, item in ipairs(mapsFolder:GetChildren()) do
		if item:IsA("Model") then
			table.insert(maps, item)
		end
	end
	return maps
end

local function movePlayersToSpawn(map)
	local spawns = {}
	for _, item in ipairs(map:GetDescendants()) do
		if item:IsA("SpawnLocation") then
			table.insert(spawns, item)
		end
	end

	if #spawns == 0 then
		warn("El mapa " .. map.Name .. " no tiene SpawnLocation.")
		return
	end

	for _, player in ipairs(Players:GetPlayers()) do
		local character = player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if root then
			local spawnPoint = spawns[math.random(1, #spawns)]
			character:PivotTo(spawnPoint.CFrame + Vector3.new(0, 4, 0))
		end
	end
end

local function loadRandomMap()
	local maps = getMaps()
	if #maps == 0 then
		warn("No hay mapas Model dentro de ServerStorage > Maps.")
		return
	end

	local choices = {}
	for _, map in ipairs(maps) do
		if #maps == 1 or map.Name ~= lastMapName then
			table.insert(choices, map)
		end
	end

	local selected = choices[math.random(1, #choices)]
	currentMapFolder:ClearAllChildren()

	local newMap = selected:Clone()
	newMap.Name = selected.Name
	newMap.Parent = currentMapFolder
	lastMapName = selected.Name

	task.wait(1)
	movePlayersToSpawn(newMap)
	print("Éxtasis Estelar: mapa actual: " .. selected.Name)
end

math.randomseed(os.time())
loadRandomMap()

while true do
	task.wait(ROUND_LENGTH)
	loadRandomMap()
end
