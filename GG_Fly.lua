--// GG SCRIPTS
--// Owner: Ankro
--// Dark Neon UI
--// Fly + Noclip

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer

-- إزالة الواجهة القديمة لو موجودة
local OldGui = Player.PlayerGui:FindFirstChild("GG_SCRIPTS")
if OldGui then
	OldGui:Destroy()
end

--// VARIABLES
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
end)

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
ScreenGui.Parent = Player.PlayerGui

--// MAIN WINDOW
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
MainStroke.Transparency = 0.35
MainStroke.Parent = Main

--// DRAG SYSTEM
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

--// TOP BAR
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

--// CLOSE BUTTON
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
	ScreenGui:Destroy()
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

--// CONTENT
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

--// SIDEBAR BUTTON
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

--// LABEL FUNCTION
local function CreateLabel(Text, Position, Size, TextSize)
	local Label = Instance.new("TextLabel")
	Label.Size = Size
	Label.Position = Position
	Label.BackgroundTransparency = 1
	Label.Text = Text
	Label.TextColor3 = White
	Label.TextSize = TextSize
	Label.Font = Enum.Font.GothamBold
	Label.TextXAlignment = Enum.TextXAlignment.Left
	Label.Parent = HomePage
	return Label
end

--// HOME
CreateLabel(
	"Welcome to GG Scripts",
	UDim2.new(0, 15, 0, 15),
	UDim2.new(1, -30, 0, 45),
	25
)

CreateLabel(
	"Owner: Ankro",
	UDim2.new(0, 15, 0, 65),
	UDim2.new(1, -30, 0, 30),
	16
).TextColor3 = Accent

local HomeInfo = Instance.new("TextLabel")
HomeInfo.Size = UDim2.new(1, -30, 0, 90)
HomeInfo.Position = UDim2.new(0, 15, 0, 115)
HomeInfo.BackgroundTransparency = 1
HomeInfo.Text = "Welcome to your personal utility panel.\nChoose a tool from the sidebar to get started."
HomeInfo.TextColor3 = Gray
HomeInfo.TextSize = 15
HomeInfo.Font = Enum.Font.Gotham
HomeInfo.TextWrapped = true
HomeInfo.TextXAlignment = Enum.TextXAlignment.Left
HomeInfo.Parent = HomePage

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

local function StartFly()
	if not RootPart then return end

	BodyVelocity = Instance.new("BodyVelocity")
	BodyVelocity.MaxForce = Vector3.new(100000, 100000, 100000)
	BodyVelocity.Velocity = Vector3.zero
	BodyVelocity.Parent = RootPart

	BodyGyro = Instance.new("BodyGyro")
	BodyGyro.MaxTorque = Vector3.new(100000, 100000, 100000)
	BodyGyro.P = 10000
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

RunService.RenderStepped:Connect(function()
	if FlyEnabled and BodyVelocity and BodyGyro then
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

		BodyVelocity.Velocity = Direction * FlySpeed
		BodyGyro.CFrame = Camera.CFrame
	end
end)

--// NOCLIP SYSTEM
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
