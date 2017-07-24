set disassembly-flavor intel

define ci
	x/i $rip
end

define sci
	x/i $rip
	s 1
end
