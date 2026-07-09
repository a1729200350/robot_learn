%由欧拉xyz变换后得出的R_A_b旋转矩阵 求解欧拉zyz变换的欧拉角
R_A_B_xyz=[0.866 0 0.5;0.433 0.5 -0.75;-0.25 0.866 0.433];
%绕y轴旋转β角
beta  = atan2d(sqrt((R_A_B_xyz(3,1))^2+(R_A_B_xyz(3,2)^2)),R_A_B_xyz(3,3))
%绕z轴旋转α角
alpha = atan2d((R_A_B_xyz(2,3)/sind(beta)),(R_A_B_xyz(1,3)/sind(beta))) %/sind(beta)可以去除 避开了为零或180 奇异位置 除数为零  
%绕z轴旋转γ角
gamma = atan2d((R_A_B_xyz(3,2)/sind(beta)),((-R_A_B_xyz(3,1))/sind(beta)))  
%先对z轴转-56.3°，再对y轴转64.3°最后对z轴转73.9°