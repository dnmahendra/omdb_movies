CREATE TABLE movies (

id SERIAL4 PRIMARy KEY NOT NULL,
title VARCHAR(100),
year SERIAL4,
runtime VARCHAR(30),
language VARCHAR(30),
country VARCHAR(50),
genre VARCHAR(100),
director VARCHAR(100),
plot TEXT,
rating VARCHAR(10),
poster VARCHAR(200)

);

INSERT INTO movies (title,year,runtime,language,country,genre,director,plot,rating,poster)
VALUES ()