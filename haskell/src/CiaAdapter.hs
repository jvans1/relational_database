{-# LANGUAGE OverloadedStrings #-}

module CiaAdapter (row, nullByte, recordsFromCSVs, DeclassifiedEvent(..) ) where
import Data.Monoid(mconcat)
import Data.Word(Word8)
import Data.ByteString.Char8(ByteString, append)
import Data.ByteString(snoc)
import qualified Data.ByteString as BS
import Data.Text.Encoding(encodeUtf8)
import Data.Either(rights)
import Data.Text hiding (append, snoc)
import Data.CSV(csvFile)
import Text.Parsec.Error(ParseError)
import Text.ParserCombinators.Parsec.Prim(parseFromFile)


fileNames = ["cia-crest-files-cia-crest-archive-metadata/6_export.csv" , "cia-crest-files-cia-crest-archive-metadata/7_export.csv" , "cia-crest-files-cia-crest-archive-metadata/8_export.csv", "cia-crest-files-cia-crest-archive-metadata/9_export.csv" , "cia-crest-files-cia-crest-archive-metadata/1_export.csv" , "cia-crest-files-cia-crest-archive-metadata/2_export.csv" ]

parseFile :: IO ()
parseFile = recordsFromCSVs >>= mapM_ (BS.appendFile "cia_records" . row)

nullByte :: Word8
nullByte = fromInteger 0

row :: DeclassifiedEvent -> ByteString
row (DeclassifiedEvent t u p) = str
  where 
    str =  snoc (encodeUtf8 t) nullByte `append` snoc (encodeUtf8 u) nullByte `append` encodeUtf8 p

data DeclassifiedEvent  = DeclassifiedEvent {
                              title :: Text
                              , url :: Text
                              , publicationDate :: Text
                            } deriving Show

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
