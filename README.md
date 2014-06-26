HaskellDatabaseImportExample
==================

A simple haskell-program using a database and HDBC. Originally forked from https://github.com/xconnect/HelloDatabaseWorldHaskell and
adapted for postgreSQL. Import example with data from http://dbup2date.uni-bayreuth.de/bundesliga.html not included in the repository.

## Install Haskell and Cabal (on a Ubuntu Machine)
```
sudo apt-get install cabal-install ghc
```

## postgreSQL

```
sudo apt-get install postgresql
sudo apt-get install postgresql-server-dev-9.1
createdb bundesliga
```

## Haskell Dependencies

```
cabal install HDBC
cabal install HDBC-postgresql
```
