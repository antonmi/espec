ESpec.configure fn(config) ->
  config.formatters [
    {ESpec.Formatters.Json, %{out_path: "results.json"}},
    {ESpec.Formatters.Html, %{out_path: "results.html"}},
    {ESpec.Formatters.Doc, %{details: true, out_path: "results.txt"}},
    {ESpec.CustomFormatter, %{a: 1, b: 2}},
  ]
end
