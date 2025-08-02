use material_manage;

delimiter $$
create or replace trigger 删除订购单
    after delete
    on 订购单
    for each row
begin
    delete
    from 教材订购表
    where 教材订购表.订购单编号 = OLD.订购单编号;
end
$$
delimiter ;

delimiter $$
create or replace trigger 删除入库单
    after delete
    on 入库单
    for each row
begin
    delete
    from 教材入库表
    where 教材入库表.入库单编号 = OLD.入库单编号;
end
$$
delimiter ;

delimiter $$
create or replace trigger 删除出库单
    after delete
    on 出库单
    for each row
begin
    delete
    from 教材出库表
    where 教材出库表.出库单编号 = OLD.出库单编号;
end
$$
delimiter ;

delimiter $$
create or replace trigger 删除教材入库
    after delete
    on 教材入库表
    for each row
begin
    update 教材 set 数量 = 数量 - old.数量 where 教材编号 = old.教材编号;
end
$$
delimiter ;

delimiter $$
create or replace trigger 删除教材出库
    after delete
    on 教材出库表
    for each row
begin
    update 教材 set 数量 = 数量 + old.数量 where 教材编号 = old.教材编号;
end
$$
delimiter ;

delimiter $$
create or replace trigger 新增教材入库
    after insert
    on 教材入库表
    for each row
begin
    update 教材 set 数量 = 数量 + new.数量 where 教材编号 = new.教材编号;
end
$$
delimiter ;

delimiter $$
create or replace trigger 新增教材出库
    after insert
    on 教材出库表
    for each row
begin
    update 教材 set 数量 = 数量 - new.数量 where 教材编号 = new.教材编号;
end
$$
delimiter ;


delimiter $$
create or replace trigger 检查教材出库
    before insert
    on 教材出库表
    for each row
begin
    select 教材.数量 from 教材 where 教材.教材编号 = new.教材编号 into @库存数量;
    if new.数量 > @库存数量 then
        signal sqlstate '45000'
            set message_text = '出库数量超过库存数量';
    end if;
end $$
delimiter ;

delimiter $$
create or replace trigger 检查教材领取
    before insert
    on 教材领取表
    for each row
begin
    select a.预购数量
    from 班级预购教材清单 a
    where a.班级编号 = new.班级编号
      and a.教材编号 = new.教材编号
    into @待领取数量;

    if new.数量 > @待领取数量 then
        signal sqlstate '45000'
            set message_text = '领取数量超过预购数量';
    end if;
end $$
delimiter ;


