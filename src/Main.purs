module Main where

import Prelude

import Effect (Effect)
import Effect.Console (log)

type Germ = {
    pos :: Position,
    name :: String,
    age :: Int
}

type Position = {
    x :: Number,
    y :: Number
}

type Bacteria = {
    pos :: Position,
    dir :: Number,
    age :: Int
}

foreign import simulate ::
 Array Germ ->
 (Array Germ -> Array Germ) ->
 Effect Unit

main :: Effect Unit
main = do
  simulate [{ pos: {x: 50.0, y: 50.0}, name: "Samuel", age: 25}] tick

tick :: Array Germ -> Array Germ
tick = map (\germ -> germ
    { pos = germ.pos
        { x = germ.pos.x + 1.0
        , y = germ.pos.y + 1.0
    }
  })
