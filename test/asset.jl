@testset "DefinedPriceAsset" begin
    defined_price_asset = DefinedPriceAsset(
        "defined_price_1",
        [
            (DateTime(2023,1,1), 100.0),
            (DateTime(2023,1,2), 101.0),
            (DateTime(2023,1,3), 102.0),
        ]
    )

    times_subset = [DateTime(2023,1,1), DateTime(2023,1,3)]
    prices_subset = [100.0, 102.0]
    exp = DataFrame(Time = times_subset, Price = prices_subset)
    println(defined_price_asset)
    act = get_prices(defined_price_asset, times_subset)
    println(act)
    @test act == exp
end
