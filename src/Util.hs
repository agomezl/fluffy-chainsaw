{-# LANGUAGE UnicodeSyntax #-}
{-# LANGUAGE OverloadedStrings #-}
module Util where
import Web.Scotty (ActionM)
import System.Directory                   (createDirectoryIfMissing)
import System.IO.Error                    (tryIOError,isAlreadyExistsError)
import Data.String                        (fromString,IsString)
import Control.Monad.Trans                (liftIO)
import Data.ByteString.Char8              (unpack)
import Network.Wai                        (vault,Request,pathInfo)
import Network.Wai.Session                (Session,genSessionId)
import qualified Data.Vault.Lazy as Vault (Key,lookup)

--Datatypes
type AppKey = Vault.Key (Session IO String String)

mkDir ∷ FilePath → IO ()
mkDir path = do
  err ← tryIOError $ createDirectoryIfMissing True path
  case err of
    Right () → return ()
    Left e | isAlreadyExistsError e → return ()
           | otherwise              → ioError e

getSession ∷  (IsString a) ⇒ AppKey → Request → ActionM a
getSession key env = do
  let Just (sessionLookup, sessionInsert) = Vault.lookup key (vault env)
  let mkId = genSessionId >>= sessionInsert "o" . unpack
  (liftIO $ sessionLookup "o" ) >>= \id →
      case id of
        Nothing → liftIO mkId >> getSession key env
        Just o  → return $ fromString o
