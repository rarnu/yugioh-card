-- noinspection SqlNoDataSourceInspectionForFile

-- noinspection SqlDialectInspectionForFile

create database YGOData character set utf8mb4;

-- card

create table Card(
    hash varchar(16) primary key,
    timeinfo bigint,
    data LONGTEXT,
    adjust LONGTEXT,
    wiki LONGTEXT
) character set utf8mb4;

create table CardLimit(
    timeinfo bigint,
    info LONGTEXT
) character set utf8mb4;

create table CardPack(
    timeinfo bigint,
    info LONGTEXT
) character set utf8mb4;

create table CardPackDetail(
    url varchar(128) primary key,
    timeinfo bigint,
    info LONGTEXT
) character set utf8mb4;

-- deck

create table DeckTheme(
    timeinfo bigint,
    info LONGTEXT
) character set utf8mb4;

create table DeckCategory(
    timeinfo bigint,
    info LONGTEXT
) character set utf8mb4;

create table DeckInCategory(
    hash varchar (128) primary key,
    timeinfo bigint,
    info LONGTEXT
) character set utf8mb4;

create table Deck(
    code varchar(64) primary key,
    timeinfo bigint,
    info LONGTEXT
) character set utf8mb4;

-- log

create table Log(
    id bigint primary key auto_increment,
    timeinfo bigint,
    req varchar(256) not null,
    result int default 0,
    waste bigint default 0,
    reason text
) character set utf8mb4;

-- account system
create table Users (
    id bigint primary key auto_increment,
    account varchar(128) not null,
    password varchar(128) not null, -- encrypted
    nickname varchar (64) not null,
    headimg varchar (128) default 'default.png',
    email varchar(256) default ''    -- only for find back password
) character set utf8mb4;

-- collect
create table Collect (
    id bigint primary key auto_increment,
    userid bigint not null,
    type int not null,          -- collect type: 0:card, 1:deck
    collectname varchar (128) not null,
    cardhash varchar(16) default '',
    deckdata LONGTEXT,
    timeinfo bigint
) character set utf8mb4;

