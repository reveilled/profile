import gdb

class GadgetCommand(gdb.Command):
	def __init__(self,name):
		super(GadgetCommand,self).__init__(name,gdb.COMMAND_OBSCURE)
		print('GadgetCommand "%s" is now available'%name)

	def strip_symbol(self,in_string):
		a= in_string
		#strip out the symbol in the '<' and '>'
		while a is not None and a.find('<') != -1:
			a = a[:a.find('<')]+a[a.rfind('>')+1:]
		return a

	def isGadgetTerminator(self, instruction):

		instruction = ' '.join(instruction.split()).lower()

		is_terminator = instruction.startswith('ret')	
		is_terminator = is_terminator or instruction.startswith('(bad)')
		is_terminator = is_terminator or instruction.startswith('call')
		is_terminator = is_terminator or instruction.startswith('jmp q')
		is_terminator = is_terminator or instruction.startswith('jmp d')
		is_terminator = is_terminator or instruction.startswith('jmp w')
		is_terminator = is_terminator or instruction.startswith('jmp r')
		is_terminator = is_terminator or instruction.startswith('jmp e')
		return is_terminator

	def get_number_of_instructions(self,addr): 
		num_instructions=0
		instruction = ''

		while not self.isGadgetTerminator(instruction):
			command = 'x/2i 0x%x'%addr
			result = gdb.execute(command,to_string=True)
			lines = result.split('\n')
			lines[0] = self.strip_symbol(lines[0])
			lines[1] = self.strip_symbol(lines[1])
			addr = int(lines[1].split(':')[0].strip(),16)
			instruction = lines[0].split(':')[1].strip()
			num_instructions+=1
		return num_instructions

	def invoke(self, arguments,from_tty):
		print('GadgetCommand Invoke')

class Gadget(GadgetCommand):
	def __init__(self):
		super(Gadget,self).__init__('gadget')
		self.mode = 'stack'
		self.addr_step=0

	def invoke(self, arguments, from_tty):
		try:

			if len(arguments) > 0:
				args = arguments.split()
				addr = int(args[0],16)
				self.dont_repeat()
				self.mode = 'single'
				self.addr_step=0

			else:
				int_ptype=gdb.lookup_type('long').pointer()			
				stack_addr = gdb.Value(int(gdb.parse_and_eval('$rsp'))+8*self.addr_step)
				addr= int(stack_addr.cast(int_ptype).dereference())
				self.mode = 'stack'
				self.addr_step+=1

			num_instructions = self.get_number_of_instructions(addr)
			command = 'x/%di 0x%x'%(num_instructions,addr)

			result = gdb.execute(command,to_string=True)
			lines = []
			for line in result.split('\n'):
				lines.append(self.strip_symbol(line).strip())
			print('\n'.join(lines))

	
		except gdb.MemoryError:
			print('Invalid memory access for gadget')
			self.addr_step=0
			self.dont_repeat()
		
class StepGadget(GadgetCommand):
	def __init__(self):
		super(StepGadget,self).__init__('step_gadget')

	def invoke(self,arguments,from_tty):
		try:
			num_gadgets = 1
			if len(arguments) > 0:
				print('Skipping over multiple gadgets')
				num_gadgets=int(arguments)
	
			for i in range(num_gadgets):
				current_rip = int(gdb.parse_and_eval('$rip'))
				print('Current RIP: 0x%x'%current_rip)
				instructions = self.get_number_of_instructions(current_rip)
				print('Number instructions in current gadget: %d'%instructions)
				command = 'si %d'%instructions
				result = gdb.execute(command,to_string=True)

		except gdb.MemoryError:
			print('Invalid memory access for gadget')
			self.addr_step=0
			self.dont_repeat()
Gadget()
StepGadget()	
