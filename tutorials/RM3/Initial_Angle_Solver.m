function Theta_Initial=Initial_Angle_Solver(r,l,dr)
format long;
%========================================================================%
%Slider-Crank initialization

%global r                    % Radius of crank. used again in the rk4sys_step function and slider crank function.
%global l                    % Length of rod, used again in the slider crank function.
%global dr                   % (Used to be r+A) Distance between the lowest edge of the crank and the reference water surface
%========================================================================%

f1=@(u)(dr-sqrt(l^2-(r*sin(u))^2))/r;
f2=@(u)cos(u);
Theta_Initial=pi/2;
err=1;

while err>1e-12
    f1n=f1(Theta_Initial);
    f2n=f2(Theta_Initial);
    Theta_Initial=acos(f1n);
    err=abs(f1n-f2n);
end
% disp('The Initial Angle is (in radian): ');
% disp(Theta_Initial);
% disp('In degrees: ');
% disp(Theta_Initial/pi*180);
