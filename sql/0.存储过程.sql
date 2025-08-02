
delimiter $$
create or replace procedure 教材预购清单(in 开始日期 date, in 结束日期 date)
begin
    select b.教材编号, b.名称, count(a.学号) as 数量
    from 教材预购表 a
             left join 教材 b on a.教材编号 = b.教材编号
    where a.日期 >= 开始日期 and a.日期 <= 结束日期
    group by a.教材编号;
end $$
delimiter ;

delimiter $$
create or replace procedure 需订购教材清单(in 开始日期 date, in 结束日期 date)
begin
    select b.数量  as 库存数量,
           count(a.教材编号) as 预购数量,
           IF(count(a.教材编号) >= b.数量, count(a.教材编号) - b.数量, '无需订购') as 需订购数量
    from 教材预购表 a
             left join 教材 b on a.教材编号 = b.教材编号 and a.日期 >= 开始日期 and a.日期 <= 结束日期
    group by a.教材编号;
end $$
delimiter ;

