use material_manage;


insert into 出版社 (id, 名称, 地址, 联系电话)
values (id, '现代教育出版社', NULL, NULL);
insert into 出版社 (id, 名称, 地址, 联系电话)
values (id, '电子工业出版社', NULL, NULL);
insert into 出版社 (id, 名称, 地址, 联系电话)
values (id, '清华大学出版社', NULL, NULL);
insert into 出版社 (id, 名称, 地址, 联系电话)
values (id, '高等教育出版社', NULL, NULL);
insert into 出版社 (id, 名称, 地址, 联系电话)
values (id, '华南理工大学出版社', NULL, NULL);
insert into 出版社 (id, 名称, 地址, 联系电话)
values (id, '国防工业出版社', NULL, NULL);

insert into 教材 values(id, '新时代大学生就业指导', '李北群', 1,20180101, 1 ,'9787510682414', 30, 0,NULL);
insert into 教材 values(id, '数字图像处理及MATLAB实现', '杨杰', 2,20130801, 2 ,'9787121209895', 35, 0,NULL);
insert into 教材 values(id, '操作系统教程', '骆彬', 3,20100101, 6 ,'9787040553048', 40, 0,NULL);
insert into 教材 values(id, 'Python程序设计基础', '董付国', 4,20100303, 1 ,'9787302490562', 35, 0,NULL);
insert into 教材 values(id, '通信原理', '曹丽娜', 5,20190101, 7 ,'9787118087680', 55.5, 0,NULL);
insert into 教材 values(id, '概率论与数理统计', '盛骤', 6,20180101, 4 ,'9787040238969', 27, 0,NULL);
insert into 教材 values(id, '电子技术基础', '范娟', 3,20100101, 1 ,'9787302354697', 19.9, 0,NULL);
insert into 教材 values(id, '自动控制原理', '陈来好', 6,20190101, 4 ,'9787562338635', 39.9, 0,NULL);
insert into 教材 values(id, '企业管理学', '杨善林', 2,20180101, 4 ,'9787040526851', 77.9, 0,NULL);
insert into 教材 values(id, '计算机算法设计与分析', '匿名', 1,20180101, 5 ,'978712134498', 55, 0,NULL);
insert into 教材 values(id, '数据结构(C语言版)', '严蔚敏', 3,20180101, 3 ,'978730214751', 44.9, 0,NULL);

insert into 学院 values (id, '应用技术学院');
insert into 学院 values (id, '人工智能学院');
insert into 学院 values (id, '电子与信息工程学院');
insert into 学院 values (id, '地理科学学院');

insert into 班级 values (id, '计科1班', 2019,1 );
insert into 班级 values (id, '计科2班', 2019,1 );
insert into 班级 values (id, '会计1班', 2019,1 );
insert into 班级 values (id, '会计2班', 2019,1 );
insert into 班级 values (id, '软工2班', 2019,1 );
insert into 班级 values (id, '软工1班', 2019,1 );

insert into 课程 values (id, '概率统计',6);
insert into 课程 values (id, '数据结构',11);
insert into 课程 values (id, '就业指导',1);

insert into 班级课程表 values (1, 2);
insert into 班级课程表 values (1, 1);


insert into 学生 values ('201933050010', '陈可傲', '1', 20000305, id, 1,1,'056613', '17777773377',NULL);
insert into 学生 values ('201933050001', '郭壮', '1', 20000305, id, 1,1,'056613', '17777773375',NULL);
insert into 学生 values ('201933050002', '刘维龙', '1', 20000305, id, 1,1,'056613', '17777773373',NULL);
insert into 学生 values ('201933050003', '张三', '1', 20000305, id, 1,1,'056613', '17777773371',NULL);
insert into 学生 values ('201933050004', '紫薇', '1', 20000305, id, 1,1,'056613', '17777773311',NULL);
insert into 学生 values ('201933050005', '小燕子', '1', 20000305, id, 1,1,'056613', '17777773354',NULL);
insert into 学生 values ('201933050006', '甄姬', '1', 20000305, id, 1,1,'056613', '17777773309',NULL);
insert into 学生 values ('201933050007', '曹操', '1', 20000305, id, 1,1,'056613', '17777773177',NULL);
insert into 学生 values ('201933050008', '关羽', '1', 20000305, id, 1,1,'056613', '17667723377',NULL);
insert into 学生 values ('201933050009', '马超', '1', 20000305, id, 1,1,'056613', '17557773377',NULL);
insert into 学生 values ('201933050011', '康熙', '1', 20000305, id, 1,1,'056613', '17711773377',NULL);

select * from 学生