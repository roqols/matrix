local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ESP_COLOR = Color3.fromRGB(33, 7, 145) -- Cor
local toggleKey = Enum.KeyCode.P -- Toggle com a tecla P
local ESP_Enabled = true

local ESPs = {}

local function createESP(character)
    if not character:FindFirstChild("HumanoidRootPart") then return end

    local highlight = Instance.new("Highlight")
    highlight.FillColor = ESP_COLOR
    highlight.OutlineColor = ESP_COLOR
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 1 
    highlight.Parent = character

    ESPs[character] = highlight
end

local function removeESP(character)
    if ESPs[character] then
        ESPs[character]:Destroy()
        ESPs[character] = nil
    end
end

local function updateAllESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if ESP_Enabled and not ESPs[player.Character] then
                createESP(player.Character)
            elseif not ESP_Enabled and ESPs[player.Character] then
                removeESP(player.Character)
            end
        end
    end
end

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("HumanoidRootPart")
        if ESP_Enabled then
            createESP(character)
        end
        character:WaitForChild("Humanoid").Died:Connect(function()
            removeESP(character)
        end)
    end)
end)

for _, player in pairs(Players:GetPlayers()) do
    if player ~= LocalPlayer and player.Character then
        createESP(player.Character)
        player.Character:WaitForChild("Humanoid").Died:Connect(function()
            removeESP(player.Character)
        end)
    end
end

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == toggleKey then
        ESP_Enabled = not ESP_Enabled
        updateAllESP()
        print("ESP:", ESP_Enabled and "Ativado" or "Desativado")
    end
end)

RunService.RenderStepped:Connect(function()
    if ESP_Enabled then
        updateAllESP()
    end
end)
