ESpec.start

ESpec.configure fn(config) ->
	config.before fn -> {:ok, answer: 42} end
	config.finally fn(__) -> __.answer end
end