-- noinspection SqlNoDataSourceInspectionForFile

-- noinspection SqlDialectInspectionForFile

create database YGOData character set utf8mb4;

create table Card(
    hash varchar(16) primary key,
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
    url varchar(128) primary key ,
    info LONGTEXT
) character set utf8mb4;