drop database if exists material_manage;
create database material_manage;

use material_manage;

drop table if exists 学院;
create table 学院
(
    学院编号 char(12),
    名称     nvarchar(100) unique not null,
    primary key (学院编号)
);

drop table if exists 班级;
create table 班级
(
    班级编号 char(12),
    班级名称 nvarchar(100) not null unique,
    学院编号 char(12)      not null,
    年级     int           not null,
    primary key (班级编号),
    foreign key (学院编号) references 学院 (学院编号)
);

drop table if exists 学生;
create table 学生
(
    学号     char(12),
    姓名     nvarchar(100),
    性别     tinyint(1)   not null, -- 1: male, 0:female
    出生日期 date         not null,
    班级编号 char(12)     not null,
    专业     varchar(100) not null,
    状态     tinyint(1)   not null, -- 1: able, 0: disable
    登录密码 varchar(50)  not null,
    联系电话 char(11) unique,
    职务     nvarchar(20),
    primary key (学号),
    foreign key (班级编号) references 班级 (班级编号)
);

drop table if exists 出版社;
create table 出版社
(
    出版社编号 char(12),
    名称       nvarchar(100) not null unique,
    地址       nvarchar(200),
    联系电话   char(11),
    primary key (出版社编号)
);

drop table if exists 教材;
create table 教材
(
    教材编号   char(12),
    名称       nvarchar(100) not null,
    ISBN       varchar(15)   not null unique,
    作者       nvarchar(100) not null,
    出版社编号 char(12)      not null,
    获奖等级   nvarchar(100),
    出版日期   date,
    价格       decimal(6, 2),
    数量       int default 0,
    内容简介   nvarchar(200),
    primary key (教材编号),
    foreign key (出版社编号) references 出版社 (出版社编号)
);

drop table if exists 教材管理员;
create table 教材管理员
(
    工号     char(12),
    姓名     nvarchar(100),
    性别     tinyint(1)  not null, -- 1: male, 0: female
    出生日期 date,
    状态     tinyint(1)  not null, -- 1:able, 0: disable
    登录密码 varchar(50) not null,
    联系电话 char(11) unique,
    职务     nvarchar(20),
    primary key (工号)
);

drop table if exists 课程;
create table 课程
(
    课程编号 char(12),
    名称     nvarchar(100) not null,
    primary key (课程编号)
);

drop table if exists 订购单;
create table 订购单
(
    订购单编号 char(12),
    管理员工号 char(12),
    金额       decimal(10, 2),
    时间       datetime,
    状态       tinyint(1),
    primary key (订购单编号),
    foreign key (管理员工号) references 教材管理员 (工号)
);

drop table if exists 入库单;
create table 入库单
(
    入库单编号 char(12),
    订购单编号 char(12),
    管理员工号 char(12),
    数量       decimal(10, 2),
    时间       datetime,
    状态       tinyint(1),
    primary key (入库单编号),
    foreign key (管理员工号) references 教材管理员 (工号),
    foreign key (订购单编号) references 订购单 (订购单编号)
);

drop table if exists 出库单;
create table 出库单
(
    出库单编号 char(12),
    管理员工号 char(12),
    数量       decimal(10, 2),
    时间       datetime,
    状态       tinyint(1),
    primary key (出库单编号),
    foreign key (管理员工号) references 教材管理员 (工号)
);

drop table if exists 供应商;
create table 供应商
(
    供应商编号 char(12),
    名称       nvarchar(100) not null unique,
    地址       nvarchar(200),
    联系电话   char(11),
    primary key (供应商编号)
);

drop table if exists 课程教材表;
create table 课程教材表
(
    课程编号 char(12),
    教材编号 char(12),
    primary key (课程编号, 教材编号),
    foreign key (课程编号) references 课程 (课程编号),
    foreign key (教材编号) references 教材 (教材编号)
);

drop table if exists 班级课程表;
create table 班级课程表
(
    班级编号 char(12) not null,
    课程编号 char(12) not null,
    primary key (班级编号, 课程编号),
    foreign key (班级编号) references 班级 (班级编号),
    foreign key (课程编号) references 课程 (课程编号)
);

drop table if exists 教材预购表;
create table 教材预购表
(
    学号     char(12) not null,
    教材编号 char(12) not null,
    primary key (学号, 教材编号),
    foreign key (学号) references 学生 (学号),
    foreign key (教材编号) references 教材 (教材编号)
);

drop table if exists 教材评价表;
create table 教材评价表
(
    学号     char(12),
    教材编号 char(12),
    评分     tinyint,
    评语     nvarchar(200),
    primary key (学号, 教材编号),
    foreign key (学号) references 学生 (学号),
    foreign key (教材编号) references 教材 (教材编号)
);


drop table if exists 教材订购表;
create table 教材订购表
(
    教材编号   char(12),
    订购单编号 char(12),
    供应商编号 char(12),
    时间       datetime       not null default now(),
    数量       int            not null,
    金额       decimal(10, 2) not null,
    状态       tinyint(1)     not null, -- 0:未完成 1:完成
    primary key (教材编号, 订购单编号),
    foreign key (教材编号) references 教材 (教材编号),
    foreign key (订购单编号) references 订购单 (订购单编号)
);


drop table if exists 教材入库表;
create table 教材入库表
(
    教材编号   char(12),
    入库单编号 char(12),
    时间       datetime not null default now(),
    数量       int      not null,
    primary key (入库单编号, 教材编号),
    foreign key (教材编号) references 教材 (教材编号),
    foreign key (入库单编号) references 入库单 (入库单编号)

);

drop table if exists 教材出库表;
create table 教材出库表
(
    教材编号   char(12),
    出库单编号 char(12),
    时间       datetime not null default now(),
    数量       int      not null,
    primary key (出库单编号, 教材编号),
    foreign key (教材编号) references 教材 (教材编号),
    foreign key (出库单编号) references 出库单 (出库单编号)
);

drop table if exists 教材领取表;
create table 教材领取表
(
    班级编号 char(12) not null,
    教材编号 char(12) not null,
    数量     int      not null,
    时间     datetime not null default now(),
    primary key (班级编号, 教材编号),
    foreign key (班级编号) references 班级 (班级编号),
    foreign key (教材编号) references 教材 (教材编号)
);

drop table if exists 教材供应表;
create table 教材供应表
(
    教材编号   char(12),
    供应商编号 char(12),
    售价       decimal(6, 2),
    primary key (教材编号, 供应商编号),
    foreign key (教材编号) references 教材 (教材编号),
    foreign key (供应商编号) references 供应商 (供应商编号)
);