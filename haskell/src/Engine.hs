{-# LANGUAGE OverloadedStrings #-}
module Engine (executeQuery, parsePlan) where
import System.IO(openFile, IOMode(..), hSetBinaryMode)
import Data.Text(Text, unpack)
import Data.Text.Encoding(encodeUtf8)
import Data.Word8(_cr)
import qualified Data.ByteString.Lazy as BL

data Iterator =
  Filter Int BL.ByteString Iterator
  | SeqScan Text
  | CrossJoin Iterator Iterator
  | InnerJoin Iterator Iterator Column Column

type Column = Int
type Row = [BL.ByteString]

executeQuery :: Iterator -> IO [Row]
executeQuery (Filter num value next)                       = filterBy num value <$> executeQuery next
executeQuery (SeqScan table)                               = seqScan table
executeQuery j@CrossJoin{}                                 = crossJoin  j
executeQuery j@InnerJoin{}                                 = innerJoin j

innerJoin :: Iterator -> IO [Row]
innerJoin (InnerJoin scan1 scan2 rowIndex1 rowIndex2) = do
                        rows1 <- executeQuery scan1
                        rows2 <- executeQuery scan2
                        return $ filter (\x -> length x > 0) $ do
                          row1 <- rows1
                          row2 <- rows2
                          if row1 !! rowIndex1 == row2 !! rowIndex2 then return (row1 ++ row2)
                          else return []

crossJoin :: Iterator -> IO [Row]
crossJoin (CrossJoin scan1 scan2) = do
        rows1 <-  executeQuery scan1
        rows2 <-  executeQuery scan2
        return $ do
          row1 <- rows1
          row2 <- rows2
          return (row1 ++ row2)


filterBy :: Int -> BL.ByteString -> [Row] -> [Row]
filterBy rowNum rowVal = filter (\row -> length row > rowNum && row !! rowNum == rowVal)

seqScan :: Text -> IO [Row]
seqScan filepath = splitRows <$> scanFile filepath

splitRows :: BL.ByteString -> [Row]
splitRows x = filter (\x -> length x > 0) . fmap (BL.split 0) $ BL.split _cr x

scanFile :: Text -> IO BL.ByteString
scanFile filepath = do
    handle <- openFile (unpack filepath) ReadMode
    hSetBinaryMode handle True
    BL.hGetContents handle

tread = read . unpack
tToBl= BL.fromStrict . encodeUtf8

parsePlan :: [Text] -> Iterator
parsePlan ("table":table:"filter":rowNum:value:_)  = Filter (tread rowNum) (tToBl value) (SeqScan table)
parsePlan ("join":table1:table2:colNum1:colNum2:_) = InnerJoin (SeqScan table1) (SeqScan table2) (tread colNum1) (tread colNum2)
parsePlan ("join":table1:table2:_)                 = CrossJoin (SeqScan table1) (SeqScan table2)
