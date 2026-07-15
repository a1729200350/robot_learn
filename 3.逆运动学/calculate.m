%p78  图4-8
clc; clear;
% 输入具体数值
x = 3; 
y = 5; 
l1 = 5; 
l2 = 2;
phi=45;
k=-1;% -1代表肘部向上
% 计算c2（用于求解theta2）
c2 = (x^2 + y^2 - l1^2 - l2^2) / (2 * l1 * l2);

% 计算theta2（关节角度2）
theta2 = k*acosd(c2);

% 计算psi（姿态角）
psi = acosd((x^2 + y^2 + l1^2 - l2^2) / (2 * l1 * sqrt(x^2 + y^2)));

% 根据theta2的符号计算theta1（关节角度1）
if theta2 < 0
    theta1 = atan2d(y, x) + psi;
else
    theta1 = atan2d(y, x) - psi;
end

% 计算theta3（关节角度3）
theta3 = phi - theta1 - theta2;

% 显示结果（使用 num2str 将数字转为字符串以便拼接显示）
disp('关节角度计算结果（度）：');
disp(['theta1 = ', num2str(theta1), '°']);
disp(['theta2 = ', num2str(theta2), '°']);
disp(['theta3 = ', num2str(theta3), '°']);
disp(['psi = ', num2str(psi), '°']);
