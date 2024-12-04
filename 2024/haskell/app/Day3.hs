{-# LANGUAGE OverloadedStrings #-}

module Day3
  ( solveA,
    solveB,
  )
where

import Data.Char (isDigit)
import Data.Text qualified as T

solveA :: String -> Int
solveA = sum . map mul . filter isValidArgs . map (T.takeWhile (/= ')')) . T.splitOn "mul(" . T.pack

isValidArgs :: T.Text -> Bool
isValidArgs t = T.all isValidChar t
  where
    isValidChar ch = isDigit ch || ch == ','

mul :: T.Text -> Int
mul = product . parse
  where
    parse = map toInt . T.splitOn ","

toInt :: T.Text -> Int
toInt = read . T.unpack

solveB :: String -> Int
solveB = extractResult . execute
  where
    extractResult (_, x) = x
    execute = foldl' execute' (True, 0) . splitOnAnyOf ["mul(", "do"] . T.pack
    execute' (do', acc) instr =
      if T.isPrefixOf "()" instr
        then (True, acc)
        else
          if T.isPrefixOf "n't()" instr
            then (False, acc)
            else
              if do' && isValidArgs (adjustInstr instr)
                then
                  (do', acc + (mul $ adjustInstr instr))
                else (do', acc)
      where
        adjustInstr = (T.takeWhile (/= ')'))

-- based on https://stackoverflow.com/a/49240295
splitOnAnyOf :: (Foldable t) => t T.Text -> T.Text -> [T.Text]
splitOnAnyOf ds xs = foldl' (\ys d -> ys >>= T.splitOn d) [xs] ds
