clear;clc;
%% 1. 定义符号变量
% 关节变量 (通常是我们想求的未知数或输入变量)
syms theta1 theta2  theta3 real 

% 连杆参数 (结构参数，通常是固定的常数符号)
syms a1 a2 a3 d1 d2  d3 alpha1 alpha2 alpha3 real

%% 2. 定义改进DH变换矩阵函数
% --- 关节1 的变换矩阵 T_0_1 ---
T_0_1 = [cos(theta1) -sin(theta1) 0 0;
         sin(theta1) cos(theta1)  0 0
         0 0 1 0
         0 0 0 1];
% --- 关节2 的变换矩阵 T_1_2 ---
T_1_2 = [cos(theta2) -sin(theta2) 0 d1;
         0 0 -1 0
         sin(theta2) cos(theta2) 0 0
         0 0 0 1];
% --- 关节3 的变换矩阵 T_2_3 ---
T_2_3 = [cos(theta3) -sin(theta3) 0 d2;
         sin(theta3) cos(theta3) 0 0
         0 0 1 0
         0 0 0 1];

%% 3. 计算末端位姿 (矩阵连乘)
T_0_3 = T_0_1 * T_1_2*T_2_3;

%% 4. 化简结果 (关键步骤)
% 使用 simplify 进行代数化简和三角恒等式化简
disp('正在化简，请稍候... (符号计算可能较慢)...');
T_simplified = simplify(T_0_3);

%% 5. 显示结果
pretty(T_simplified);