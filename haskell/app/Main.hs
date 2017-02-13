{-# LANGUAGE OverloadedStrings #-}
module Main where
import Control.Monad(forM_)
import Data.Text(pack)
import Engine
import CiaAdapter(recordsFromCSVs)
import System.Environment(getArgs)

main :: IO ()
main = do
  query <- fmap pack <$> getArgs
  print query
  results <- recordsFromCSVs
  forM_ (runQuery (queryParser query) results ) $ \record -> do
      putStrLn "Found Record:"
      print record
