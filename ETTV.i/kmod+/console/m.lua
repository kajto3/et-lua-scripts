function dolua(params)
	if et.trap_Argv(1) == "" or et.trap_Argv(1) == " " then 
		et.trap_SendServerCommand(params["slot"], string.format("print \"Useage:  /m \[pname/ID\] \[message\]\n"))
	else
		private_message(params["slot"], et.trap_Argv(1), et.ConcatArgs(2))
		return 1
	end		
end