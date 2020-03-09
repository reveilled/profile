set disassembly-flavor intel
set breakpoint pending on
set output-radix 16
set print pretty
set height 0

define ci
	x/i $rip
end

define sci
	x/i $rip
	s 1
end

source ~/.gdbinit-gef.py
