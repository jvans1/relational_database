{-# LANGUAGE OverloadedStrings #-}

module CiaAdapter ( recordsFromCSVs ) where
import Data.Monoid(mconcat)
import Data.Either(rights)
import Data.Text
import Engine(Filterable, filterByField)
import Data.CSV(csvFile)
import Text.Parsec.Error(ParseError)
import Text.ParserCombinators.Parsec.Prim(parseFromFile)


fileNames = ["cia-crest-files-cia-crest-archive-metadata/6_export.csv" , "cia-crest-files-cia-crest-archive-metadata/7_export.csv" , "cia-crest-files-cia-crest-archive-metadata/8_export.csv", "cia-crest-files-cia-crest-archive-metadata/9_export.csv" , "cia-crest-files-cia-crest-archive-metadata/1_export.csv" , "cia-crest-files-cia-crest-archive-metadata/2_export.csv" ]

data DeclassifiedEvent  = DeclassifiedEvent {
                              title :: Text
                              , url :: Text
                              , publicationDate :: Text
                            } deriving Show

instance Filterable DeclassifiedEvent where
  filterByField (DeclassifiedEvent title _ _) "title"         = title
  filterByField (DeclassifiedEvent _ url _) "url"             = url
  filterByField (DeclassifiedEvent _ _ publicationDate) "publicationDate" = publicationDate

recordsFromCSVs :: IO [DeclassifiedEvent]
recordsFromCSVs = mconcat . rights <$> mapM recordsFromCSV fileNames

recordsFromCSV :: String -> IO (Either ParseError [DeclassifiedEvent])
recordsFromCSV fileName = (fmap $ fmap toRecord) <$> parseFromFile csvFile fileName

toRecord :: [String] -> DeclassifiedEvent
toRecord parsedCSV = DeclassifiedEvent _title _url pub
      where
        _title = pack $ parsedCSV !! 21
        _url = pack $ parsedCSV !! 22
        pub = pack $ parsedCSV !! 18
