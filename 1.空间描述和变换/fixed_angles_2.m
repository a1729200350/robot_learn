%旋转矩阵反解旋转角度
%绕x、y、z轴以此旋转
R_A_B_xyz =[0.866 0.433 0.25 ; 0 0.5 -0.866 ; -0.5 0.75 0.433];
%绕y轴的角β
beta  = atan2d(-R_A_B_xyz(3,1),sqrt(R_A_B_xyz(1,1)^2+R_A_B_xyz(2,1)^2))
%绕z轴的角α
alpha = atan2d((R_A_B_xyz(2,1)/cosd(beta)),(R_A_B_xyz(1,1)/cosd(beta)))
%绕x轴的角γ
gamma = atan2d((R_A_B_xyz(3,2)/cosd(beta)),R_A_B_xyz(3,3)/cosd(beta))
%弧度制 转化角度 *180/pi  或者在函数结尾加d