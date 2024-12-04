module Day2
  ( solveA,
    solveB,
  )
where

import Data.List (sort)

solveA :: String -> Int
solveA = length . filter id . map isSafe . parseInput

solveB :: String -> Int
solveB = length . filter id . map isSafe' . parseInput
  where
    isSafe' = any isSafe . sublists
    sublists xs = map (deleteAt xs) [0 .. length xs]
    deleteAt xs idx = left ++ drop 1 right
      where
        (left, right) = splitAt idx xs

isSafe :: (Ord a, Num a) => [a] -> Bool
isSafe xs = (isIncreasing || isDecreasing) && (all isSafeLevel $ map diff $ adjacentPairs sorted)
  where
    sorted = sort xs
    isIncreasing = sorted == xs
    isDecreasing = sorted == reverse xs

isSafeLevel :: (Ord a, Num a) => a -> Bool
isSafeLevel a = 1 <= a && a <= 3

adjacentPairs :: [b] -> [(b, b)]
adjacentPairs = zip <*> drop 1

diff :: (Num a) => (a, a) -> a
diff (x, y) = abs $ x - y

parseInput :: String -> [[Int]]
parseInput = map (map toInt . words) . lines
  where
    toInt :: String -> Int
    toInt = read
