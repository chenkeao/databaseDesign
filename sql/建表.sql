create database  material_manage;

use material_manage;

drop table if exists 学院;
create table 学院(
    id int auto_increment,
    名称 nvarchar(100) unique not null ,
    primary key (id)
);

drop table if exists 班级;
create table 班级(
    id int auto_increment,
    名称 nvarchar(100) not null unique ,
    年级 int not null ,
    学院ID int not null ,
    primary key (id),
    foreign key(学院ID)references 学院(id) on delete cascade on update cascade
);

drop table if exists 学生;
create table 学生(
    id int auto_increment,
    学号 char(15) not null unique ,
    姓名  nvarchar(100) ,
    性别 tinyint(1) not null , -- 1: male, 0:female
    出生日期 date not null ,
    班级ID int not null ,
    专业 varchar(100) not null ,
    状态 tinyint(1) not null , -- 1: able, 0: disable
    登录密码 varchar(50) not null ,
    手机号 char(11) not null unique ,
    职务 nvarchar(20),
    primary key (id),
    foreign key (班级ID) references 班级(id)on delete cascade on update cascade
);

drop table if exists 出版社;
create table 出版社(
    id int auto_increment,
    名称 nvarchar(100) not null unique ,
    地址 nvarchar(200),
    联系电话 char(11),
    状态 tinyint(1), -- 1:able, 0:disable
    primary key (id)
);

drop table if exists 教材;
create table 教材(
    id int auto_increment,
    名称 nvarchar(100) not null ,
    ISBN varchar(15) not null unique ,
    作者 nvarchar(100) not null ,
    出版社ID int not null ,
    出版日期 date ,
    价格 decimal(6, 2) ,
    库存数量 int  not null,
    内容简介 nvarchar(200) ,
    primary key(id),
    foreign key (出版社ID) references 出版社(id) on update cascade on delete cascade
);

drop table if exists 教材管理员;
create table 教材管理员(
    id int auto_increment,
    工号 char(15) not null unique ,
    姓名  nvarchar(100) ,
    性别 tinyint(1) not null , -- 1: male, 0: female
    出生日期 date not null ,
    状态 tinyint(1) not null , -- 1:able, 0: disable
    登录密码 varchar(50) not null ,
    手机号 char(11) not null unique ,
    职务 nvarchar(20),
    primary key (id)
);

drop table if exists 课程;
create table 课程(
    id int auto_increment,
    名称 nvarchar(100) not null ,
    primary key (id)
);

drop table if exists 课程教材表;
create table 课程教材表(
    课程ID int not null ,
    教材ID int not null ,
    primary key (课程ID, 教材ID),
    foreign key (课程ID) references 课程(id),
    foreign key (教材ID) references 教材(id)
);

drop table if exists 班级课程表;
create table 班级课程表(
    班级ID int not null ,
    课程ID int not null,
    学年 int not null ,
    学期 tinyint(1) not null, -- 0: first 1: second
    primary key (班级ID, 课程ID, 学年, 学期),
    foreign key (班级ID)references 班级(id)on delete cascade on update cascade ,
    foreign key (课程ID)references 课程(id)on delete cascade on update cascade
);

drop table if exists 教材领取表;
create table 教材领取表(
    班级ID int not null ,
    教材ID int not null ,
    教材管理员ID int not null ,
    数量 int not null ,
    时间 datetime not null ,
    学年 int not null ,
    学期 tinyint(1) not null, -- 0: first 1: second
    primary key (班级ID, 教材ID, 教材管理员ID),
    foreign key (班级ID) references 班级(id)on delete cascade on update cascade ,
    foreign key (教材ID)  references 教材(id)on delete cascade on update cascade,
    foreign key (教材管理员ID)  references 教材管理员(id)on delete cascade on update cascade
);

drop table if exists 教材预定表;
create table 教材预定表(
    学生ID int not null ,
    教材ID int not null ,
    学年 int not null ,
    学期 tinyint(1) not null, -- 0: first 1: second
    primary key (学生ID, 教材ID, 学年, 学期),
    foreign key (学生ID)references 学生(id)on delete cascade on update cascade ,
    foreign key (教材ID)references 教材(id)on delete cascade on update cascade
);

drop table if exists 入库表;
create table 入库表(
    教材ID int not null ,
    教材管理员ID int not null ,
    时间 datetime not null ,
    数量 int not null,
    学年 int not null ,
    学期 tinyint(1) not null, -- 0: first 1: second
    primary key (教材ID, 教材管理员ID, 学年, 学期),
    foreign key (教材ID) references 教材(id)on delete cascade on update cascade ,
    foreign key (教材管理员ID) references 教材管理员(id)on delete cascade on update cascade
);

drop table if exists 教材订购表;
create table 教材订购表(
    教材ID int not null ,
    教材管理员ID int not null ,
    时间 datetime not null ,
    数量 int not null ,
    学年 int not null ,
    学期 tinyint(1) not null, -- 0: first 1: second
    primary key (教材ID, 教材管理员ID, 学年, 学期),
    foreign key (教材管理员ID)references 教材管理员(id)on delete cascade on update cascade ,
    foreign key (教材ID) references 教材(id)on delete cascade on update cascade
);

-- 班级需订购教材清单
create or replace view 班级需预购教材清单 as
    select  f.id,f.名称 班级, f.年级 ,a.名称 教材, b.名称 出版社, a.ISBN, a.价格 from 教材 a
                        left join 出版社 b on a.出版社ID = b.id
                        right join 课程教材表 c on c.教材ID = a.id
                        left join 课程 d on c.课程ID = d.id
                        left join 班级课程表 e on d.id = e.课程ID
                        left join 班级 f on e.班级ID = f.id;

-- 学生需预购教材清单
create or replace view 学生需预购教材清单 as
    select a.学号, a.姓名, b.教材, b.ISBN, b.价格,b.出版社 from 学生 a
        left join 班级需预购教材清单 b on a.班级ID = b.id;


-- 学生需订购教材金额
create or replace view 学生需订购教材金额 as
    select 学号, 姓名, SUM(价格) as 总价格 from 学生需预购教材清单 group by 学号, 姓名;

create or replace view 教材预定清单 as
    select b.id,b.名称,a.学年,a.学期, COUNT(教材ID) as 总数量 from 教材预定表 a
        left join 教材 b on a.教材ID = b.id group by a.学年, a.学期, 教材ID, b.名称;

create or replace view 需订购教材清单 as
    select a.id, a.名称, a.ISBN, b.总数量 - a.数量 as 需订数量 ,
           (b.总数量 - a.数量)*a.价格 as 价格 ,c.名称 as 出版社名称,c.联系电话, c.地址,b.学年,b.学期 from 教材 a
        right join 教材预定清单 b on a.id = b.id left join 出版社 c on a.出版社ID = c.id
        where a.数量 < b.总数量;

