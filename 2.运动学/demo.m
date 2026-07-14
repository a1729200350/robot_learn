%% 1. 定义符号变量
% 关节变量 (通常是我们想求的未知数或输入变量)
syms theta1 theta2 real 

% 连杆参数 (结构参数，通常是固定的常数符号)
syms a1 a2 d1 d2 alpha1 alpha2 real

%% 2. 定义改进DH变换矩阵函数
% 为了方便，我们可以定义一个函数句柄，或者直接写矩阵
% 这里演示直接写第1个和第2个关节的变换矩阵

% --- 关节1 的变换矩阵 T1 ---
% 改进DH顺序: Rot(x, alpha) -> Trans(x, a) -> Rot(z, theta) -> Trans(z, d)
T1 = [cos(theta1), -sin(theta1), 0, a1;
      sin(theta1)*cos(alpha1), cos(theta1)*cos(alpha1), -sin(alpha1), -d1*sin(alpha1);
      sin(theta1)*sin(alpha1), cos(theta1)*sin(alpha1),  cos(alpha1),  d1*cos(alpha1);
      0, 0, 0, 1];

% --- 关节2 的变换矩阵 T2 ---
T2 = [cos(theta2), -sin(theta2), 0, a2;
      sin(theta2)*cos(alpha2), cos(theta2)*cos(alpha2), -sin(alpha2), -d2*sin(alpha2);
      sin(theta2)*sin(alpha2), cos(theta2)*sin(alpha2),  cos(alpha2),  d2*cos(alpha2);
      0, 0, 0, 1];

%% 3. 计算末端位姿 (矩阵连乘)
T_end = T1 * T2;

%% 4. 化简结果 (关键步骤)
% 直接计算出来的 T_end 会非常长，包含大量嵌套的 cos sin
% 使用 simplify 进行代数化简和三角恒等式化简
disp('正在化简，请稍候... (符号计算可能较慢)...');
T_simplified = simplify(T_end);

%% 5. 显示结果
disp('末端位置 X 坐标:');
pretty(T_simplified(1,4)) % pretty函数可以让输出格式更像数学书

disp('末端位置 Y 坐标:');
pretty(T_simplified(2,4))

%% 6. (进阶) 代入具体数值验证
% 假设你想看 theta1=pi/2, theta2=0 时的结果
% 使用 subs 函数
val = subs(T_simplified, [theta1, theta2, a1, a2, d1, d2, alpha1, alpha2], ...
                      [pi/2, 0, 1, 1, 0, 0, 0, 0]);
            
disp('代入数值后的矩阵:');
disp(double(val)); % double将符号结果转为浮点数
