{-# LANGUAGE OverloadedStrings #-}
module Main where
import Prelude hiding (putStrLn)
import Data.Text(pack)
import Control.Monad(forM_, mapM_)
import Data.ByteString.Lazy.Char8(putStrLn)
import Data.Text.Encoding(encodeUtf8)
import Engine(executeQuery, parsePlan)
import System.Environment(getArgs)
import qualified Data.ByteString.Lazy as BL

tToBl= BL.fromStrict . encodeUtf8
main :: IO ()
main = do
  plan <- parsePlan . fmap pack <$> getArgs
  tuples <- executeQuery plan
  forM_ tuples $ \tuple -> do
    putStrLn $ BL.intercalate "  |  " tuple
