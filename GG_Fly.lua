--// GG FLIGHT SYSTEM
--// For your own Roblox experience / Roblox Studio

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local FlyEnabled = false
local FlySpeed = 60
local FlyKey = Enum.KeyCode.Q

local Character
local Humanoid
local RootPart

local Attachment
local LinearVelocity
local AlignOrientation

local function UpdateCharacter()
	Character = Player.Character or Player.CharacterAdded:Wait()
	Humanoid = Character:WaitForChild("Humanoid")
	RootPart = Character:WaitForChild("HumanoidRootPart")
end

UpdateCharacter()

--==================================================
-- FLY START
--==================================================

local function StartFly()
	if not RootPart or not Humanoid then
		return
	end

	Attachment = Instance.new("Attachment")
	Attachment.Name = "GG_FlyAttachment"
	Attachment.Parent = RootPart

	LinearVelocity = Instance.new("LinearVelocity")
	LinearVelocity.Name = "GG_FlyVelocity"
	LinearVelocity.Attachment0 = Attachment
	LinearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
	LinearVelocity.MaxForce = math.huge
	LinearVelocity.VectorVelocity = Vector3.zero
	LinearVelocity.Parent = RootPart

	AlignOrientation = Instance.new("AlignOrientation")
	AlignOrientation.Name = "GG_FlyOrientation"
	AlignOrientation.Attachment0 = Attachment
	AlignOrientation.Mode = Enum.OrientationAlignmentMode.OneAttachment
	AlignOrientation.MaxTorque = math.huge
	AlignOrientation.MaxAngularVelocity = math.huge
	AlignOrientation.Responsiveness = 200
	AlignOrientation.Parent = RootPart

	Humanoid.AutoRotate = false
	Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
end

--==================================================
-- FLY STOP
--==================================================

local function StopFly()
	if LinearVelocity then
		LinearVelocity:Destroy()
		LinearVelocity = nil
	end

	if AlignOrientation then
		AlignOrientation:Destroy()
		AlignOrientation = nil
	end

	if Attachment then
		Attachment:Destroy()
		Attachment = nil
	end

	if Humanoid then
		Humanoid.AutoRotate = true
		Humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	end
end

--==================================================
-- FLY MOVEMENT
--==================================================

RunService.RenderStepped:Connect(function()
	if not FlyEnabled then
		return
	end

	if not LinearVelocity or not AlignOrientation then
		return
	end

	if not RootPart or not Humanoid then
		return
	end

	local Camera = workspace.CurrentCamera
	local CameraCFrame = Camera.CFrame

	local Direction = Vector3.zero

	-- W = اتجاه الكاميرا بالكامل
	if UserInputService:IsKeyDown(Enum.KeyCode.W) then
		Direction += CameraCFrame.LookVector
	end

	-- S
	if UserInputService:IsKeyDown(Enum.KeyCode.S) then
		Direction -= CameraCFrame.LookVector
	end

	-- A
	if UserInputService:IsKeyDown(Enum.KeyCode.A) then
		Direction -= CameraCFrame.RightVector
	end

	-- D
	if UserInputService:IsKeyDown(Enum.KeyCode.D) then
		Direction += CameraCFrame.RightVector
	end

	-- Space للصعود
	if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
		Direction += Vector3.new(0, 1, 0)
	end

	-- LeftControl للنزول
	if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
		Direction -= Vector3.new(0, 1, 0)
	end

	if Direction.Magnitude > 0 then
		Direction = Direction.Unit * FlySpeed
	end

	-- الحركة الفعلية في العالم
	LinearVelocity.VectorVelocity = Direction

	-- دوران الشخصية مع اتجاه الكاميرا بالكامل
	AlignOrientation.CFrame = CameraCFrame

	Humanoid:ChangeState(Enum.HumanoidStateType.Physics)
end)

--==================================================
-- TOGGLE
--==================================================

local function ToggleFly()
	FlyEnabled = not FlyEnabled

	if FlyEnabled then
		StartFly()
	else
		StopFly()
	end
end

UserInputService.InputBegan:Connect(function(Input, GameProcessed)
	if GameProcessed then
		return
	end

	if Input.KeyCode == FlyKey then
		ToggleFly()
	end
end)

--==================================================
-- CHARACTER RESPAWN
--==================================================

Player.CharacterAdded:Connect(function()
	FlyEnabled = false

	task.wait(1)
	UpdateCharacter()
end)
