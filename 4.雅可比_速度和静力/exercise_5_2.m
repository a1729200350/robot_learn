clear;clc;
%% 1. 定义符号变量
% 关节变量 (通常是我们想求的未知数或输入变量)
syms theta1 theta2  theta3 real 

% 连杆参数 (结构参数，通常是固定的常数符号)
syms a1 a2 a3 L1 L2  L3 alpha1 alpha2 alpha3 real

%% 2. 定义改进DH变换矩阵函数
% --- 关节1 的变换矩阵 T_0_1 ---
T_0_1 = [cos(theta1) -sin(theta1) 0 0;
         sin(theta1) cos(theta1)  0 0
         0 0 1 0
         0 0 0 1];
% --- 关节2 的变换矩阵 T_1_2 ---
T_1_2 = [cos(theta2) -sin(theta2) 0 L1;
         0 0 -1 0
         sin(theta2) cos(theta2) 0 0
         0 0 0 1];
% --- 关节3 的变换矩阵 T_2_3 ---
T_2_3 = [cos(theta3) -sin(theta3) 0 L2;
         sin(theta3) cos(theta3) 0 0
         0 0 1 0
         0 0 0 1];
T_3_4 = [1 0 0 L3;
         0 1 0 0
         0 0 1 0
         0 0 0 1];
%% 3. 计算末端位姿 (矩阵连乘)
T_0_4 = T_0_1 * T_1_2*T_2_3*T_3_4;
%% 4. 化简结果 (关键步骤)
% 使用 simplify 进行代数化简和三角恒等式化简
disp('正在化简，请稍候... (符号计算可能较慢)...');
T_simplified = simplify(T_0_4);
%% 5. 显示结果
pretty(T_simplified);
%% 6. 提取位置向量和旋转矩阵
% 从总变换矩阵 T_simplified 中提取位置向量 p (第4列的前3行)
p = T_simplified(1:3, 4);

% 从总变换矩阵 T_simplified 中提取旋转矩阵 R (前3行前3列)
R = T_simplified(1:3, 1:3);

%% 7. 计算线速度雅可比矩阵
% 定义关节变量向量
q = [theta1, theta2, theta3];

% 对位置向量 p 求雅可比 (直接利用 MATLAB 的 jacobian 函数)
J_v = jacobian(p, q);

% 化简线速度部分
J_v = simplify(J_v);

%% 8. 计算角速度雅可比矩阵
% 原理：利用公式 omega = vect(dR/dtheta * R^T)
% 初始化角速度雅可比矩阵 
J_w = sym(zeros(3, 3)); 

% 循环计算每一列
for i = 1:3
    % 1. 求旋转矩阵对第 i 个关节角度的偏导数
    dR_dq = diff(R, q(i));
    disp('dR_dq:');
    pretty(dR_dq);
    % 2. 计算 S = (dR/dq) * R^T，得到反对称矩阵
    S = dR_dq * R';
    disp('S:');
    pretty(S);
    % 3. 从反对称矩阵中提取角速度分量
    % 反对称矩阵 S 形式:
    % [  0,   -w_z,  w_y ]
    % [ w_z,    0,  -w_x ]
    % [-w_y,  w_x,    0  ]
    
    % 按照位置提取元素
    w_x = S(3, 2); 
    w_y = S(1, 3); 
    w_z = S(2, 1); 
    
    % 填入 J_w 的第 i 列
    J_w(:, i) = simplify([w_x; w_y; w_z]);
end

%% 9. 合成总雅可比矩阵
J_total = [J_v; J_w];

%% 10. 显示最终结果
disp('线速度雅可比矩阵 J_v:');
pretty(J_v);
disp('角速度雅可比矩阵 J_w:');
pretty(J_w);
disp('基座坐标系完整的 6x3 雅可比矩阵计算完成。');
disp(J_total);
%% 11. 计算物体坐标系下的雅可比 
% 注意：R 定义为从 0 系到 4 系的旋转，

R_total = T_simplified(1:3, 1:3);

% 变换线速度部分
J_v_body = R_total' * J_v; 

% 变换角速度部分
J_w_body = R_total' * J_w;

% 合成物体雅可比
J_body = [J_v_body; J_w_body];

% 化简显示
J_body = simplify(J_body);

disp('物体坐标系下的雅可比矩阵:');
pretty(J_body);
