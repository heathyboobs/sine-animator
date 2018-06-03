local history = game:service('ChangeHistoryService')
local input = game:service('UserInputService')
local toolbar = plugin:CreateToolbar("sine animator")
local button = toolbar:CreateButton("sine animator", "animate things. sincerely, heather.", "")

local gui = nil
local messages = Instance.new('ScreenGui', game:service('CoreGui'))
messages.Name = "sine animator messages"
local textlabel = Instance.new('TextLabel', messages)
textlabel.Size = UDim2.new(1,0,1,0)
textlabel.BackgroundTransparency = 1
textlabel.ZIndex = 100
textlabel.Font = 'Arial'
textlabel.Text = ''
textlabel.TextColor3 = Color3.new()
textlabel.TextSize = 18
textlabel.Visible = false
function success_message(text)
	textlabel.Text = "[success] " .. text
	textlabel.Visible = true
	for i = 1, 100 do
		local stamp = math.sin(tick()*16)/2+.5
		textlabel.TextColor3 = Color3.new(stamp*(89/255), stamp*(237/255), stamp*(75/255))
		wait(.05)
	end
	textlabel.Visible = false
end
function error_message(text)
	textlabel.Text = "[error] " .. text
	textlabel.Visible = true
	for i = 1, 100 do
		local stamp = math.sin(tick()*16)/2+.5
		textlabel.TextColor3 = Color3.new(stamp*(244/255), stamp*(31/255), stamp*(31/255))
		wait(.05)
	end
	textlabel.Visible = false
end

function showWindow(bool)
	if gui then
		gui.WINDOW.Visible = bool
		if bool then
			gui.TAB.minmax.Text = 'min'
			gui.TAB.BorderSizePixel = 0
		else
			gui.TAB.minmax.Text = 'max'
			gui.TAB.BorderSizePixel = 1
		end
	end
end

button.Click:connect(function()
	history:SetEnabled(true)
	if not gui then
		gui = game:service('StarterGui')['sine animator']
		if gui then
			gui.Parent = game:service('CoreGui')
			
			gui.TAB.minmax.MouseButton1Click:connect(function()
				showWindow(not gui.WINDOW.Visible)
			end)
			
			gui.TAB.close.MouseButton1Click:connect(function()
				gui.TAB.Visible = false
				gui.WINDOW.Visible = false
			end)
			showWindow(false)
			gui.TAB.Visible = true
			gui.TAB.BorderSizePixel = 1
			success_message("sine animator has received gui. plugin will not need gui again until next studio session.")
		else
			error_message("sine animator cannot find gui. please use README file for help.")
		end
	else
		gui.TAB.Visible = true
	end
end)

repeat wait(.5) until gui

selected = nil

function updateproperties()
	if selected then
		gui.WINDOW.properties.name.Text = selected.name:sub(2)
		if selected.part then
			gui.WINDOW.properties.part.Text = selected.part.Name
			gui.WINDOW.properties.part.TextColor3 = Color3.new(.2,.2,.2)
			gui.WINDOW.properties.position.x.Text = tostring(math.floor(selected.position.x*100+.5)/100)
			gui.WINDOW.properties.position.y.Text = tostring(math.floor(selected.position.y*100+.5)/100)
			gui.WINDOW.properties.position.z.Text = tostring(math.floor(selected.position.z*100+.5)/100)
			gui.WINDOW.properties.rotation.x.Text = tostring(math.floor(selected.rotation.x*10+.5)/10)
			gui.WINDOW.properties.rotation.y.Text = tostring(math.floor(selected.rotation.y*10+.5)/10)
			gui.WINDOW.properties.rotation.z.Text = tostring(math.floor(selected.rotation.z*10+.5)/10)
		else
			gui.WINDOW.properties.part.Text = "no part set"
			gui.WINDOW.properties.part.TextColor3 = Color3.new(229/255, 0, 0)
			gui.WINDOW.properties.position.x.Text = 'x'
			gui.WINDOW.properties.position.y.Text = 'y'
			gui.WINDOW.properties.position.z.Text = 'z'
			gui.WINDOW.properties.rotation.x.Text = 'x'
			gui.WINDOW.properties.rotation.y.Text = 'y'
			gui.WINDOW.properties.rotation.z.Text = 'z'
		end
		gui.WINDOW.properties.frequency.Text = selected.frequency
		gui.WINDOW.properties.amplitude.Text = selected.amplitude
		gui.WINDOW.properties.raise.Text = selected.raise
		gui.WINDOW.properties.timeoffset.Text = selected.timeoffset
	else
		gui.WINDOW.properties.name.Text = ""
		gui.WINDOW.properties.part.Text = ""
	end
