{-# LANGUAGE UnicodeSyntax #-}
--------------------------------------------------------------------------------
-- File   : Main
-- Author : Alejandro Gómez Londoño
-- Date   : Fri Aug  7 23:51:30 2015
-- Description : Testing for CM0081 programming lab 1
--------------------------------------------------------------------------------
-- Change log :

--------------------------------------------------------------------------------

module Main where

import SimAFA                     (accepts)
import Data.Automata.AFA.Examples (StateM(..), SymbolM(..),m1,m2,m3)
import Test.QuickCheck            (Arbitrary,arbitrary,elements)
import Test.QuickCheck            (maxSuccess,quickCheckWith,stdArgs)

instance Arbitrary SymbolM where
    arbitrary = elements [A,B,C,D]


main ∷ IO ()
main = do
  printTest prop1 "m1"
  printTest prop2 "m2"
  printTest prop3 "m3"

m1Check ∷ [SymbolM] → Bool
m1Check s = finishAB && noC && noD
    where finishAB = (take 2 . reverse) s == [A,B]
          noC      = not $ elem C s
          noD      = not $ elem D s

m2Check ∷ [SymbolM] → Bool
m2Check _ = False

m3Check ∷ [SymbolM] → Bool
m3Check = null

prop1 ∷ [SymbolM] → Bool
prop1 x = m1Check x == accepts m1 x

prop2 ∷ [SymbolM] → Bool
prop2 x = m2Check x == accepts m2 x

prop3 ∷ [SymbolM] → Bool
prop3 x = m3Check x == accepts m3 x

printTest ∷ ([SymbolM] → Bool) → String → IO ()
printTest prop msg = do
  putStrLn   "<div class=\"large-12 columns\">"
  putStrLn $ "<h4> Test ( " ++ msg ++ " )</h4>"
  putStrLn   "</div>"
  putStrLn   "<div class=\"large-12 columns\">"
  putStrLn   "<div class=\"panel\">"
  putStrLn   "<pre>"
  let conf = stdArgs {maxSuccess = 1000}
  quickCheckWith conf prop
  putStrLn   "</pre>"
  putStrLn   "</div>"
  putStrLn   "</div>"
