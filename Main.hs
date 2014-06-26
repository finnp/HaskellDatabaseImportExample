module Main (
             main  -- main-function
            )
  where
  
  -- imports --
  import Control.Monad
  import Control.Exception
  import Database.HDBC
  import Database.HDBC.PostgreSQL
  import Data.List.Split
  import Data.Char

  -- functions --
  main :: IO ()
  -- http://book.realworldhaskell.org/read/using-databases.html

  -- could be added
  -- readCSV :: String -> [[String]]

  
  main = handleSqlError $ do 
            conn <- connectPostgreSQL "host=localhost dbname=bundesliga5 user=finn password=root"
            
            -- IMPORT LIGA
            putStrLn "IMPORT LIGA";
            contents <- readFile "/home/vagrant/dbs/bundesliga-data/bundesliga_Liga.csv";
            let rows = drop 1 $ lines contents;
            let output = map (splitOn ";") rows
            forM_ output $ \line -> do 
              -- fields
              let league_number =  read (line!!0) :: Int;
              run conn "INSERT INTO bundesliga.league (league_number) VALUES (?);" [iToSql league_number]
              putStrLn $ show $ league_number;
              return();
            
            -- IMPORT  CLUB
            putStrLn "IMPORT CLUB"
            contents <- readFile "/home/vagrant/dbs/bundesliga-data/bundesliga_Verein.csv";
            let rows = drop 1 $ lines contents;
            let output = map (splitOn ";") rows
            forM_ output $ \line -> do 
              -- fields
              let vID =  read (line!!0) :: Int;
              let name =      (line!!1);
              let liga = read (line!!2) :: Int;
              run conn "INSERT INTO bundesliga.club (club_id, club_name, league_number) VALUES (?, ?, ?);" [iToSql vID, toSql name, toSql liga]
              putStrLn $ show $ name;
              return();
              
            -- IMPORT GAME
            putStrLn "IMPORT GAME"
            contents <- readFile "/home/vagrant/dbs/bundesliga-data/bundesliga_Spiel.csv";
            let rows = drop 1 $ lines contents;
            let output = map (splitOn ";") rows
            forM_ output $ \line -> do 
              -- fields
              let spielID =  read (line!!0) :: Int;
              let datum =  (line!!2);
              let uhrzeit = (line!!3);
              let heim = read(line!!4) :: Int;
              let gast = read(line!!5) :: Int;
              let toreHeim = read(line!!6) :: Int;
              let toreGast = read(line!!7) :: Int;
              run conn "INSERT INTO  bundesliga.game (game_id, \"date\", \"begin\", home, guest, home_score, guest_score)  VALUES (?, ?, ?, ?, ?, ?, ?);" 
                [iToSql spielID, toSql datum, toSql uhrzeit, iToSql heim, iToSql gast, iToSql toreHeim, iToSql toreGast]
              putStrLn $ show $ spielID;
              return();
            
            -- IMPORT PLAYER
            putStrLn "IMPORT PLAYER"
            contents <- readFile "/home/vagrant/dbs/bundesliga-data/bundesliga_Spieler.csv";
            let rows = drop 1 $ lines contents;
            let output = map (splitOn ";") rows
            forM_ output $ \line -> do 
              -- fields
              let spielerID =  read (line!!0) :: Int;
              let vereinsID =  read (line!!1) :: Int;
              let trikotNr =  read (line!!2) :: Int;
              let spielerName = (line!!3);
              let land =  (line!!4);
              let spiele =  read (line!!5) :: Int;
              let tore =  read (line!!6) :: Int;
              let vorlagen =  read (line!!7) :: Int;
              

              run conn "INSERT INTO  bundesliga.player(\"id\", \"number\", \"nationality\", \"goals\", \"club_id\") VALUES (?, ?, ?, ?, ?);" 
                [iToSql spielerID, iToSql trikotNr, toSql land, iToSql tore, iToSql vereinsID]
              putStrLn $ show $ spielerName;
              return();   

            rows <- quickQuery' conn "SELECT * FROM bundesliga.player;" []       -- do a query
            forM_ rows $ \row -> putStrLn $ show row;                -- print the query; forM_ :: Monad m => [a] -> (a -> m b) -> m ()

            disconnect conn;
