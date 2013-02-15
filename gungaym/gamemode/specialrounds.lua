//This has a whole bunch of special rules, once in a while there'll be a special round or some shit


function ResetSpecial()
	SetGlobalBool("SR_headshot",false)
	SetGlobalBool("SR_doubleup",false)
end

//This is a shitty, unmodular system, but I can't figure out how to call random functions from a table
//So I'll use this for now
function SpecialRandom()
	--local num = math.random(1)
	
	--if num == 1 then
		SetGlobalBool("SR_headshot",true)
		PrintMessage(HUD_PRINTCENTER, ("It's a headshot only round!"))
	--end
end