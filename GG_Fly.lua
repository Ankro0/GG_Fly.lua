--// GG SCRIPTS
--// Owner: Ankro
--// Fly + Noclip
--// Floating Toggle Button

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// SETTINGS
local FlyEnabled = false
local NoclipEnabled = false
local FlySpeed = 50

local Character
local Humanoid
local RootPart

local function UpdateCharacter()
	Character = Player.Character or Player.CharacterAdded:Wait()
	Humanoid = Character:WaitForChild("Humanoid")
	RootPart = Character:WaitForChild("HumanoidRootPart")
end

UpdateCharacter()

Player.CharacterAdded:Connect(function()
	task.wait(1)
	UpdateCharacter()

	if FlyEnabled then
		FlyEnabled = false
	end
end)

--// REMOVE OLD GUI
local OldGui = PlayerGui:FindFirstChild("GG_SCRIPTS")
if OldGui then
	OldGui:Destroy()
end

--// COLORS
local Background = Color3.fromRGB(13, 13, 20)
local Panel = Color3.fromRGB(20, 20, 31)
local Button = Color3.fromRGB(30, 30, 45)
local Accent = Color3.fromRGB(145, 80, 255)
local White = Color3.fromRGB(255, 255, 255)
local Gray = Color3.fromRGB(170, 170, 185)

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GG_SCRIPTS"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--// FLOATING BUTTON
local FloatingButton = Instance.new("TextButton")
FloatingButton.Name = "GG_FloatingButton"
FloatingButton.Size = UDim2.new(0, 58, 0, 58)
FloatingButton.Position = UDim2.new(0, 25, 0.5, -29)
FloatingButton.BackgroundColor3 = Accent
FloatingButton.Text = "GG"
FloatingButton.TextColor3 = White
FloatingButton.TextSize = 18
FloatingButton.Font = Enum.Font.GothamBold
FloatingButton.BorderSizePixel = 0
FloatingButton.ZIndex = 10
FloatingButton.Parent = ScreenGui

local FloatingCorner = Instance.new("UICorner")
FloatingCorner.CornerRadius = UDim.new(1, 0)
FloatingCorner.Parent = FloatingButton

local FloatingStroke = Instance.new("UIStroke")
FloatingStroke.Color = White
FloatingStroke.Transparency = 0.7
FloatingStroke.Thickness = 1.5
FloatingStroke.Parent = FloatingButton

--// DRAG FLOATING BUTTON
local DraggingButton = false
local ButtonDragStart
local ButtonStartPosition

FloatingButton.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then

		DraggingButton = true
		ButtonDragStart = Input.Position
		ButtonStartPosition = FloatingButton.Position
	end
end)

FloatingButton.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then

		DraggingButton = false
	end
end)

UserInputService.InputChanged:Connect(function(Input)
	if DraggingButton then
		if Input.UserInputType == Enum.UserInputType.MouseMovement
			or Input.UserInputType == Enum.UserInputType.Touch then

			local Delta = Input.Position - ButtonDragStart

			FloatingButton.Position = UDim2.new(
				ButtonStartPosition.X.Scale,
				ButtonStartPosition.X.Offset + Delta.X,
				ButtonStartPosition.Y.Scale,
				ButtonStartPosition.Y.Offset + Delta.Y
			)
		end
	end
end)

--// MAIN WINDOW
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 650, 0, 410)
Main.Position = UDim2.new(0.5, -325, 0.5, -205)
Main.BackgroundColor3 = Background
Main.BorderSizePixel = 0
Main.Visible = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Accent
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.35
MainStroke.Parent = Main

--// SHOW/HIDE UI
FloatingButton.MouseButton1Click:Connect(function()
	Main.Visible = not Main.Visible
end)

--// DRAG MAIN WINDOW
local Dragging = false
local DragStart
local StartPosition

Main.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = true
		DragStart = Input.Position
		StartPosition = Main.Position
	end
end)

Main.InputEnded:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1 then
		Dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(Input)
	if Dragging and Input.UserInputType == Enum.UserInputType.MouseMovement then
		local Delta = Input.Position - DragStart

		Main.Position = UDim2.new(
			StartPosition.X.Scale,
			StartPosition.X.Offset + Delta.X,
			StartPosition.Y.Scale,
			StartPosition.Y.Offset + Delta.Y
		)
	end
