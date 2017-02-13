{-# LANGUAGE OverloadedStrings #-}
module Main where
import Data.Word(Word8)
import System.IO(openFile, hClose, IOMode(..))
import Control.Exception(bracket)
import Data.ByteString.Char8(hGetLine)
import Control.Monad(forM_)
import Data.Text(pack)
import Engine
import System.Environment(getArgs)
import CiaAdapter(parseFiles)
import qualified Data.ByteString as BS
import qualified Data.ByteString.Lazy as LB


newline :: Word8
newline = LB.head "\n"

nullByte :: Word8
nullByte = 0

printLine :: LB.ByteString -> IO ()
printLine line = LB.putStr (formatLine line)  >> LB.putStr "\n"

formatLine :: LB.ByteString -> LB.ByteString
formatLine = LB.intercalate "::::" . (LB.split nullByte)

splitLines :: LB.ByteString -> [LB.ByteString]
splitLines = take 5 . LB.splitWith (== newline)

printLines :: [LB.ByteString] -> IO ()
printLines = mapM_ printLine

main :: IO ()
main =
  bracket (openFile "cia" ReadMode) hClose $ \handle -> do
    LB.hGetContents handle >>= printLines . splitLines
