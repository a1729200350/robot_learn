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
T_1_2 = [cos(theta2) -sin(theta2) 0 500;
         sin(theta2) cos(theta2)  0 0
         0 0 1 0
         0 0 0 1];
% --- 关节3 的变换矩阵 T_2_3 ---
T_2_3 = [cos(theta3) -sin(theta3) 0 400;
         sin(theta3) cos(theta3)  0 0
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

%% 6.数值代入计算计算
% 定义角度值 (MATLAB三角函数使用弧度，90度 = pi/2)
%th1t_val = -4.15*pi/180;
th1t_val = deg2rad(-4.15);
th2t_val = deg2rad(-38.3);
th3t_val = deg2rad(-2.57);
th1e_val = deg2rad(9.64);
th2e_val = deg2rad(-19.9);
th3e_val = deg2rad(31.8);
P_3_top=[0;150;0;1];
P_3_end=[0;-50;0;1];
% 代入数值
T_numt = subs(T_simplified, [theta1, theta2, theta3], [th1t_val, th2t_val, th3t_val]);
T_nume = subs(T_simplified, [theta1, theta2, theta3], [th1e_val, th2e_val, th3e_val]);
% 转换为双精度数值矩阵并显示
T_numt = double(T_numt);
T_nume = double(T_nume);
disp('变换矩阵 T_numt (脚趾姿态):');
disp(T_numt);
disp('变换矩阵 T_nume (脚跟姿态):');
disp(T_nume);
% 计算两个接触点的世界坐标
P_toe = T_numt * P_3_top;
P_heel = T_nume * P_3_end;
%计算步幅向量
step_v=P_heel-P_toe;
%计算步幅长度
step_length = norm(step_v(1:3));
disp('================ 步幅分析 ================');
fprintf('步幅向量: [%.2f, %.2f, %.2f] mm\n', step_v(1), step_v(2), step_v(3));
fprintf('步幅长度: %.2f mm\n', step_length);

%% 6. 可视化机械臂姿态
figure;
hold on; grid on; axis equal;
view(2); % 俯视图

% 绘制基座
plot(0, 0, 'k.', 'MarkerSize', 20);
text(0, 0, '  Base', 'FontSize', 12);

% --- 绘制姿态1：脚尖着地 (T_numt) ---
% 计算关节位置
P1_J1 = T_numt(1:3, 4); % 由于关节1在基座，位置为0，这里取T的平移部分作为验证
% 手动计算关节位置更直观：
% 关节1位置 (假设基座旋转，位置不变)
P1_J1 = [0;0;0]; 
% 关节2位置 = T_0_1 * [0;0;0;1]
T_0_1_num = double(subs(T_0_1, theta1, th1t_val));
P1_J2 = T_0_1_num * [0;0;0;1]; P1_J2 = P1_J2(1:3);
% 关节3位置 = T_0_1 * T_1_2 * [0;0;0;1]
T_1_2_num = double(subs(T_1_2, theta2, th2t_val));
P1_J3_temp = T_0_1_num * T_1_2_num * [0;0;0;1]; P1_J3 = P1_J3_temp(1:3);
% 脚尖位置
P1_Toe = P_toe(1:3);

% 连线
plot([P1_J1(1), P1_J2(1)], [P1_J1(2), P1_J2(2)], 'b-', 'LineWidth', 2);
plot([P1_J2(1), P1_J3(1)], [P1_J2(2), P1_J3(2)], 'b-', 'LineWidth', 2);
plot([P1_J3(1), P1_Toe(1)], [P1_J3(2), P1_Toe(2)], 'b-', 'LineWidth', 2);
plot(P1_Toe(1), P1_Toe(2), 'go', 'MarkerSize', 8, 'DisplayName', 'Toe Pos');

% --- 绘制姿态2：脚跟着地 (T_nume) ---
T_0_1_num_e = double(subs(T_0_1, theta1, th1e_val));
T_1_2_num_e = double(subs(T_1_2, theta2, th2e_val));
P2_J1 = [0;0;0];
P2_J2 = T_0_1_num_e * [0;0;0;1]; P2_J2 = P2_J2(1:3);
P2_J3_temp = T_0_1_num_e * T_1_2_num_e * [0;0;0;1]; P2_J3 = P2_J3_temp(1:3);
P2_Heel = P_heel(1:3);

plot([P2_J1(1), P2_J2(1)], [P2_J1(2), P2_J2(2)], 'r--', 'LineWidth', 2);
plot([P2_J2(1), P2_J3(1)], [P2_J2(2), P2_J3(2)], 'r--', 'LineWidth', 2);
plot([P2_J3(1), P2_Heel(1)], [P2_J3(2), P2_Heel(2)], 'r--', 'LineWidth', 2);
plot(P2_Heel(1), P2_Heel(2), 'mo', 'MarkerSize', 8, 'DisplayName', 'Heel Pos');

% 绘制步幅连线
plot([P1_Toe(1), P2_Heel(1)], [P1_Toe(2), P2_Heel(2)], 'g-', 'LineWidth', 1.5);
text((P1_Toe(1)+P2_Heel(1))/2, (P1_Toe(2)+P2_Heel(2))/2, sprintf('Step: %.1fmm', step_length));

title('机械臂步幅俯视图');
xlabel('X (mm)'); ylabel('Y (mm)');
legend('Location', 'best');