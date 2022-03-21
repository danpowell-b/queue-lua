local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
--local Alert = require(ReplicatedStorage:WaitForChild("module").alert)

local queueTrigger = workspace:WaitForChild("QueueTouch")
local nodes = workspace:WaitForChild("Nodes")

local queue = {
	[1] = 0,
	[2] = 0,
	[3] = 0,
	[4] = 0,
	[5] = 0,
}
local internalQueue = {
	
}

local function AddToQueue(player, humanoid)
	local node = 0
	table.insert(internalQueue, player)
	
	for index,value in ipairs(queue) do
		if value == 0 then
			node = index
			break
		end
	end
	
	if node ~= 0 then
		queue[node] = player
		print()
		
		humanoid:MoveTo(nodes[node].Position)
		
	else
		--Alert.new("Queue is full - please wait", "Warning")
	end
end

local function UpdateQueue()
	local node = 0

	for index,value in ipairs(queue) do
		local player = value

		if value ~= 0 and index ~= 1 and queue[index - 1] == 0 then
			local i = 1

			while queue[index - i] == 0 or index - i ~= 0 do	
				if queue[index - i] == 0 then
					break
				end
				queue[index - (i - 1)] = 0
				queue[index - i] = value

				node = index - i
				i += 1				
			end
			
			player.Character.Humanoid:MoveTo(nodes[node + 1].Position)
		end
	end
end

local function RemoveFromQueue(player, humanoid, selfInvoked)
	table.remove(internalQueue, table.find(internalQueue, player))
	
	queue[table.find(queue, player)] = 0
	
	UpdateQueue()
end

queueTrigger.Touched:Connect(function(obj)
	if obj.Parent:IsA("Model") and obj.Parent:FindFirstChild("Humanoid") then
		local player = Players:GetPlayerFromCharacter(obj.Parent)
		local humanoid = obj.Parent:FindFirstChild("Humanoid")
		
		if player and humanoid and not table.find(internalQueue, player) then
			AddToQueue(player, humanoid)	
		end
		
	end		
end)
