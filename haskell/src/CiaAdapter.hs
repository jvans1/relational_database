{-# LANGUAGE OverloadedStrings #-}

module CiaAdapter(parseFiles)  where
import Data.Monoid(mconcat)
import Data.Word8(_cr)
import Data.ByteString.Char8(ByteString, append)
import Data.ByteString(snoc)
import qualified Data.ByteString as BS
import Data.Text.Encoding(encodeUtf8)
import Data.Either(rights)
import Data.Text hiding (append, snoc)
import Data.CSV(csvFile)
import Text.Parsec.Error(ParseError)
import Text.ParserCombinators.Parsec.Prim(parseFromFile)


fileNames = ["cia-crest-files-cia-crest-archive-metadata/6_export.csv"]

parseFiles :: IO ()
parseFiles = recordsFromCSVs >>= (BS.writeFile "cia" . mconcat)

recordsFromCSVs :: IO [ByteString]
recordsFromCSVs = mconcat . rights <$> mapM recordsFromCSV fileNames

recordsFromCSV :: String -> IO (Either ParseError [ByteString])
recordsFromCSV fileName = (fmap $ (fmap toRecord)) <$> parseFromFile csvFile "test_data.csv"

toRecord :: [String] -> ByteString
toRecord parsedCSV = field _title `append` field _url `append` snoc (encodeUtf8 pub) _cr
      where
        _title = pack $ parsedCSV !! 0
        _url = pack $ parsedCSV !! 1
        pub = pack $ parsedCSV !! 2


field :: Text -> ByteString
field f = snoc (encodeUtf8 f) 0
