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
import Data.Automata.AFA.Examples (StateM(..), SymbolM(..),m1,m2,m3,m4,m5)
import Test.QuickCheck            (Arbitrary,arbitrary,elements,forAll)
import Test.QuickCheck            (maxSuccess,quickCheckWith,stdArgs)
import Test.QuickCheck            (choose,listOf,Property)

instance Arbitrary SymbolM where
    arbitrary = elements [A,B,C,D]


main ∷ IO ()
main = do
  let conf = stdArgs {maxSuccess = 1000}
  printTest (quickCheckWith conf prop1) "m1"
  printTest (quickCheckWith conf prop2) "m2"
  printTest (quickCheckWith conf prop3) "m3"
  printTest (quickCheckWith conf prop4) "m4"
  printTest (quickCheckWith conf prop5) "m5"

m1Check ∷ [SymbolM] → Bool
m1Check s = finishAB && noC && noD
    where finishAB = (take 2 . reverse) s == [A,B]
          noC      = not $ elem C s
          noD      = not $ elem D s

m2Check ∷ [SymbolM] → Bool
m2Check _ = False

m3Check ∷ [SymbolM] → Bool
m3Check = null

m4Check ∷ [Int] → Bool
m4Check l = s0 l
    where
      s0 (0:x) = s0 x || s1 x
      s0 _     = False
      s1 (1:x) = s1 x || s2 x
      s1 _     = False
      s2 (2:x) = s2 x || s3 x
      s2 _     = False
      s3 []    = True
      s3 _     = False

m5Check ∷ [Int] → Bool
m5Check l = s0 l
    where
      s0 (0:x) = s0 x
      s0 (1:x) = s1 x && s2 x
      s0 _     = False
      s1 []    = True
      s1 (1:x) = s1 x && s2 x
      s1 _     = False
      s2 []    = True
      s2 (1:x) = s1 x && s2 x
      s2 _     = False



prop1 ∷ [SymbolM] → Bool
prop1 x = m1Check x == accepts m1 x

prop2 ∷ [SymbolM] → Bool
prop2 x = m2Check x == accepts m2 x

prop3 ∷ [SymbolM] → Bool
prop3 x = m3Check x == accepts m3 x

prop4 ∷ Property
prop4 = forAll (listOf $ choose (0,2)) rawProp
    where rawProp x = m4Check x == accepts m4 x

prop5 ∷ Property
prop5 = forAll (listOf $ choose (0,1)) rawProp
    where rawProp x = m5Check x == accepts m5 x

printTest  ∷ IO () → String → IO ()
printTest run msg = do
  putStrLn   "<div class=\"large-12 columns\">"
  putStrLn $ "<h4> Test ( " ++ msg ++ " )</h4>"
  putStrLn   "</div>"
  putStrLn   "<div class=\"large-12 columns\">"
  putStrLn   "<div class=\"panel\">"
  putStrLn   "<pre>"
  run
  putStrLn   "</pre>"
  putStrLn   "</div>"
  putStrLn   "</div>"