end
updateproperties()

waves = {}
preview = false
function updatepreview()
	if preview then
		for i, v in pairs(waves) do
			if v.part and v.cframe then
				v.part.CFrame = v.cframe + Vector3.new(v.position.x * math.sin(tick() * v.frequency * math.pi + v.timeoffset * math.pi) * v.amplitude + (v.position.x * v.raise/2), v.position.y * math.sin(tick() * v.frequency * math.pi + v.timeoffset * math.pi) * v.amplitude + (v.position.y * v.raise/2), v.position.z * math.sin(tick() * v.frequency * math.pi + v.timeoffset * math.pi) * v.amplitude + (v.position.z * v.raise/2))
				v.part.CFrame = v.part.CFrame * CFrame.Angles( math.rad(v.rotation.x * math.sin(tick() * v.frequency * math.pi + v.timeoffset)), math.rad(v.rotation.y * math.sin(tick() * v.frequency * math.pi + v.timeoffset)), math.rad(v.rotation.z * math.sin(tick() * v.frequency * math.pi + v.timeoffset)))
			end
		end
		game:service('RunService').Heartbeat:wait()
	end
end

gui.WINDOW.properties.name.Changed:connect(function()
	if selected then
		selected.name = " " .. gui.WINDOW.properties.name.Text
		selected.gui.Text = selected.name
	else
		gui.WINDOW.properties.name.Text = ""
	end
end)

gui.WINDOW.properties.part.MouseButton1Click:connect(function()
	if selected then
		gui.WINDOW.properties.part.Text = "no part set"
		gui.WINDOW.properties.part.TextColor3 = Color3.new(229/255, 0, 0)
		local get = game:service('Selection'):Get()
		if #get == 1 and get[1]:IsA('BasePart') then
			selected.part = get[1]
			gui.WINDOW.properties.part.Text = get[1].Name
			gui.WINDOW.properties.part.TextColor3 = Color3.new(.2,.2,.2)
			local part = selected.part
			selected.cframe = part.CFrame
			part.Changed:connect(function()
				if not preview and part == selected.part then
					selected.cframe = selected.part.CFrame
				end
			end)
		end
	end
end)

gui.WINDOW.properties.frequency.FocusLost:connect(function()
	if tonumber(gui.WINDOW.properties.frequency.Text) then
		selected.frequency = tonumber(gui.WINDOW.properties.frequency.Text)
	else
		gui.WINDOW.properties.frequency.Text = tostring(selected.frequency)
	end
end)

gui.WINDOW.properties.amplitude.FocusLost:connect(function()
	if tonumber(gui.WINDOW.properties.amplitude.Text) then
		selected.amplitude = tonumber(gui.WINDOW.properties.amplitude.Text)
	else
		gui.WINDOW.properties.amplitude.Text = tostring(selected.amplitude)
	end
end)

gui.WINDOW.properties.raise.FocusLost:connect(function()
	if tonumber(gui.WINDOW.properties.raise.Text) then
		selected.raise = tonumber(gui.WINDOW.properties.raise.Text)
	else
		gui.WINDOW.properties.raise.Text = tostring(selected.raise)
	end
end)

