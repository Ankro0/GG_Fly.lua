--// GG SCRIPTS
--// Owner: Ankro

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local FlyEnabled = false
local NoclipEnabled = false
local FlySpeed = 50
local FlyKey = Enum.KeyCode.Q

local Character
local Humanoid
local RootPart

local BodyVelocity
local BodyGyro
local OldAutoRotate

local function UpdateCharacter()
	Character = Player.Character or Player.CharacterAdded:Wait()
	Humanoid = Character:WaitForChild("Humanoid")
	RootPart = Character:WaitForChild("HumanoidRootPart")
end

UpdateCharacter()

Player.CharacterAdded:Connect(function()
	FlyEnabled = false
	NoclipEnabled = false

	if BodyVelocity then
		BodyVelocity:Destroy()
		BodyVelocity = nil
	end

	if BodyGyro then
		BodyGyro:Destroy()
		BodyGyro = nil
	end

	task.wait(1)
	UpdateCharacter()
end)

local OldGui = PlayerGui:FindFirstChild("GG_SCRIPTS")
if OldGui then
	OldGui:Destroy()
end

local Background = Color3.fromRGB(13, 13, 20)
local Panel = Color3.fromRGB(20, 20, 31)
local ButtonColor = Color3.fromRGB(30, 30, 45)
local Accent = Color3.fromRGB(145, 80, 255)
local White = Color3.fromRGB(255, 255, 255)
local Gray = Color3.fromRGB(170, 170, 185)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GG_SCRIPTS"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--// FLOATING BUTTON
local FloatingButton = Instance.new("TextButton")
FloatingButton.Size = UDim2.new(0, 60, 0, 60)
FloatingButton.Position = UDim2.new(0, 25, 0.5, -30)
FloatingButton.BackgroundColor3 = Accent
FloatingButton.Text = "GG"
FloatingButton.TextColor3 = White
FloatingButton.TextSize = 18
FloatingButton.Font = Enum.Font.GothamBold
FloatingButton.BorderSizePixel = 0
FloatingButton.ZIndex = 20
FloatingButton.Parent = ScreenGui

local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(1, 0)
FloatCorner.Parent = FloatingButton

--// MAIN
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0, 650, 0, 410)
Main.Position = UDim2.new(0.5, -325, 0.5, -205)
Main.BackgroundColor3 = Background
Main.BorderSizePixel = 0
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 16)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Accent
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

--// TOGGLE UI
local function ToggleUI()
	Main.Visible = not Main.Visible
end

FloatingButton.MouseButton1Click:Connect(ToggleUI)

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if GameProcessed then return end

	if Input.KeyCode == Enum.KeyCode.LeftAlt then
		ToggleUI()
	end
end)

--// DRAG FLOATING BUTTON
local DraggingButton = false
local ButtonStart
local ButtonPosition

FloatingButton.InputBegan:Connect(function(Input)
	if Input.UserInputType == Enum.UserInputType.MouseButton1
		or Input.UserInputType == Enum.UserInputType.Touch then

		DraggingButton = true
		ButtonStart = Input.Position
		ButtonPosition = FloatingButton.Position
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
		local Delta = Input.Position - ButtonStart

		FloatingButton.Position = UDim2.new(
			ButtonPosition.X.Scale,
			ButtonPosition.X.Offset + Delta.X,
			ButtonPosition.Y.Scale,
			ButtonPosition.Y.Offset + Delta.Y
		)
	end
end)

--// TITLE
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -80, 0, 40)
Title.Position = UDim2.new(0, 22, 0, 8)
Title.BackgroundTransparency = 1
Title.Text = "GG SCRIPTS"
Title.TextColor3 = White
Title.TextSize = 25
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = Main