end)

--// TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 55)
Title.Position = UDim2.new(0, 22, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "GG SCRIPTS"
Title.TextColor3 = White
Title.TextSize = 25
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -80, 0, 25)
Subtitle.Position = UDim2.new(0, 24, 0, 35)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Ankro's Utility Panel"
Subtitle.TextColor3 = Gray
Subtitle.TextSize = 12
Subtitle.Font = Enum.Font.Gotham
Subtitle.TextXAlignment = Enum.TextXAlignment.Left
Subtitle.Parent = Main

--// CLOSE
local Close = Instance.new("TextButton")
Close.Size = UDim2.new(0, 38, 0, 38)
Close.Position = UDim2.new(1, -52, 0, 14)
Close.BackgroundColor3 = Color3.fromRGB(45, 25, 45)
Close.Text = "×"
Close.TextColor3 = White
Close.TextSize = 25
Close.Font = Enum.Font.GothamBold
Close.BorderSizePixel = 0
Close.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 10)
CloseCorner.Parent = Close

Close.MouseButton1Click:Connect(function()
	Main.Visible = false
end)

--// SIDEBAR
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 125, 1, -80)
Sidebar.Position = UDim2.new(0, 15, 0, 70)
Sidebar.BackgroundColor3 = Panel
Sidebar.BorderSizePixel = 0
Sidebar.Parent = Main

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 13)
SidebarCorner.Parent = Sidebar

local Content = Instance.new("Frame")
Content.Size = UDim2.new(1, -165, 1, -80)
Content.Position = UDim2.new(0, 150, 0, 70)
Content.BackgroundTransparency = 1
Content.Parent = Main

local Pages = {}

local function CreatePage(Name)
	local Page = Instance.new("Frame")
	Page.Name = Name
	Page.Size = UDim2.new(1, 0, 1, 0)
	Page.BackgroundTransparency = 1
	Page.Visible = false
	Page.Parent = Content

	Pages[Name] = Page
	return Page
end

local HomePage = CreatePage("Home")
local FlyPage = CreatePage("Fly")
local NoclipPage = CreatePage("Noclip")

HomePage.Visible = true

local function SwitchPage(Name)
	for PageName, Page in pairs(Pages) do
		Page.Visible = PageName == Name
	end
end

local function CreateSideButton(Text, Icon, Position)
	local Btn = Instance.new("TextButton")
	Btn.Size = UDim2.new(1, -20, 0, 58)
	Btn.Position = Position
	Btn.BackgroundColor3 = Button
	Btn.Text = Icon .. "  " .. Text
	Btn.TextColor3 = White
	Btn.TextSize = 14
	Btn.Font = Enum.Font.GothamBold
	Btn.BorderSizePixel = 0
	Btn.Parent = Sidebar

	local Corner = Instance.new("UICorner")
	Corner.CornerRadius = UDim.new(0, 10)
	Corner.Parent = Btn

	return Btn
end

local HomeButton = CreateSideButton("Home", "⌂", UDim2.new(0, 10, 0, 15))
local FlyButton = CreateSideButton("Fly", "✈", UDim2.new(0, 10, 0, 83))
local NoclipButton = CreateSideButton("Noclip", "◈", UDim2.new(0, 10, 0, 151))

HomeButton.MouseButton1Click:Connect(function()
	SwitchPage("Home")
end)

FlyButton.MouseButton1Click:Connect(function()
	SwitchPage("Fly")
end)

NoclipButton.MouseButton1Click:Connect(function()
	SwitchPage("Noclip")
end)

--// HOME
local HomeTitle = Instance.new("TextLabel")
HomeTitle.Size = UDim2.new(1, -30, 0, 45)
HomeTitle.Position = UDim2.new(0, 15, 0, 15)
HomeTitle.BackgroundTransparency = 1
HomeTitle.Text = "Welcome to GG Scripts"
HomeTitle.TextColor3 = White
HomeTitle.TextSize = 25
HomeTitle.Font = Enum.Font.GothamBold
HomeTitle.TextXAlignment = Enum.TextXAlignment.Left
HomeTitle.Parent = HomePage