gui.WINDOW.properties.timeoffset.FocusLost:connect(function()
	if tonumber(gui.WINDOW.properties.timeoffset.Text) then
		selected.timeoffset = tonumber(gui.WINDOW.properties.timeoffset.Text)
	else
		gui.WINDOW.properties.timeoffset.Text = tostring(selected.timeoffset)
	end
end)

wave = {}
wave.__index = wave
setmetatable(wave, {
	__call = function(cls, ...)
		local self = setmetatable({}, cls)
		self:new(...)
		return self
	end
})
function wave:new()
	self.name = " wave-" .. tostring(#gui.WINDOW.scroll:children()+1)
	self.part = nil
	self.cframe = nil
	self.frequency = 1
	self.amplitude = 1
	self.raise = 0
	self.timeoffset = 0
	self.gui = gui.wave:Clone()
	self.position = Vector3.new(0, 0, 0)
	self.rotation = Vector3.new(0, 0, 0)
	
	self.gui.Position = UDim2.new(0, 0, 0, #gui.WINDOW.scroll:children()*21)
	self.gui.Text = self.name
	self.gui.Visible = true
	self.gui.Parent = gui.WINDOW.scroll
	gui.WINDOW.description.Visible = false
	
	self.gui.MouseButton1Click:connect(function()
		self:select()
	end)
	self:select()
	gui.WINDOW.scroll.CanvasSize = UDim2.new(0, 0, 0, #gui.WINDOW.scroll:children()*21)
	table.insert(waves, self)
end
function wave:select()
	if selected then
		selected.gui.TextColor3 = Color3.new(0, 0, 0)
	end
	selected = self
	self.gui.TextColor3 = Color3.new(0, 0, 1)
	updateproperties()
	return self
end
function wave:delete()
	self.gui:Destroy()
	if #gui.WINDOW.scroll:children() == 0 then
		gui.WINDOW.description.Visible = true
	else
		for i,v in pairs(gui.WINDOW.scroll:children()) do
			v.Position = UDim2.new(0, 0, 0, (i-1)*21)
		end
	end
	if selected == self then selected = nil end
	updateproperties()
	gui.WINDOW.scroll.CanvasSize = UDim2.new(0, 0, 0, #gui.WINDOW.scroll:children()*21)
	for i, v in pairs(waves) do
		if v == self then
			table.remove(waves, i)
		end
	end
	self = nil --bye :(
end

gui.WINDOW.new.MouseButton1Click:connect(function()
	wave():select()
end)
gui.WINDOW.delete.MouseButton1Click:connect(function()
	if selected then selected:delete() selected = nil end
end)
gui.WINDOW.preview.MouseButton1Click:connect(function()
	preview = not preview
	repeat
		updatepreview()
	until not preview
	for i, v in pairs(waves) do
		v.part.CFrame = v.cframe
	end
end)
gui.WINDOW.properties.position.x.MouseWheelForward:connect(function()
	if selected then
		if input:IsKeyDown('LeftControl') then
			selected.position = selected.position + Vector3.new(.2, 0, 0)
		elseif input:IsKeyDown('LeftShift') then
			selected.position = selected.position + Vector3.new(.01, 0, 0)
		end
		updateproperties()
	end
end)
gui.WINDOW.properties.position.y.MouseWheelForward:connect(function()
	if selected then
		if input:IsKeyDown('LeftControl') then
			selected.position = selected.position + Vector3.new(0, .2, 0)
		elseif input:IsKeyDown('LeftShift') then
			selected.position = selected.position + Vector3.new(0, .01, 0)
		end
		updateproperties()
	end
end)
gui.WINDOW.properties.position.z.MouseWheelForward:connect(function()
	if selected then
		if input:IsKeyDown('LeftControl') then
			selected.position = selected.position + Vector3.new(0, 0, .2)
		elseif input:IsKeyDown('LeftShift') then
			selected.position = selected.position + Vector3.new(0, 0, .01)
		end
		updateproperties()
	end
end)
gui.WINDOW.properties.rotation.x.MouseWheelForward:connect(function()
	if selected then
		if input:IsKeyDown('LeftControl') then
			selected.rotation = selected.rotation + Vector3.new(2, 0, 0)
		elseif input:IsKeyDown('LeftShift') then
			selected.rotation = selected.rotation + Vector3.new(.1, 0, 0)
		end
		updateproperties()
	end
end)
gui.WINDOW.properties.rotation.y.MouseWheelForward:connect(function()
	if selected then
		if input:IsKeyDown('LeftControl') then
			selected.rotation = selected.rotation + Vector3.new(0, 2, 0)
		elseif input:IsKeyDown('LeftShift') then
			selected.rotation = selected.rotation + Vector3.new(0, .1, 0)
		end
		updateproperties()
	end
end)
gui.WINDOW.properties.rotation.z.MouseWheelForward:connect(function()
	if selected then
		if input:IsKeyDown('LeftControl') then
			selected.rotation = selected.rotation + Vector3.new(0, 0, 2)
		elseif input:IsKeyDown('LeftShift') then
			selected.rotation = selected.rotation + Vector3.new(0, 0, .1)
		end
		updateproperties()
	end
end)
gui.WINDOW.properties.position.x.MouseWheelBackward:connect(function()
	if selected then
		if input:IsKeyDown('LeftControl') then
			selected.position = selected.position - Vector3.new(.2, 0, 0)
		elseif input:IsKeyDown('LeftShift') then
			selected.position = selected.position - Vector3.new(.01, 0, 0)
		end
		updateproperties()
	end
end)
gui.WINDOW.properties.position.y.MouseWheelBackward:connect(function()
	if selected then
		if input:IsKeyDown('LeftControl') then
			selected.position = selected.position - Vector3.new(0, .2, 0)
		elseif input:IsKeyDown('LeftShift') then
			selected.position = selected.position - Vector3.new(0, .01, 0)
		end
		updateproperties()
	end
end)
gui.WINDOW.properties.position.z.MouseWheelBackward:connect(function()
	if selected then
		if input:IsKeyDown('LeftControl') then
			selected.position = selected.position - Vector3.new(0, 0, .2)
		elseif input:IsKeyDown('LeftShift') then
			selected.position = selected.position - Vector3.new(0, 0, .01)
		end
		updateproperties()
	end
end)
gui.WINDOW.properties.rotation.x.MouseWheelBackward:connect(function()
	if selected then
		if input:IsKeyDown('LeftControl') then
			selected.rotation = selected.rotation - Vector3.new(2, 0, 0)
		elseif input:IsKeyDown('LeftShift') then
			selected.rotation = selected.rotation - Vector3.new(.1, 0, 0)
		end
		updateproperties()
	end
end)
gui.WINDOW.properties.rotation.y.MouseWheelBackward:connect(function()
	if selected then
		if input:IsKeyDown('LeftControl') then
			selected.rotation = selected.rotation - Vector3.new(0, 2, 0)
		elseif input:IsKeyDown('LeftShift') then
			selected.rotation = selected.rotation - Vector3.new(0, .1, 0)
		end
		updateproperties()
	end
end)
gui.WINDOW.properties.rotation.z.MouseWheelBackward:connect(function()
	if selected then
		if input:IsKeyDown('LeftControl') then
			selected.rotation = selected.rotation - Vector3.new(0, 0, 2)
		elseif input:IsKeyDown('LeftShift') then
			selected.rotation = selected.rotation - Vector3.new(0, 0, .1)
		end
		updateproperties()
	end
end)
gui.WINDOW.undo.MouseButton1Click:connect(function()
	--history:Undo()
end)
gui.WINDOW.redo.MouseButton1Click:connect(function()
	--history:Redo()
end)

--Plugin author: Heather @heathyboobs
