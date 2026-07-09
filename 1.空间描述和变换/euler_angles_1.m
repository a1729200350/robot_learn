%欧拉变换 绕自身轴旋转
%规定绕z、y、x  依次旋转alpha 、beta、gamma 角度

%先绕x轴旋转60° 再绕y轴旋转30°
gamma = 60 ;
beta = 30 ;
R_A_B_1 = rotx(gamma)*roty(beta)
%先绕y轴旋转30° 再绕x轴旋转60°
gamma = 60 ;
beta = 30 ;
R_A_B_2 = roty(beta)*rotx(gamma)


