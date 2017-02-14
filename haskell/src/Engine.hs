{-# LANGUAGE OverloadedStrings #-}
module Engine (executeQuery, parsePlan) where
import System.IO(openFile, IOMode(..), hSetBinaryMode)
import Data.Text(Text, unpack)
import Data.Text.Encoding(encodeUtf8)
import Data.Word8(_cr)
import qualified Data.ByteString.Lazy as BL

data JoinType = CrossProduct
data Iterator = Filter Int BL.ByteString Iterator | SeqScan String | Join Text Text Text Text JoinType
type Row = [BL.ByteString]

executeQuery :: Iterator -> IO [Row]
executeQuery (Filter num value next)                  = filterBy num value <$> executeQuery next
executeQuery (SeqScan table)                          = seqScan table
executeQuery j@(Join _ _ _ _ _)                       = joinTables j

joinTables :: Iterator -> IO [Row]
joinTables (Join table1 col1 table2 col2 CrossProduct) = do
        rows1 <-  seqScan (unpack table1)
        rows2 <-  seqScan (unpack table1)
        return $ do
          row1 <- (tail rows1)
          row2 <- (tail rows2)
          return (row1 ++ row2)


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
parsePlan ("join":table1:col1:table2:col2:_)      = Join table1 col1 table2 col2 CrossProduct