local Subtitle = Instance.new("TextLabel")
Subtitle.Size = UDim2.new(1, -80, 0, 25)
Subtitle.Position = UDim2.new(0, 24, 0, 38)
Subtitle.BackgroundTransparency = 1
Subtitle.Text = "Owner: Ankro"
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
	Btn.BackgroundColor3 = ButtonColor
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
FlyTitle.Size = UDim2.new(1, -30, 0, 40)
FlyTitle.Position = UDim2.new(0, 15, 0, 10)
FlyTitle.BackgroundTransparency = 1
FlyTitle.Text = "✈  Fly Control"
FlyTitle.TextColor3 = White
FlyTitle.TextSize = 24
FlyTitle.Font = Enum.Font.GothamBold
FlyTitle.TextXAlignment = Enum.TextXAlignment.Left
FlyTitle.Parent = FlyPage

local FlyStatus = Instance.new("TextLabel")
FlyStatus.Size = UDim2.new(1, -30, 0, 25)
FlyStatus.Position = UDim2.new(0, 15, 0, 50)
FlyStatus.BackgroundTransparency = 1
FlyStatus.Text = "Status: OFF"
FlyStatus.TextColor3 = Gray
FlyStatus.TextSize = 15
FlyStatus.Parent = FlyPage

local FlyToggle = Instance.new("TextButton")
FlyToggle.Size = UDim2.new(1, -30, 0, 50)
FlyToggle.Position = UDim2.new(0, 15, 0, 85)
FlyToggle.BackgroundColor3 = ButtonColor
FlyToggle.Text = "ENABLE FLY"
FlyToggle.TextColor3 = White
FlyToggle.TextSize = 16
FlyToggle.Font = Enum.Font.GothamBold
FlyToggle.BorderSizePixel = 0
FlyToggle.Parent = FlyPage

local FlyCorner = Instance.new("UICorner")
FlyCorner.CornerRadius = UDim.new(0, 10)
FlyCorner.Parent = FlyToggle

--// SPEED
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(1, -30, 0, 25)
SpeedLabel.Position = UDim2.new(0, 15, 0, 150)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Fly Speed: 50 / 100"
SpeedLabel.TextColor3 = White
SpeedLabel.TextSize = 15
SpeedLabel.Font = Enum.Font.GothamBold
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = FlyPage

local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1, -30, 0, 42)
SpeedBox.Position = UDim2.new(0, 15, 0, 180)
SpeedBox.BackgroundColor3 = ButtonColor
SpeedBox.Text = "50"
SpeedBox.TextColor3 = White
SpeedBox.TextSize = 16
SpeedBox.Font = Enum.Font.GothamBold
SpeedBox.ClearTextOnFocus = false
SpeedBox.BorderSizePixel = 0
SpeedBox.Parent = FlyPage

SpeedBox.FocusLost:Connect(function()
	local Value = tonumber(SpeedBox.Text)

	if Value then
		FlySpeed = math.clamp(Value, 1, 100)
	end

	SpeedBox.Text = tostring(FlySpeed)
	SpeedLabel.Text = "Fly Speed: " .. FlySpeed .. " / 100"
end)

--// KEY
local KeyLabel = Instance.new("TextLabel")
KeyLabel.Size = UDim2.new(1, -30, 0, 25)
KeyLabel.Position = UDim2.new(0, 15, 0, 235)
KeyLabel.BackgroundTransparency = 1
KeyLabel.Text = "Fly Key: Q"
KeyLabel.TextColor3 = White
KeyLabel.TextSize = 15
KeyLabel.Font = Enum.Font.GothamBold
KeyLabel.TextXAlignment = Enum.TextXAlignment.Left
KeyLabel.Parent = FlyPage

local KeyBox = Instance.new("TextBox")
KeyBox.Size = UDim2.new(1, -30, 0, 42)
KeyBox.Position = UDim2.new(0, 15, 0, 265)
KeyBox.BackgroundColor3 = ButtonColor
KeyBox.Text = "Q"
KeyBox.TextColor3 = White
KeyBox.TextSize = 16
KeyBox.Font = Enum.Font.GothamBold
KeyBox.ClearTextOnFocus = false
KeyBox.BorderSizePixel = 0
KeyBox.Parent = FlyPage

