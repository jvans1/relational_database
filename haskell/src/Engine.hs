{-# LANGUAGE OverloadedStrings #-}
module Engine (runQuery, queryParser, Filterable, filterByField) where
import Data.Text(Text, isPrefixOf)

data Iterator = Filter Text Text [Iterator] deriving Show

runQuery :: (Show a, Filterable a) => Iterator -> [a] -> [a]
runQuery (Filter field value iterators) tuples = filter (recordsMatch field value) (foldr runQuery tuples iterators)

recordsMatch :: Filterable a => Text -> Text -> a -> Bool
recordsMatch field value record = filterByField record field == value

queryParser :: [Text] -> Iterator
queryParser ("filter:":filter:value:rest) = Filter filter value []

class Filterable a where
  filterByField :: a -> Text -> Text

