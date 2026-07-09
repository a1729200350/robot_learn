%绕固定轴旋转
theta_1 = 60;
theta_2 = 30;
Rx = rotx(theta_1);%绕x轴旋转60°
Ry = roty(theta_2);%绕y轴旋转30°
R_A_B_1 = Ry*Rx
R_A_B_2 = Rx*Ry