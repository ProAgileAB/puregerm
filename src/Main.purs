module Main where

import Prelude
import Effect (Effect)
import Data.Number (cos, sin)
import Data.Array (concatMap, replicate)
import Effect.Random (randomRange)
import Data.Traversable (sequence)

type Model =
  { germs :: Array Germ
  , foods :: Array Food
  }

type Position =
  { x :: Number
  , y :: Number
  }

type Food = Position

type Germ =
  { pos :: Position
  , dir :: Number
  , lifeLeft :: Int
  }

tick :: Model -> Model
tick m = m
  { germs = concatMap _.germs result
  , foods = concatMap _.foods result <> m.foods
  }
  where
  result = map tickGerm m.germs

tickGerm :: Germ -> Model
tickGerm germ = if germ.lifeLeft == 0 then { germs: [], foods: [ g.pos ] } else { germs: [ g ], foods: [] }
  where
  g = germ
    { pos = germ.pos
        { x = germ.pos.x + dx
        , y = germ.pos.y + dy
        }
    , lifeLeft = germ.lifeLeft - 1
    }
  dx = cos germ.dir
  dy = sin germ.dir

main :: Effect Unit
main = do
  let germs = [ { pos: { x: 50.0, y: 50.0 }, dir: 0.15, lifeLeft: 25 } ] :: Array Germ
  foods <- sequence $ replicate 100 random_food
  simulate { germs: germs, foods: foods } tick

random_food :: Effect { x :: Number, y :: Number }
random_food = random_pos

random_pos :: Effect { x :: Number, y :: Number }
random_pos = do
  x <- randomRange 0.0 500.0
  y <- randomRange 0.0 500.0
  pure { x, y }

foreign import simulate :: Model -> (Model -> Model) -> Effect Unit

