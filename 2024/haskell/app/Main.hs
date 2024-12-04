module Main where

import Day1 qualified
import System.Environment (getArgs)
import Text.Printf (printf)

myApp :: [String] -> IO ()
myApp [day, part] = do
  input <- readFile $ printf "inputs/day%s.input" day
  putStrLn $ invoke day part input
  where
    invoke "1" "A" input = show $ Day1.solveA input
    invoke "1" "B" input = show $ Day1.solveB input
    invoke _ _ _ = printf "Day %s, part %s was not solved in Haskell" day part
myApp _ = putStrLn "Usage: app <day> <part>"

main :: IO ()
main = do
  args <- getArgs
  myApp args
