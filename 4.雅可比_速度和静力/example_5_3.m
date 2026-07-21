clc;clear;
%% 1. 定义符号变量
syms theta1 theta2  theta1_dot theta2_dot real
% 连杆参数 
syms  L1 L2   real
%% 2.数值运算
R_0_1=[cos(theta1) -sin(theta1) 0
       sin(theta1) cos(theta1)  0
        0           0           1];
R_1_2=[cos(theta2) -sin(theta2) 0
       sin(theta2) cos(theta2)  0
        0           0           1];
R_2_3=eye(3);
v_3_3=[L1*theta1_dot*sin(theta2)
       L1*theta1_dot*cos(theta2)+L2*(theta1_dot+theta2_dot)
       0];
omega_3_3=[0;0;theta1_dot+theta2_dot];
%求出旋转矩阵R_0_3  
R_0_3=R_0_1*R_1_2*R_2_3;
% disp(simplify(R_0_3));
%求出最终3对0的线速度
v_0_3=R_0_3*v_3_3;
disp(simplify(v_0_3));

