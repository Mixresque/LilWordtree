-- DROP DATABASE IF EXISTS wordtree;
-- CREATE DATABASE wordtree;
-- USE wordtree;

DROP TABLE IF EXISTS FREQUENCY;
DROP TABLE IF EXISTS CORPUS;
DROP TABLE IF EXISTS TOPIC;
DROP TABLE IF EXISTS DERIVED;
DROP TABLE IF EXISTS HYPONYM;
DROP TABLE IF EXISTS HYPERNYM;
DROP TABLE IF EXISTS ANTONYM;
DROP TABLE IF EXISTS MEANS;
DROP TABLE IF EXISTS SYN;
DROP TABLE IF EXISTS MORPH;
DROP TABLE IF EXISTS LEMMA;

CREATE TABLE LEMMA (
  lid INT(8) UNSIGNED NOT NULL,
  lName VARCHAR(128) NOT NULL,
  numSyllables INT(3) UNSIGNED,
  isCommon boolean NOT NULL DEFAULT 0,
  PRIMARY KEY (lid)
);

CREATE TABLE MORPH (
  mid INT(8) UNSIGNED NOT NULL,
  mName VARCHAR(64) NOT NULL,
  lid INT(8) UNSIGNED NOT NULL,
  pos ENUM('n','v','a', 'r', 's', 'l') NOT NULL,
  PRIMARY KEY (mid),
  FOREIGN KEY (lid) REFERENCES LEMMA(lid)
);

CREATE TABLE SYN (
  sid INT(8) UNSIGNED NOT NULL,
  definition mediumtext NOT NULL,
  pos ENUM('n','v','a', 'r', 's', 'l') NOT NULL,
  PRIMARY KEY (sid)
);

CREATE TABLE MEANS (
  lid INT(8) UNSIGNED NOT NULL,
  sid INT(8) UNSIGNED NOT NULL,
  PRIMARY KEY (lid, sid),
  FOREIGN KEY (sid) REFERENCES SYN(sid),
  FOREIGN KEY (lid) REFERENCES LEMMA(lid)
);

CREATE TABLE ANTONYM (
  sid1 INT(8) UNSIGNED NOT NULL,
  sid2 INT(8) UNSIGNED NOT NULL,
  PRIMARY KEY (sid1, sid2),
  FOREIGN KEY (sid1) REFERENCES SYN(sid),
  FOREIGN KEY (sid2) REFERENCES SYN(sid)
);

CREATE TABLE HYPERNYM (
  childsid INT(8) UNSIGNED NOT NULL,
  parentsid INT(8) UNSIGNED NOT NULL,
  PRIMARY KEY (childsid, parentsid),
  FOREIGN KEY (childsid) REFERENCES SYN(sid),
  FOREIGN KEY (parentsid) REFERENCES SYN(sid)
);

CREATE TABLE HYPONYM (
  parentsid INT(8) UNSIGNED NOT NULL,
  childsid INT(8) UNSIGNED NOT NULL,
  PRIMARY KEY (parentsid, childsid),
  FOREIGN KEY (parentsid) REFERENCES SYN(sid),
  FOREIGN KEY (childsid) REFERENCES SYN(sid),
  INDEX (parentsid),
  INDEX (childsid)
);

CREATE TABLE DERIVED (
  parentsid INT(8) UNSIGNED NOT NULL,
  parentlid INT(8) UNSIGNED NOT NULL,
  childsid INT(8) UNSIGNED NOT NULL,
  childlid INT(8) UNSIGNED NOT NULL,
  PRIMARY KEY (parentsid, parentlid, childsid, childlid),
  FOREIGN KEY (parentsid) REFERENCES SYN(sid),
  FOREIGN KEY (parentlid) REFERENCES LEMMA(lid),
  FOREIGN KEY (childsid) REFERENCES SYN(sid),
  FOREIGN KEY (childlid) REFERENCES LEMMA(lid)
);

CREATE TABLE TOPIC (
  topicid INT(4) UNSIGNED NOT NULL,
  tName varchar(32) NOT NULL,
  ptopicid INT(4) UNSIGNED NOT NULL,
  PRIMARY KEY (topicid),
  FOREIGN KEY (ptopicid) REFERENCES TOPIC(topicid)
);

INSERT INTO TOPIC VALUES (0, 'all', 0);

CREATE TABLE CORPUS (
  cid INT(8) UNSIGNED NOT NULL,
  filename VARCHAR(255) NOT NULL,
  freScore FLOAT(32),
  fkgScore FLOAT(32),
  dcScore FLOAT(32),
  vsize INT(8) UNSIGNED,
  topicid INT(4) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (cid),
  FOREIGN KEY (topicid) REFERENCES TOPIC(topicid)
);

CREATE TABLE FREQUENCY (
  cid INT(8) UNSIGNED NOT NULL,
  lid INT(8) UNSIGNED NOT NULL,
  frequency INT(32) UNSIGNED NOT NULL,
  PRIMARY KEY (cid, lid),
  FOREIGN KEY (cid) REFERENCES CORPUS(cid),
  FOREIGN KEY (lid) REFERENCES LEMMA(lid)
);
