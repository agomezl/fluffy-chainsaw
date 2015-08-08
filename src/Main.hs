{-# LANGUAGE UnicodeSyntax #-}
{-# LANGUAGE OverloadedStrings #-}
module Main where

--Util
import Util                               (AppKey,getSession)
import Control.Monad.Trans                (liftIO)
import Data.String                        (fromString)
--Session stuff
import qualified Data.Vault.Lazy as Vault (newKey)
import Data.Default                       (def)
import Network.Wai.Parse                  (fileContent,fileName)
import Network.Wai.Session                (withSession)
import Network.Wai.Session.Map            (mapStore_)
--Scotty
import Web.Scotty                         (get,post,scotty,middleware)
import Web.Scotty                         (setHeader,request,files,file)
import Network.Wai.Middleware.Static      (staticPolicy,noDots,addBase,(>->))
--Checker
import Checker                            (fileCheck)

main ∷ IO ()
main = do
  session ←  Vault.newKey ∷ IO AppKey
  store   ←  mapStore_
  scotty 3000 $ do
         middleware $ withSession store (fromString "SESSION") def session
         middleware $ staticPolicy (noDots >-> addBase "public")
         get "/" $ do
                  setHeader "Content-Type" "text/html"
                  file "views/home.html"
         post "/check" $ do
                  f ← files
                  env ← request
                  setHeader "Content-Type" "text/html; charset=utf-8"
                  ses ← getSession session env
                  let checkData d = liftIO $ fileCheck (fileContent d) ses
                  case f of
                    [] → error "no file uploaded"
                    ((_,_data):_) → if fileName _data  == "SimAFA.hs"
                                    then checkData _data >>= file
                                    else liftIO . print . fileName $ _data
