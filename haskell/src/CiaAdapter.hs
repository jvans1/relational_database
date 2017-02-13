{-# LANGUAGE OverloadedStrings #-}

module CiaAdapter(parseFiles)  where
import Data.Monoid(mconcat)
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

parseFiles :: IO ()
parseFiles = recordsFromCSVs >>= (BS.writeFile "cia" . mconcat)

recordsFromCSVs :: IO [ByteString]
recordsFromCSVs = mconcat . rights <$> mapM recordsFromCSV fileNames

recordsFromCSV :: String -> IO (Either ParseError [ByteString])
recordsFromCSV fileName = (fmap $ (fmap toRecord)) <$> parseFromFile csvFile fileName

toRecord :: [String] -> ByteString
toRecord parsedCSV = snoc (encodeUtf8 _title) 0 `append` snoc (encodeUtf8 _url) 0 `append` encodeUtf8 pub `append` "\n"
      where
        _title = pack $ parsedCSV !! 21
        _url = pack $ parsedCSV !! 22
        pub = pack $ parsedCSV !! 18
