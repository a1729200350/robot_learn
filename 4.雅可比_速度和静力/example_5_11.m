clc;clear;
T_A_B = [0.866 -0.5  0 10
        0.5   0.866 0 0
        0     0     1 5
        0     0     0 1];
R_A_B = T_A_B(1:3, 1:3);
P_A_B = T_A_B(1:3, 4);
R_B_A = R_A_B';
% Px = [0, -z, y; z, 0, -x; -y, x, 0]
P_A_BX = [    0,    -P_A_B(3),  P_A_B(2);
          P_A_B(3),       0,    -P_A_B(1);
         -P_A_B(2),   P_A_B(1),       0   ];
V_A=[0;2;-3;1.414;1.414;0];
V_B=[R_B_A -R_B_A*P_A_BX
     zeros(3,3)     R_B_A]         *V_A;
disp('变换后的速度 V_B:');
disp(V_B);