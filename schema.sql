CREATE SCHEMA bundesliga;

-- Entitites

CREATE TABLE bundesliga.league (
  league_number integer PRIMARY KEY
);


CREATE TABLE bundesliga.club (
  club_id       integer PRIMARY KEY,
  club_name     varchar(32) NOT NULL,
  league_number integer REFERENCES bundesliga.league
);

CREATE TABLE bundesliga.player (
  id            serial PRIMARY KEY,
  number        smallint NOT NULL, -- everybody should have a number
  nationality   varchar(32), 
  goals         smallint DEFAULT 0, -- pele got 1279 goals in his lifetime, so max. 32767 is enough 
  club_id       integer REFERENCES bundesliga.club
);

CREATE TABLE bundesliga.game (
  game_id       serial PRIMARY KEY, -- serial does auto_increment
  date          date NOT NULL, 
  begin         time NOT NULL, -- game date and begin have to be set 
  home          integer REFERENCES bundesliga.club (club_id),
  guest         integer REFERENCES bundesliga.club (club_id),
  home_score    integer DEFAULT 0 NOT NULL,
  guest_score   integer DEFAULT 0 NOT NULL
);