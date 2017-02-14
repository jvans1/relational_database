{-# LANGUAGE OverloadedStrings #-}
module Engine (executeQuery, parsePlan) where
import System.IO(openFile, IOMode(..), hSetBinaryMode)
import Data.Text(Text, unpack)
import Data.Text.Encoding(encodeUtf8)
import Data.Word8(_cr)
import qualified Data.ByteString.Lazy as BL

data Plan = Plan [Iterator] Scan
data Scan = SeqScan Text
data Iterator = Filter Int BL.ByteString [Iterator]
type Row = [BL.ByteString]

executeQuery :: Plan -> IO [Row]
executeQuery (Plan iterators scan) = parseRows iterators <$> runScan scan 

parseRows :: [Iterator] -> [Row] -> [Row]
parseRows (Filter rowNum value _:_) = filter (\row -> row !! rowNum == value) 

runScan :: Scan -> IO [Row]
runScan scan = splitRows <$> scanFile scan

splitRows :: BL.ByteString -> [Row]
splitRows = fmap (BL.split 0) . BL.split _cr

scanFile :: Scan -> IO BL.ByteString
scanFile (SeqScan filepath) = do
    handle <- openFile (unpack filepath) ReadMode
    hSetBinaryMode handle True
    BL.hGetContents handle

tread = read . unpack
tToBl= BL.fromStrict . encodeUtf8

parsePlan :: [Text] -> Plan
parsePlan ("table":table:"filter":rowNum:value:_) = Plan [Filter (tread rowNum) (tToBl value) []] (SeqScan table)
