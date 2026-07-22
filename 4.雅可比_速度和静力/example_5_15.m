clc;clear;
%% 1. 定义符号变量
syms theta1 theta3 d2 real 
syms L2 L3 real

%% 2. 定义DH变换矩阵
% --- 关节1 (R) ---
T_0_1 = [cos(theta1) -sin(theta1) 0 0;
         sin(theta1) cos(theta1)  0 0;
         0 0 1 0;
         0 0 0 1];
% --- 关节2 (P) ---
T_1_2 = [1 0 0 0;
         0 0 -1 -d2;
         0 1 0 0;
         0 0 0 1];
% --- 关节3 (R) ---
T_2_3 = [cos(theta3) -sin(theta3) 0 0;
         sin(theta3) cos(theta3)  0 0;
         0 0 1 L2;
         0 0 0 1];
% --- 关节4 (工具) ---
T_3_4 = [1 0 0 0;
         0 1 0 0;
         0 0 1 L3;
         0 0 0 1];

%% 3. 计算末端位姿
T_0_4 = T_0_1 * T_1_2 * T_2_3 * T_3_4;

%% 4. 提取末端执行器位置向量 P
P = T_0_4(1:3, 4); 

% 化简方便观察
P = simplify(P);
disp('末端位置向量 P:');
disp(P);

%% 5. 计算线速度雅可比矩阵 J (直接对位置向量微分)
% 定义雅可比矩阵的3列
J1 = diff(P, theta1);  % 第一列：对 theta1 求导
J2 = diff(P, d2);      % 第二列：对 d2 求导 
J3 = diff(P, theta3);  % 第三列：对 theta3 求导

% 组合成雅可比矩阵 (3x3)
J = [J1, J2, J3];

% 化简结果
J = simplify(J);

%% 6. 显示结果
disp('线速度雅可比矩阵 J:');
pretty(J);