KeyBox.FocusLost:Connect(function()
	local Text = string.upper(KeyBox.Text)

	if #Text == 1 and Enum.KeyCode[Text] then
		FlyKey = Enum.KeyCode[Text]
		KeyBox.Text = Text
		KeyLabel.Text = "Fly Key: " .. Text
	else
		KeyBox.Text = FlyKey.Name
		KeyLabel.Text = "Fly Key: " .. FlyKey.Name
	end
end)

--// NOCLIP
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
NoclipStatus.Parent = NoclipPage

local NoclipToggle = Instance.new("TextButton")
NoclipToggle.Size = UDim2.new(1, -30, 0, 50)
NoclipToggle.Position = UDim2.new(0, 15, 0, 105)
NoclipToggle.BackgroundColor3 = ButtonColor
NoclipToggle.Text = "ENABLE NOCLIP"
NoclipToggle.TextColor3 = White
NoclipToggle.TextSize = 16
NoclipToggle.Font = Enum.Font.GothamBold
NoclipToggle.BorderSizePixel = 0
NoclipToggle.Parent = NoclipPage

--// FLY
local function StartFly()
	if not Character or not Humanoid or not RootPart then
		return
	end

	OldAutoRotate = Humanoid.AutoRotate
	Humanoid.AutoRotate = false

	BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
	BodyVelocity.P = 100000
	BodyVelocity.Velocity = Vector3.new(0, 3, 0)
	BodyVelocity.Parent = RootPart

	BodyGyro = Instance.new("BodyGyro")
	BodyGyro.MaxTorque = Vector3.new(0, math.huge, 0)
	BodyGyro.P = 1000000
	BodyGyro.D = 0
	BodyGyro.CFrame = RootPart.CFrame
	BodyGyro.Parent = RootPart

	Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
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

local function ToggleFly()
	FlyEnabled = not FlyEnabled

	if FlyEnabled then
		FlyToggle.Text = "DISABLE FLY"
		FlyStatus.Text = "Status: ON"
		StartFly()
	else
		FlyToggle.Text = "ENABLE FLY"
		FlyStatus.Text = "Status: OFF"
		StopFly()
	end
end

FlyToggle.MouseButton1Click:Connect(ToggleFly)

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if GameProcessed then return end

	if Input.KeyCode == FlyKey then
		ToggleFly()
	end
end)

--// FLY MOVEMENT
RunService.RenderStepped:Connect(function()
	if not FlyEnabled or not BodyVelocity or not BodyGyro then
		return
	end

	if not RootPart then
		return
	end

	local Camera = workspace.CurrentCamera

	local Look = Camera.CFrame.LookVector
	local FlatLook = Vector3.new(Look.X, 0, Look.Z)

	if FlatLook.Magnitude > 0 then
		FlatLook = FlatLook.Unit
	end

	local Right = Camera.CFrame.RightVector
	local FlatRight = Vector3.new(Right.X, 0, Right.Z)

	if FlatRight.Magnitude > 0 then
		FlatRight = FlatRight.Unit
	end

	local Direction = Vector3.zero

	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		Direction += FlatLook
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		Direction -= FlatLook
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		Direction -= FlatRight
	end

	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		Direction += FlatRight
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
		Direction = Vector3.new(0, 2, 0)
	end

	BodyVelocity.Velocity = Direction

	if FlatLook.Magnitude > 0 then
		BodyGyro.CFrame = CFrame.new(
			RootPart.Position,
			RootPart.Position + FlatLook
		)
	end

	Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
end)

--// NOCLIP
NoclipToggle.MouseButton1Click:Connect(function()
	NoclipEnabled = not NoclipEnabled

	if NoclipEnabled then
		NoclipToggle.Text = "DISABLE NOCLIP"
		NoclipStatus.Text = "Status: ON"
	else
		NoclipToggle.Text = "ENABLE NOCLIP"
		NoclipStatus.Text = "Status: OFF"
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
