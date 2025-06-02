local Players = game:GetService("Players")
local userInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()

-- Создаем интерфейс с кнопками W, A, S, D
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "FlightControls"
screenGui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 150, 0, 150)
frame.Position = UDim2.new(0, 10, 1, -160)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BackgroundTransparency = 0.5
frame.Parent = screenGui

local buttonSize = UDim2.new(0, 50, 0, 50)

local btnW = Instance.new("TextButton")
btnW.Size = buttonSize
btnW.Position = UDim2.new(0.5, -25, 0, 0)
btnW.Text = "W"
btnW.Parent = frame

local btnA = Instance.new("TextButton")
btnA.Size = buttonSize
btnA.Position = UDim2.new(0, 0, 0.5, -25)
btnA.Text = "A"
btnA.Parent = frame

local btnS = Instance.new("TextButton")
btnS.Size = buttonSize
btnS.Position = UDim2.new(0.5, -25, 1, -50)
btnS.Text = "S"
btnS.Parent = frame

local btnD = Instance.new("TextButton")
btnD.Size = buttonSize
btnD.Position = UDim2.new(1, -50, 0.5, -25)
btnD.Text = "D"
btnD.Parent = frame

-- Таблица для отслеживания нажатий
local keysDown = {
    W = false,
    A = false,
    S = false,
    D = false
}

-- Обработчики нажатий и отпусканий для кнопок
local function setupButton(btn, key)
    btn.MouseButton1Down:Connect(function()
        keysDown[key] = true
    end)
    btn.MouseButton1Up:Connect(function()
        keysDown[key] = false
    end)
    -- Также, чтобы учесть, если игрок держит кнопку, а потом отпускает, добавим обработку
    btn.MouseButton1Click:Connect(function()
        -- ничего не делаем, чтобы не мешать
    end)
end

setupButton(btnW, "W")
setupButton(btnA, "A")
setupButton(btnS, "S")
setupButton(btnD, "D")

-- Основной цикл движения
local function activateFlight()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local rootPart = character:WaitForChild("HumanoidRootPart")
    local runService = game:GetService("RunService")
    local flying = true

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(1e5, 1e5, 1e5)
    bodyVelocity.Parent = rootPart

    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(1e5, 1e5, 1e5)
    bodyGyro.CFrame = rootPart.CFrame
    bodyGyro.Parent = rootPart

    runService.Heartbeat:Connect(function()
        if not character or not character.Parent then
            -- если персонаж исчез — отключаем
            bodyVelocity:Destroy()
            bodyGyro:Destroy()
            return
        end

        local moveDirection = Vector3.new()

        -- Обработка нажатых клавиш
        if keysDown.W then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.LookVector
        end
        if keysDown.S then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.LookVector
        end
        if keysDown.A then
            moveDirection = moveDirection - workspace.CurrentCamera.CFrame.RightVector
        end
        if keysDown.D then
            moveDirection = moveDirection + workspace.CurrentCamera.CFrame.RightVector
        end

        -- Нормализация и применение скорости
        if moveDirection.Magnitude > 0 then
            moveDirection = moveDirection.Unit * 50
        end
        bodyVelocity.Velocity = moveDirection
        -- Поворот камеры
        bodyGyro.CFrame = workspace.CurrentCamera.CFrame
    end)
end

-- Запускаем управление
activateFlight()
