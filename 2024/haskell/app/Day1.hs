module Day1
  ( solveA,
    solveB,
  )
where

import Data.List (sort)
import Text.Printf (perror)

solveA :: String -> Int
solveA = foldr (+) 0 . map diff . zipTuple . sortLists . parseInput
  where
    sortLists (x, y) = (sort x, sort y)
    zipTuple (x, y) = zip x y
    diff (x, y) = abs $ x - y

solveB :: String -> Int
solveB = foldr (+) 0 . score . parseInput
  where
    count xs x = length $ filter (== x) xs
    similarity ys x = x * (count ys x)
    score (xs, ys) = map (similarity ys) xs

pairs :: [String] -> (Int, Int)
pairs [x, y] = (read x, read y)
pairs _ = perror "Invalid input"

parseInput :: String -> ([Int], [Int])
parseInput = unzip . map (pairs . words) . lines
