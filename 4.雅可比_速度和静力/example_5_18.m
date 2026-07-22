clc; clear;
%% 1. 定义符号变量
% 角度变量
syms theta1 theta2 theta3 real
%连杆长度
syms l1 l2 real
%% 2. 定义机器人正向运动解矩阵 
T_0_3 = [cos(theta1)*cos(theta2+theta3) -cos(theta1)*sin(theta2+theta3) sin(theta1)  l1*cos(theta1)+l2*cos(theta1)*cos(theta2);
       sin(theta1)*cos(theta2+theta3)   -sin(theta1)*sin(theta2+theta3) -cos(theta1) l1*sin(theta1)+l2*sin(theta1)*cos(theta2);
       sin(theta2+theta3)               cos(theta2+theta3)              0            l2*sin(theta2);
       0                                0                               0            1];
%% 3. 提取末端执行器位置向量 P
P = T_0_3(1:3, 4); 
P = simplify(P);
disp('末端位置向量 P:');
disp(P);
%% 4.计算线速度雅可比矩阵 J
J1 = diff(P, theta1);  % 第一列：对 theta1 求导
J2 = diff(P, theta2);  % 第二列：对 theta2 求导
J3 = diff(P, theta3);  % 第三列：对 theta3 求导
% 组合成雅可比矩阵 (3x3)
J = [J1, J2, J3];
% 化简结果
J = simplify(J);
disp('线速度雅可比矩阵 J:');
pretty(J);
