--You can just drop new weapon ents into the master list and the game will adapt, no extra configuring needed!
mastlist = {"gy_m249","gy_m4","gy_mp5","gy_glock","gy_57","gy_tmp","gy_deagle","gy_awp","gy_ak47","gy_m3","gy_g3"}
weplist = mastlist --Probably don't need to do this, but nothing wrong with safety

--I found this function online, was much smaller than the 3 function colossus I had :p
function RandomizeWeapons()

	l=count()
	for i = l, 2, -1 do -- backwards
		local r = math.random(i) -- select a random number between 1 and i
		weplist[i], weplist[r] = weplist[r], weplist[i] -- swap the randomly selected item to position i
	end  
	
end

--Counts how many weapons there are in the list at the top
function count()
	c=0
	for _ in pairs(mastlist) do
		c=c+1
	end
	return(c)
end

