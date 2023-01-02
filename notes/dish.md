Dish
-----

A dish need only have one fundamental object - the `strategy` attribute. This is the only thing that determines the holdings.

A strategy can call other strategies, and there are pre-provided strategies that do exactly that (act as a composite-forming strategy). A strategy also provides custom analytics. So a strategy is an interface. What are its basic requirements?
- `get_rebalances(strategy::Strategy, holdings_table::HoldingsTable)::HoldingsSeries`
where
`Holdings = Dict{Asset, Number}`

Note that we need holdings_table to be a parameter here because many dynamic strategies will base their next rebalance on portfolio movements/weights/values

How is a strategy different from a dish?
A dish can only hold one strategy
The strategy
A dish can hold other dishes, and manage them with one or more strategies
So there is some kind of a difference?
But the strategy would also be setting the sub-dishes
A strategy cannot itself be a holding, that seems to be the difference. You could not hold a momentum strategy, because it has no absolute values, it only returns deltas.
Then there's a question about whether we want to use a composite strategy for combining multiple strategies, or allow a dish to have multiple strategies. It might be best just to have that functionality in Dish directly. Can't quite decide. Probably prefer single strategy within dish.

How do you determine "prices" for a dish? Interesting question. Values are easier.

The fact that we are using DateTimes rather than dates means that possibly we are less likely to want to do these kind of outer joins.
To be honest we probably do want to retain the functionality to use end-of-day dates as well as DateTimes.
The trouble is is that it will be hard to mix those two things. It might be better to say by convention that midnight = EOD price.
The thing about using DateTimes is that you'll never really get a portfolio valuation, because you'll never really get values at the same time for all assets.
If we accepted the idea of values being carried forward then this would be OK, though. When do you not carry them forward? Do you carry both values and prices forward, or just one? This carrying-forward thing, do you customize it or not?
In Petri we used a system where values were generally not carried forward, from one day to the next.
Perhaps we need a go-stale function that works at the asset level. For both value and price. If values and prices were requested for specified time points, eg get_prices(asset, times), then this go-stale function could be entirely internal.

A type function is always called at compile-time and so we always know its arguments, or its arguments are always hard-coded into the code. So it's more like an alias, we can always immediately resolve the function at compile-time.