local Owner = Instance.new("TextLabel")
Owner.Size = UDim2.new(1, -30, 0, 30)
Owner.Position = UDim2.new(0, 15, 0, 65)
Owner.BackgroundTransparency = 1
Owner.Text = "Owner: Ankro"
Owner.TextColor3 = Accent
Owner.TextSize = 16
Owner.Font = Enum.Font.GothamBold
Owner.TextXAlignment = Enum.TextXAlignment.Left
Owner.Parent = HomePage

--// FLY PAGE
local FlyTitle = Instance.new("TextLabel")
FlyTitle.Size = UDim2.new(1, -30, 0, 45)
FlyTitle.Position = UDim2.new(0, 15, 0, 15)
FlyTitle.BackgroundTransparency = 1
FlyTitle.Text = "✈  Fly Control"
FlyTitle.TextColor3 = White
FlyTitle.TextSize = 25
FlyTitle.Font = Enum.Font.GothamBold
FlyTitle.TextXAlignment = Enum.TextXAlignment.Left
FlyTitle.Parent = FlyPage

local FlyStatus = Instance.new("TextLabel")
FlyStatus.Size = UDim2.new(1, -30, 0, 30)
FlyStatus.Position = UDim2.new(0, 15, 0, 60)
FlyStatus.BackgroundTransparency = 1
FlyStatus.Text = "Status: OFF"
FlyStatus.TextColor3 = Gray
FlyStatus.TextSize = 15
FlyStatus.Font = Enum.Font.Gotham
FlyStatus.TextXAlignment = Enum.TextXAlignment.Left
FlyStatus.Parent = FlyPage

local FlyToggle = Instance.new("TextButton")
FlyToggle.Size = UDim2.new(1, -30, 0, 50)
FlyToggle.Position = UDim2.new(0, 15, 0, 100)
FlyToggle.BackgroundColor3 = Button
FlyToggle.Text = "ENABLE FLY"
FlyToggle.TextColor3 = White
FlyToggle.TextSize = 16
FlyToggle.Font = Enum.Font.GothamBold
FlyToggle.BorderSizePixel = 0
FlyToggle.Parent = FlyPage

local FlyCorner = Instance.new("UICorner")
FlyCorner.CornerRadius = UDim.new(0, 10)
FlyCorner.Parent = FlyToggle

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -30, 0, 30)
SpeedLabel.Position = UDim2.new(0, 15, 0, 170)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Fly Speed: 50 / 100"
SpeedLabel.TextColor3 = White
SpeedLabel.TextSize = 16
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = FlyPage

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, -30, 0, 45)
SpeedBox.Position = UDim2.new(0, 15, 0, 210)
SpeedBox.BackgroundColor3 = Button
SpeedBox.Text = "50"
SpeedBox.TextColor3 = White
SpeedBox.TextSize = 16
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.ClearTextOnFocus = false
SpeedBox.BorderSizePixel = 0
SpeedBox.Parent = FlyPage

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 10)
SpeedCorner.Parent = SpeedBox

SpeedBox.FocusLost:Connect(function()
	local Value = tonumber(SpeedBox.Text)

	if Value then
		FlySpeed = math.clamp(Value, 1, 100)
	end

	SpeedBox.Text = tostring(FlySpeed)
	SpeedLabel.Text = "Fly Speed: " .. FlySpeed .. " / 100"
end)

--// NOCLIP PAGE
local NoclipTitle = Instance.new("TextLabel")
NoclipTitle.Size = UDim2.new(1, -30, 0, 45)
NoclipTitle.Position = UDim2.new(0, 15, 0, 15)
NoclipTitle.BackgroundTransparency = 1
NoclipTitle.Text = "◈  Noclip Control"
NoclipTitle.TextColor3 = White
NoclipTitle.TextSize = 25
NoclipTitle.Font = Enum.Font.GothamBold
NoclipTitle.TextXAlignment = Enum.TextXAlignment.Left
NoclipTitle.Parent = NoclipPage

local NoclipStatus = Instance.new("TextLabel")
NoclipStatus.Size = UDim2.new(1, -30, 0, 30)
NoclipStatus.Position = UDim2.new(0, 15, 0, 65)
NoclipStatus.BackgroundTransparency = 1
NoclipStatus.Text = "Status: OFF"
NoclipStatus.TextColor3 = Gray
NoclipStatus.TextSize = 15
NoclipStatus.Font = Enum.Font.Gotham
NoclipStatus.TextXAlignment = Enum.TextXAlignment.Left
NoclipStatus.Parent = NoclipPage

