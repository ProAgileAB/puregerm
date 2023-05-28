module Tests where

import Prelude

import Effect (Effect)
import Effect.Aff (launchAff_)
import Main (tick)
import Test.Spec (describe, it)
import Test.Spec.Assertions (shouldEqual)
import Test.Spec.Reporter.TeamCity (teamcityReporter)
import Test.Spec.Runner (runSpec)
import Data.Number.Format (fixed, toStringWith)
import Data.Array (length)

main :: Effect Unit
main = launchAff_ $ runSpec [ teamcityReporter ] do
  describe "PureScript " do
    it "can convert numbers to strings" do
      toStringWith (fixed 1) 0.12 # shouldEqual "0.1"
  describe "Food" do
    it "stays if no germ eats it" do
      let
        nextState = tick
          { germs: []
          , foods: [ { x: 0.0, y: 0.0 } ]
          }
      (length nextState.foods) # shouldEqual 1
  describe "Germs" do
    it "can move horisontally" do
      let
        nextState = tick
          { germs: [ { pos: { x: 0.0, y: 0.0 }, dir: 0.0, lifeLeft: 10 } ]
          , foods: []
          }
      nextState.germs <#> _.pos.x <#> toStringWith (fixed 1) # shouldEqual [ "1.0" ]
    it "can move vertically" do
      let
        nextState = tick
          { germs: [ { pos: { x: 0.0, y: 0.0 }, dir: 3.1415 / 2.0, lifeLeft: 10 } ]
          , foods: []
          }
      nextState.germs <#> _.pos.y <#> toStringWith (fixed 1) # shouldEqual [ "1.0" ]
    it "age each tick (life goes down by one)" do
      let
        nextState = tick
          { germs: [ { pos: { x: 0.0, y: 0.0 }, dir: 3.1415 / 2.0, lifeLeft: 5 } ]
          , foods: []
          }
      nextState.germs <#> _.lifeLeft # shouldEqual [ 4 ]
    it "produce food when dying of age" do
      let
        nextState = tick
          { germs: [ { pos: { x: 0.0, y: 0.0 }, dir: 3.1415 / 2.0, lifeLeft: 0 } ]
          , foods: []
          }
      [ length nextState.germs, length nextState.foods ] # shouldEqual [ 0, 1 ]
-- moving germß
-- - ordinary move
-- - eating food
-- - onto wall
-- - splitting in two
-- - die of age
-- - die of hunger
