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
    班级名称 nvarchar(100) not null unique ,
    年级 int not null ,
    学院ID int not null ,
    primary key (id),
    foreign key(学院ID)references 学院(id) on delete cascade on update cascade
);


drop table if exists 学生;
create table 学生(
    学号 char(15) not null unique ,
    姓名  nvarchar(100) ,
    性别 tinyint not null ,
    出生日期 date not null ,
    id int auto_increment,
    班级ID int not null ,
    状态 tinyint not null ,
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
    primary key (id)
);

drop table if exists 教材;
create table 教材(
    id int auto_increment,
    名称 nvarchar(100) not null ,
    作者 nvarchar(100) not null ,
    出版社ID int not null ,
    出版日期 date not null ,
    版本 tinyint not null ,
    ISBN varchar(15) not null unique ,
    价格 decimal(6, 2) not null,
    数量 int not null ,
    内容简介 nvarchar(200) ,
    primary key(id),
    foreign key (出版社ID) references 出版社(id) on update cascade
);



drop table if exists 供应商;
create table 供应商(
    id int auto_increment,
    名称 nvarchar(100) not null unique,
    地址 nvarchar(200) not null ,
    联系电话 char(11) not null ,
    状态 tinyint not null ,
    邮箱 nvarchar(100) ,
    primary key (id)
);


drop table if exists 身份;
create table 身份(
    id int auto_increment,
    名称 nvarchar(100) not null unique,
    primary key (id)
);


drop table if exists 教务人员;
create table 教务人员(
    id int auto_increment,
    工号 char(15) not null unique ,
    姓名  nvarchar(100) ,
    性别 tinyint not null ,
    出生日期 date not null ,
    状态 tinyint not null ,
    身份ID int not null ,
    登录密码 varchar(50) not null ,
    手机号 char(11) not null unique ,
    primary key (id),
    foreign key (身份ID)references 身份(id)on delete cascade on update cascade
);

drop table if exists 课程;
create table 课程(
    id int auto_increment,
    名称 nvarchar(100) not null ,
    教材ID int not null ,
    primary key (id)
);

drop table if exists 班级课程表;
create table 班级课程表(
    班级ID int not null ,
    课程ID int not null,
    primary key (班级ID, 课程ID),
    foreign key (班级ID)references 班级(id)on delete cascade on update cascade ,
    foreign key (课程ID)references 课程(id)on delete cascade on update cascade
);

drop table if exists 教材领取表;
create table 教材领取表(
    班级ID int not null ,
    教材ID int not null ,
    数量 int not null ,
    时间 datetime not null ,
    primary key (班级ID, 教材ID),
    foreign key (班级ID) references 班级(id)on delete cascade on update cascade ,
    foreign key (教材ID)  references 教材(id)on delete cascade on update cascade
);

drop table if exists 教材预定表;
create table 教材预定表(
    学生ID int not null ,
    教材ID int not null ,
    预定意愿 tinyint not null ,
    时间 datetime not null ,
    primary key (学生ID, 教材ID),
    foreign key (学生ID)references 学生(id)on delete cascade on update cascade ,
    foreign key (教材ID)references 教材(id)on delete cascade on update cascade
);

drop table if exists 库存变动表;
create table 库存变动表(
    教材ID int not null ,
    教务人员ID int not null ,
    时间 datetime not null ,
    数量 int not null,
    primary key (教材ID, 教务人员ID, 时间),
    foreign key (教材ID) references 教材(id)on delete cascade on update cascade ,
    foreign key (教务人员ID) references 教务人员(id)on delete cascade on update cascade
);

drop table if exists 教材订购表;
create table 教材订购表(
    教材ID int not null ,
    教务人员ID int not null ,
    时间 datetime not null ,
    数量 int not null ,
    供应商ID int not null ,
    primary key (教材ID, 教务人员ID, 供应商ID, 时间),
    foreign key (教务人员ID)references 教务人员(id)on delete cascade on update cascade ,
    foreign key (教材ID) references 教材(id)on delete cascade on update cascade ,
    foreign key (供应商ID) references 供应商(id)on update cascade
);

-- 查询出每个学生所需的教材清单
create or replace view 学生所需教材清单 as
    select d.班级名称,d.年级,e.姓名,e.学号, a.名称, a.作者, a.价格 ,a.ISBN from 教材 a
        right join 课程 b on b.教材ID = a.id
        left join 班级课程表 c on b.id = c.课程ID
        left join 班级 d on c.班级ID = d.id
        right join 学生 e on d.id = e.班级ID;



create or replace view 班级所需教材清单 as
    select d.id as 班级ID,d.班级名称,d.年级, a.名称, a.作者, a.价格 ,a.ISBN from 教材 a
        right join 课程 b on b.教材ID = a.id
        left join 班级课程表 c on b.id = c.课程ID
        right join 班级 d on c.班级ID = d.id;

create or replace view 学生所需教材总价 as
    select a.姓名, SUM(a.价格) as 总价 from  学生所需教材清单 a group by a.学号, a.姓名;

create or replace view 班级所需教材总价 as
    select a.班级名称, SUM(a.价格) as 总价 from  班级所需教材清单 a group by a.班级ID, a.班级名称;

