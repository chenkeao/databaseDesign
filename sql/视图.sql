use material_manage;
-- 班级需订购教材清单
create or replace view 班级需预购教材清单 as
select f.班级编号,
       f.班级名称 班级,
       f.年级,
       a.名称     教材,
       a.教材编号,
       b.名称     出版社,
       a.ISBN,
       a.价格
from 教材 a
         inner join 出版社 b on a.出版社编号 = b.出版社编号
         inner join 课程教材表 c on c.教材编号 = a.教材编号
         inner join 课程 d on c.课程编号 = d.课程编号
         inner join 班级课程表 e on d.课程编号 = e.课程编号
         inner join 班级 f on e.班级编号 = f.班级编号;

-- 学生需预购教材清单
create or replace view 学生需预购教材清单 as
select a.学号,
       a.姓名,
       b.教材,
       b.教材编号,
       b.ISBN,
       b.价格,
       b.出版社
from 学生 a
         left join 班级需预购教材清单 b on a.班级编号 = b.班级编号;

-- 学生需订购教材金额
create or replace view 学生需订购教材金额 as
select 学号, 姓名, SUM(价格) as 总价格
from 学生需预购教材清单
group by 学号, 姓名;

-- 学生预购教材清单
create or replace view 学生预购教材清单 as
select b.教材编号, b.名称, count(a.学号) as 数量
from 教材预购表 a
         left join 教材 b on a.教材编号 = b.教材编号
group by a.教材编号;

create or replace view 班级预购教材清单 as
select a.教材编号, c.班级编号, c.班级名称, d.名称, count(a.教材编号) as 预购数量, d.ISBN
from 教材预购表 a
         left join 学生 b on a.学号 = b.学号
         left join 班级 c on c.班级编号 = b.班级编号
         left join 教材 d on a.教材编号 = d.教材编号
group by c.班级编号, a.教材编号;

create or replace view 需订购教材清单 as
select a.教材编号, b.名称 as 教材名称, a.数量 - b.数量 as 需订购数量, c.名称 as 出版社名称, b.ISBN, b.作者
from 学生预购教材清单 a
         left join 教材 b on a.教材编号 = b.教材编号
         left join 出版社 c on b.出版社编号 = c.出版社编号
where a.数量 > b.数量;

create or replace view 教材供应清单 as
select a.教材编号, a.教材名称, c.名称, c.地址, c.联系电话, b.售价
from 需订购教材清单 a
         left join 教材供应表 b on a.教材编号 = b.教材编号
         left join 供应商 c on b.供应商编号 = c.供应商编号;

create or replace view 教材订购清单 as
select a.订购单编号, a.时间 as 订购时间, b.教材编号, b.名称 as 教材名称, a.金额, c.名称 as 供应商名称, a.数量 as 订购数量
from 教材订购表 a
         left join 教材 b on a.教材编号 = b.教材编号
         left join 供应商 c on a.供应商编号 = c.供应商编号
where a.状态 = 0
group by a.订购单编号, a.教材编号;

insert into 入库单 (入库单编号, 订购单编号, 管理员工号, 数量, 时间, 状态)
values ('000000000001', '000000000001', '1', NULL, default, 0);
insert into 教材入库表 (教材编号, 入库单编号, 数量)
values ('189', '000000000001', 2);

create or replace view 待入库教材清单 as
select e.教材编号,
       e.名称,
       e.数量                                          as 现存数量,
       ifnull(sum(b.数量), 0)                          as 总订购数,
       ifnull(sum(d.数量), 0)                          as 已入库数,
       ifnull(sum(b.数量), 0) - ifnull(sum(d.数量), 0) as 待入库数
from 订购单 a
         left join 教材订购表 b on a.订购单编号 = b.订购单编号
         left join 入库单 c on a.订购单编号 = c.订购单编号
         left join 教材入库表 d on c.入库单编号 = d.入库单编号 and d.教材编号 = b.教材编号
         left join 教材 e on b.教材编号 = e.教材编号
where a.状态 = 0
group by b.教材编号;

create or replace view 待领取教材清单 as
select a.名称, a.预购数量, ifnull(b.数量, 0) as 已领数量, a.预购数量 - ifnull(b.数量, 0) as 待领数量
from 班级预购教材清单 a
         left join 教材领取表 b on a.教材编号 = b.教材编号 and a.班级编号 = b.班级编号
where a.预购数量 > ifnull(b.数量, 0);

create or replace view 教材领取清单 as
select c.班级名称, b.名称, a.数量, a.时间
from 教材领取表 a
         left join 教材 b on a.教材编号 = b.教材编号
         left join 班级 c on a.班级编号 = c.班级编号;


create or replace view 教材评价清单 as
select a.学号,
       a.教材编号,
       c.姓名,
       b.名称,
       b.ISBN,
       b.作者,
       a.评分,
       a.评语
from 教材评价表 a
         left join 教材 b on a.教材编号 = b.教材编号
         left join 学生 c on a.学号 = c.学号;

create or replace view 教材平均评分 as
select a.名称, avg(a.评分) as 平均分
from 教材评价清单 a
group by a.教材编号

