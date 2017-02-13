{-# LANGUAGE OverloadedStrings #-}
module Engine (runQuery, queryParser, Filterable, filterByField) where
import Data.Text(Text, isPrefixOf)

data Iterator a = Filter Text Text [Iterator a] | SeqScan (IO [a])

runQuery :: (Show a, Filterable a) => Iterator [a] -> [a] -> IO [a]
runQuery (Filter field value iterators) tuples = error "hi" -- filter (recordsMatch field value) (foldr runQuery tuples iterators)

recordsMatch :: Filterable a => Text -> Text -> a -> Bool
recordsMatch field value record = filterByField record field == value

queryParser :: (Show a, Filterable a) => [Text] -> Iterator a
queryParser ("filter:":filter:value:rest) = Filter filter value []

class Filterable a where
  filterByField :: a -> Text -> Text
