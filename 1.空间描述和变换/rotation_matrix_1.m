% 1. 定义旋转矩阵 (3x3)
R_A_B = [0.866 -0.5 0; 0.5 0.866 0; 0 0 1];

% 2. 将 P_B 定义为列向量 (3x1)
P_B_1 = [1.732; 1; 0];  

% 3. 进行矩阵乘法
P_A_1 = R_A_B * P_B_1;
%MATLAB 的机械工具箱自带函数
%theta = pi/6;  旋转30度  180/6

%Rx = rotx(theta * 180 / pi);  绕X轴
%Ry = roty(theta * 180 / pi);  绕Y轴
%Rz = rotz(theta * 180 / pi);  绕Z轴
theta = 30;
Rx = rotx(theta);
Ry = roty(theta);
Rz = rotz(theta);
%P_A_2 =[0 ;1 ;1.732];
P_A_2 =[0  1  1.732]';
P_A_2_rx = Rx*P_A_2
