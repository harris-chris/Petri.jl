@testset "DefinedPositionsStrategy" begin
    asset_1 = ExternallyPricedAsset(
        "asset_2",
        PricesSeries(time = [
            DateTime(2023,1,1),
            DateTime(2023,1,2),
            DateTime(2023,1,3),
            DateTime(2023,1,4),
        ], val = [100.0, 101.0, 102.0, 103.0])
    )
    asset_2 = ExternallyPricedAsset(
        "asset_1",
        PricesSeries(time = [
            DateTime(2023,1,1),
            DateTime(2023,1,2),
            DateTime(2023,1,3),
            DateTime(2023,1,4),
        ], val = [50.0, 50.5, 51.0, 51.5])
    )
    @testset "Simple two asset strategy with 2 x 2 rebalances" begin
        strategy_positions = [
            Positions(DateTime(2023,1,1), Dict(asset_1 => 1.0, asset_2 => 2.0)),
            Positions(DateTime(2023,1,3), Dict(asset_1 => 1.1, asset_2 => 2.2)),
        ]
        defined_positions_strategy = DefinedPositionsStrategy(strategy_positions)
        @test get_rebalance(
            defined_positions_strategy, nothing, DateTime(2022,12,31)
        ) == strategy_positions[1]
        @test get_rebalance(
            defined_positions_strategy, nothing, DateTime(2023,1,3)
        ) == strategy_positions[2]
        defined_positions_strategy
    end
end

