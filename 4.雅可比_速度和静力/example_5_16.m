clc; clear;
%% 1. 定义符号变量
% 角度变量
syms theta1 theta2 theta3 real
% 关节速度变量 (为了求出矩阵，我们需要显式表示速度)
syms d_theta1 d_theta2 d_theta3 real 

%% 2. 定义旋转矩阵 
% 第一个Z旋转
Rz1 = [cos(theta1) -sin(theta1) 0;
       sin(theta1)  cos(theta1) 0;
       0            0           1];
       
% Y旋转
Ry2 = [cos(theta2)   0  sin(theta2);
      0             1  0;
      -sin(theta2)  0  cos(theta2)];

% 第二个Z旋转
Rz3 = [cos(theta3) -sin(theta3) 0;
       sin(theta3)  cos(theta3) 0;
       0            0           1];

%% 3. 计算总旋转矩阵
R_zyz = Rz1 * Ry2 * Rz3;

%% 4. 计算角速度向量
% 方法：利用链式法则求导
% R_dot = (dR/dtheta1)*d_theta1 + (dR/dtheta2)*d_theta2 + ...

% 计算旋转矩阵的时间导数
R_dot = diff(R_zyz, theta1)*d_theta1 + ...
        diff(R_zyz, theta2)*d_theta2 + ...
        diff(R_zyz, theta3)*d_theta3;

% 计算反对称矩阵 Omega_skew = R_dot * R^T
Omega_skew = R_dot * transpose(R_zyz);

% 从反对称矩阵提取角速度分量
% [  0    -wz   wy ]
% [  wz    0   -wx ]
% [ -wy    wx   0  ]
omega_x = Omega_skew(3,2); % 对应元素位置 (3,2) 是 wx
omega_y = Omega_skew(1,3); % 对应元素位置 (1,3) 是 wy
omega_z = Omega_skew(2,1); % 对应元素位置 (2,1) 是 wz

omega_vec = simplify([omega_x; omega_y; omega_z]);

%% 5. 提取雅可比矩阵
% omega = J * [d_theta1; d_theta2; d_theta3]
% 使用 coeffs 或 jacobian 函数直接提取系数矩阵
J = jacobian(omega_vec, [d_theta1, d_theta2, d_theta3]);

disp('角速度表达式:');
disp(omega_vec);

disp('雅可比矩阵 (基座坐标系下):');
disp(J);

% 化简结果
pretty(simplify(J));
