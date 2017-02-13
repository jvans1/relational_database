{-# LANGUAGE OverloadedStrings #-}
module Engine (runQuery, queryParser, Filterable, filterByField) where
import Data.Text(Text, isPrefixOf)

type Table = Text
type ColName = Text

data Iterator = Filter Text Text Iterator | SeqScan [ deriving Show

runQuery :: (Show a, Filterable a) => Iterator -> [a] -> [a]
runQuery (Filter field value iterators) tuples = filter (recordsMatch field value) runQuery tuples iterators

recordsMatch :: Filterable a => Text -> Text -> a -> Bool
recordsMatch field value record = filterByField record field == value

queryParser :: [Text] -> Iterator
queryParser ("filter:":filter:value:rest) = Filter filter value [queryParser rest]
queryParser ("join:":join1:join2:col1:col2:on_value) = Join join1 join2 col1 col2 on_value

class Filterable a where
  filterByField :: a -> Text -> Text
