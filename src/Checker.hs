{-# LANGUAGE UnicodeSyntax #-}
{-# LANGUAGE OverloadedStrings #-}
module Checker where

import System.Process            (rawSystem)
import System.Exit               (ExitCode(..))
import Data.ByteString.Lazy as B (ByteString,writeFile)

import Util (mkDir)

fileCheck ∷ B.ByteString → String → IO FilePath
fileCheck _data id = do
  mkDir $ "data/" ++ id
  flip B.writeFile _data $ "data/" ++ id ++ "/SimAFA.hs"
  rawSystem "./checker.sh" [ id ] >>= \exitCode →
      case exitCode of
        ExitSuccess   → return $ "data/" ++ id ++ "/check.html"
        ExitFailure e → return $ "views/error.html"
