-- ÉXTASIS ESTELAR | Estadísticas básicas
-- Tipo: Script
-- Ubicación prevista: ServerScriptService
-- Esta versión crea Coins y Wins, pero todavía NO los guarda entre sesiones.

local Players = game:GetService("Players")

local function setupPlayer(player)
	local leaderstats = player:FindFirstChild("leaderstats")
	if not leaderstats then
		leaderstats = Instance.new("Folder")
		leaderstats.Name = "leaderstats"
		leaderstats.Parent = player
	end

	local coins = leaderstats:FindFirstChild("Coins")
	if not coins then
		coins = Instance.new("IntValue")
		coins.Name = "Coins"
		coins.Value = 0
		coins.Parent = leaderstats
	end

	local wins = leaderstats:FindFirstChild("Wins")
	if not wins then
		wins = Instance.new("IntValue")
		wins.Name = "Wins"
		wins.Value = 0
		wins.Parent = leaderstats
	end
end

Players.PlayerAdded:Connect(setupPlayer)

-- Cubre también jugadores que ya estuvieran conectados al iniciar el script.
for _, player in Players:GetPlayers() do
	setupPlayer(player)
end
