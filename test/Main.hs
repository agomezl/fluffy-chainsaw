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
import Data.Automata.AFA.Examples (StateM(..), SymbolM(..),m1)
import Test.QuickCheck (Arbitrary,arbitrary,elements,maxSuccess,quickCheckWith,stdArgs)

instance Arbitrary SymbolM where
    arbitrary = elements [A,B,C,D]


main ∷ IO ()
main = do
  printTest prop1 "m1"

m1Check ∷ [SymbolM] → Bool
m1Check s = finishAB && noC && noD
    where finishAB = (take 2 . reverse) s == [A,B]
          noC      = not $ elem C s
          noD      = not $ elem D s


prop1 ∷ [SymbolM] → Bool
prop1 x = m1Check x == accepts m1 x

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
