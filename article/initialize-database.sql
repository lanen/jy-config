CREATE SCHEMA IF NOT EXISTS article;
GRANT ALL PRIVILEGES ON article.* TO 'mysqluser'@'%' WITH GRANT OPTION;

USE article;

DROP table IF EXISTS events;
DROP table IF EXISTS  entities;
DROP table IF EXISTS  snapshots;
DROP table IF EXISTS cdc_monitoring;

create table events (
  event_id varchar(64) PRIMARY KEY,
  event_type varchar(128),
  event_data varchar(1000) NOT NULL,
  entity_type VARCHAR(128) NOT NULL,
  entity_id VARCHAR(62) NOT NULL,
  triggering_event VARCHAR(1000),
  metadata VARCHAR(1000),
  published TINYINT DEFAULT 0
);

CREATE INDEX events_idx ON events(entity_type, entity_id, event_id);
CREATE INDEX events_published_idx ON events(published, event_id);

create table entities (
  entity_type VARCHAR(128),
  entity_id VARCHAR(64),
  entity_version VARCHAR(64) NOT NULL,
  PRIMARY KEY(entity_type, entity_id)
);

CREATE INDEX entities_idx ON events(entity_type, entity_id);

create table snapshots (
  entity_type VARCHAR(128),
  entity_id VARCHAR(64),
  entity_version VARCHAR(64),
  snapshot_type VARCHAR(128) NOT NULL,
  snapshot_json VARCHAR(1000) NOT NULL,
  triggering_events VARCHAR(1000),
  PRIMARY KEY(entity_type, entity_id, entity_version)
);

create table cdc_monitoring (
  reader_id VARCHAR(62) PRIMARY KEY,
  last_time BIGINT
);

