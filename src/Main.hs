{-# LANGUAGE Haskell2010       #-}
{-# LANGUAGE OverloadedStrings #-}
module Main (main) where

import           Data.Aeson
import           Data.Aeson.Types
import qualified Data.HashMap.Lazy   as HashMap
import           Data.Text           (Text)
import qualified Data.Text           as Text
import           Data.Time.Clock
import           Data.Time.Format
import           Data.Time.LocalTime
import           Network.HTTP.Simple

jsonPath :: [Text] -> Value -> Parser Value
jsonPath [] v = return v
jsonPath (k:ks) (Object o) =
  case HashMap.lookup k o of
    Just v  -> jsonPath ks v
    Nothing -> fail $ "no key "++(Text.unpack k)++" found in object"
jsonPath (k:_) v = typeMismatch ("path element "++ (Text.unpack k)) v

data APIResponse = APIResponse
                   { updated :: UTCTime
                   , usdRate :: Double
                   } deriving (Eq, Show)

instance FromJSON APIResponse where
  parseJSON v = do
    t <- jsonPath ["time", "updatedISO"] v
    r <- jsonPath ["bpi", "USD", "rate_float"] v
    APIResponse <$>
      parseJSON t <*>
      parseJSON r

main :: IO ()
main = do
  tz <- getCurrentTimeZone
  resp <- httpJSON "https://api.coindesk.com/v1/bpi/currentprice.json"
  let body = (getResponseBody resp :: APIResponse)
      upd = updated body
      upds = formatTime defaultTimeLocale "%R" $ utcToZonedTime tz upd
      rate = usdRate body in
    putStrLn $ (show rate) ++ " at " ++ upds
