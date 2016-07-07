-- Math extend

function math.sign(x)
	if math.floor(x) ~= 0 then
		return x/math.abs(x)
	end
	
	return 0
end

function math.round(x)
	if x > 0 then tmp = math.floor(x)
	else tmp = math.ceil(x) end
	if x > 0 then res = math.floor(x*10)
	else res = math.ceil(x*10) end

	if math.abs(res-tmp*10) >= 5 and x > 0 then
		return math.ceil(x)
	elseif math.abs(res-tmp*10) < 5 and x > 0 then
		return math.floor(x)
	elseif math.abs(res-tmp*10) >= 5 and x < 0 then
		return math.floor(x)
	elseif math.abs(res-tmp*10) < 5 and x < 0 then
		return math.ceil(x)
	end
	return 0
end