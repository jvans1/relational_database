{-# LANGUAGE OverloadedStrings #-}
module Main where
import Data.Text(pack)
import Control.Monad(forM_, mapM_)
import Engine(executeQuery, parsePlan)
import System.Environment(getArgs)
import qualified Data.ByteString.Lazy as BL

main :: IO ()
main = do
  plan <- parsePlan . fmap pack <$> getArgs
  tuples <- executeQuery plan
  forM_ tuples $ \tuple -> do
    mapM_ BL.putStr tuple
