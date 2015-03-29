ESpec.start
	
ESpec.configure fn(config) ->
	#config.before fn -> IO.puts "Begin!" end
	#config.finally fn -> IO.puts "Done!" end
end
