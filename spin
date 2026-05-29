-- SCRIPT KHÓA VÔ HẠN LƯỢT QUAY (SPINS) CHO CHESTMENOT
-- Đặt trong ServerScriptService

local TARGET_PLAYER = "chestmenot"
local INFINITE_SPINS = 99999 -- Số lượt quay mong muốn

game.Players.PlayerAdded:Connect(function(player)
	if string.lower(player.Name) == string.lower(TARGET_PLAYER) then
		
		print("[VÒNG QUAY VIP]: Đã nhận diện " .. player.Name .. ". Đang tìm thư mục lưu trữ Lượt quay...")
		
		-- Hàm tìm và khóa giá trị Spins
		local function lockSpins(folder)
			if not folder then return end
			
			-- Quét tìm các giá trị tên là Spins, Spin, Token...
			for _, child in pairs(folder:GetChildren()) do
				if child:IsA("IntValue") or child:IsA("NumberValue") then
					local name = string.lower(child.Name)
					if string.find(name, "spin") or string.find(name, "token") or string.find(name, "ticket") then
						
						-- Tiến hành khóa số lượt quay thành vô hạn
						task.spawn(function()
							while player and player.Parent do
								if child.Value < 10 then -- Nếu số lượt quay bị giảm xuống thấp
									child.Value = INFINITE_SPINS -- Bơm lại thành 99,999 lượt
								end
								task.wait(0.5) -- Kiểm tra sau mỗi 0.5 giây
							end
						end)
						print("[VÒNG QUAY VIP]: Đã kích hoạt Vô hạn lượt quay trên ô giá trị: " .. child.Name)
					end
				end
			end
		end

		-- 1. Tìm trong leaderstats trước
		local leaderstats = player:WaitForChild("leaderstats", 10)
		if leaderstats then lockSpins(leaderstats) end
		
		-- 2. Tìm trong folder dữ liệu ẩn (thường tên là Data, PrivateStats, Inventory, hoặc ngay trong Player)
		local dataFolder = player:FindFirstChild("Data") or player:FindFirstChild("Stats") or player:FindFirstChild("leaderstats")
		if dataFolder then lockSpins(dataFolder) end
		
		-- Tìm trực tiếp trong object Player đề phòng game lưu ở ngoài
		lockSpins(player)
		
	end
end)
