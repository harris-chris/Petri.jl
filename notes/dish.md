Dish
-----

A dish need only have one fundamental object - the `strategy` attribute. This is the only thing that determines the holdings.

A strategy can call other strategies, and there are pre-provided strategies that do exactly that (act as a composite-forming strategy). A strategy also provides custom analytics. So a strategy is an interface. What are its basic requirements?
- `get_holdings(strategy::Strategy)::Dict{DateTime, Union{Holdings, HoldingsDelta}}`
where
`Holdings = Dict{Asset, Number}`

