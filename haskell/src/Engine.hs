{-# LANGUAGE OverloadedStrings #-}
module Engine (executeQuery, parsePlan) where
import System.IO(openFile, IOMode(..), hSetBinaryMode)
import Data.Text(Text, unpack)
import Data.Text.Encoding(encodeUtf8)
import Data.Word8(_cr)
import qualified Data.ByteString.Lazy as BL

data Iterator = Filter Int BL.ByteString Iterator | SeqScan String
type Row = [BL.ByteString]

executeQuery :: Iterator -> IO [Row]
executeQuery (Filter num value next) = filterBy num value <$> executeQuery next
executeQuery (SeqScan table)         = seqScan table

filterBy :: Int -> BL.ByteString -> [Row] -> [Row]
filterBy rowNum rowVal = filter (\row -> length row > rowNum && row !! rowNum == rowVal)

seqScan :: FilePath -> IO [Row]
seqScan filepath = splitRows <$> scanFile filepath

splitRows :: BL.ByteString -> [Row]
splitRows = fmap (BL.split 0) . BL.split _cr

scanFile :: FilePath -> IO BL.ByteString
scanFile filepath = do
    handle <- openFile filepath ReadMode
    hSetBinaryMode handle True
    BL.hGetContents handle

tread = read . unpack
tToBl= BL.fromStrict . encodeUtf8

parsePlan :: [Text] -> Iterator
parsePlan ("table":table:"filter":rowNum:value:[]) = Filter (tread rowNum) (tToBl value) (SeqScan $ unpack table)