local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(1, -30, 0, 50)
NoclipToggle.Position = UDim2.new(0, 15, 0, 105)
NoclipToggle.BackgroundColor3 = Button
NoclipToggle.Text = "ENABLE NOCLIP"
NoclipToggle.TextColor3 = White
NoclipToggle.TextSize = 16
NoclipToggle.Font = Enum.Font.GothamBold
NoclipToggle.BorderSizePixel = 0
NoclipToggle.Parent = NoclipPage

local NoclipCorner = Instance.new("UICorner")
NoclipCorner.CornerRadius = UDim.new(0, 10)
NoclipCorner.Parent = NoclipToggle

--// FLY SYSTEM
local BodyVelocity
local BodyGyro
local OldAutoRotate

local function StartFly()
	if not Character or not Humanoid or not RootPart then
		return
	end

	OldAutoRotate = Humanoid.AutoRotate

	-- منع حالة السقوط
	Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
	Humanoid.AutoRotate = false

	BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	BodyVelocity.P = 10000
	BodyVelocity.Velocity = Vector3.zero
	BodyVelocity.Parent = RootPart

	BodyGyro = Instance.new("BodyGyro")
	BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
	BodyGyro.P = 10000
	BodyGyro.D = 500
	BodyGyro.CFrame = RootPart.CFrame
	BodyGyro.Parent = RootPart
end

local function StopFly()
	if BodyVelocity then
		BodyVelocity:Destroy()
		BodyVelocity = nil
	end

	if BodyGyro then
		BodyGyro:Destroy()
		BodyGyro = nil
	end

	if Humanoid then
		Humanoid.AutoRotate = OldAutoRotate ~= nil and OldAutoRotate or true
		Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end

FlyToggle.MouseButton1Click:Connect(function()
	FlyEnabled = not FlyEnabled

	if FlyEnabled then
		FlyToggle.Text = "DISABLE FLY"
		FlyStatus.Text = "Status: ON"
		FlyStatus.TextColor3 = Accent

		StartFly()
	else
		FlyToggle.Text = "ENABLE FLY"
		FlyStatus.Text = "Status: OFF"
		FlyStatus.TextColor3 = Gray

		StopFly()
	end
end)

--// FLY MOVEMENT
RunService.RenderStepped:Connect(function()
	if not FlyEnabled or not BodyVelocity or not BodyGyro then
		return
	end

	if not Character or not Humanoid or not RootPart then
		return
	end

	local Camera = workspace.CurrentCamera
	local Direction = Vector3.zero

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		Direction += Camera.CFrame.LookVector
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		Direction -= Camera.CFrame.LookVector
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		Direction -= Camera.CFrame.RightVector
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		Direction += Camera.CFrame.RightVector
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
		Direction += Vector3.new(0, 1, 0)
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
		Direction -= Vector3.new(0, 1, 0)
	end

	if Direction.Magnitude > 0 then
		Direction = Direction.Unit * FlySpeed
	else
		Direction = Vector3.zero
	end

	BodyVelocity.Velocity = Direction

	-- اتجاه الشخصية مع الكاميرا
	BodyGyro.CFrame = CFrame.new(
		RootPart.Position,
		RootPart.Position + Camera.CFrame.LookVector
	)

	Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
end)

--// NOCLIP
NoclipToggle.MouseButton1Click:Connect(function()
	NoclipEnabled = not NoclipEnabled

	if NoclipEnabled then
		NoclipToggle.Text = "DISABLE NOCLIP"
		NoclipStatus.Text = "Status: ON"
		NoclipStatus.TextColor3 = Accent
	else
		NoclipToggle.Text = "ENABLE NOCLIP"
		NoclipStatus.Text = "Status: OFF"
		NoclipStatus.TextColor3 = Gray
	end
end)

RunService.Stepped:Connect(function()
	if NoclipEnabled and Character then
		for _, Object in ipairs(Character:GetDescendants()) do
			if Object:IsA("BasePart") then
				Object.CanCollide = false
			end
		end
	end
end)

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if GameProcessed then return end

	if Input.KeyCode == Enum.KeyCode.LeftAlt then
		Main.Visible = not Main.Visible
	end
end)
