clear;clc;
%% 1. 定义符号变量
% 关节变量 (通常是我们想求的未知数或输入变量)
syms theta1 theta2  theta3 theta4 theta1_dot theta2_dot  theta3_dot d_dot_4 real 

% 连杆参数 (结构参数，通常是固定的常数符号)
syms   l1 l2 l_toe  real
%% 2.计算旋转矩阵
R_0_1=[cos(theta1) -sin(theta1) 0
       sin(theta1) cos(theta1)  0
       0           0            1];
R_1_2=[cos(theta2) -sin(theta2) 0
       sin(theta2) cos(theta2)  0
       0           0            1];
R_2_3=[cos(theta3) -sin(theta3) 0
       sin(theta3) cos(theta3)  0
       0           0            1];
R_3_4=[cos(theta4) -sin(theta4) 0
       sin(theta4) cos(theta4)  0
       0           0            1];
R_0_4=R_0_1*R_1_2*R_2_3*R_3_4;
%% 3.计算角速度和线速度
%omega_i+1_i+1=R_i+1_i*omega_i_i+theta_dot_i+1*Z_i+1_i+1;
%v_i+1_i+1 =R_i+1_i(v_i_i+omega_i_i×P_i_i+1;
omega_1_1=[0;0;theta1_dot];
v_1_1=[0; 0; 0; ];
omega_2_2=R_1_2*omega_1_1+[0;0;theta2_dot];
P_1_2=[l1 0 0]';
v_2_2=[cos(theta2) sin(theta2) 0
       -sin(theta2) cos(theta2)  0
       0           0            1]*(v_1_1+cross(omega_1_1,P_1_2));

%disp(v_2_2);
omega_3_3 =[cos(theta3) sin(theta3) 0
       -sin(theta3) cos(theta3)  0
       0           0            1]*omega_2_2+[0 0 theta3_dot]';
%disp(omega_3_3);
P_2_3=[l2 0 0]';
v_3_3=[cos(theta3) sin(theta3) 0
       -sin(theta3) cos(theta3)  0
       0           0            1]*(v_2_2+cross(omega_2_2,P_2_3));
%disp(simplify(v_3_3));
% 关节3代表脚踝 关节4 代表脚尖 他们之间没有相对运动 故theta4_dot=0
omega_4_4=[cos(theta4) sin(theta4) 0
       -sin(theta4) cos(theta4)  0
       0           0            1]*omega_3_3+[0 0 0]';
%disp(omega_4_4);
P_3_4=[0  l_toe 0]';
v_4_4=[cos(theta4) sin(theta4) 0
       -sin(theta4) cos(theta4)  0
       0           0            1]*(v_3_3+cross(omega_3_3,P_3_4)); 
%disp(simplify(v_4_4));
%omega_0_4=R_0_4*omega_4_4;
%v_0_4=R_0_4*v_4_4;
%% 4.带入数值计算 求解线速度速度+角速度雅可比
% 具体几何参数 (单位: 米)
val_l1 = 0.500;   
val_l2 = 0.400;   
val_l_toe = 0.150; 
% 设定关节角度 (单位: 弧度)
val_theta1 = deg2rad(10.5);
val_theta2 = deg2rad(-44);
val_theta3 = deg2rad(3.55);
val_theta4 = 0;       %脚趾与脚踝无相对转动
%v_0_4=[v_0_4;omega_0_4];
% --- 执行代入操作 ---
% subs(表达式, {旧符号列表}, {新数值列表})
v_4_4_num = subs(v_4_4, ...
    {l1, l2, l_toe, theta1,theta2,theta3, theta4, }, ...
    {val_l1, val_l2, val_l_toe, val_theta1,val_theta2,val_theta3,val_theta4,});
R_0_4_num = subs(R_0_4,...
    {theta1,theta2,theta3,theta4},...
    {val_theta1,val_theta2,val_theta3,val_theta4});
%disp(double(R_0_4_num));
J = jacobian(v_4_4_num, [theta1_dot, theta2_dot, theta3_dot]);
disp(double(simplify(J)));

%% 5.计算所需关节力矩
%所需力坐标系转换 0->4
F_0=[95 0 0]';
F_4=R_0_4_num'*F_0;
%disp(double(F_4));
J_T=transpose(J);
tao=J_T*F_4;
disp(double(tao));