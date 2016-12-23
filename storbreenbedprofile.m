%constants
g = 9.81;%m/s
rho = 800;% kg/m3 ice density??

L = 3000; %glacier length in m
dx = 10; %define gridsize
x = 0:dx:L;%spatial coordinate x
xpr = 0:dx/L:1; %spatial coordinate x which is x scaled by 

gridsize = length(x);

taum = 200; %in kPa
delta = 0.15;

%calculate the values of tau
tau = zeros(gridsize,1); %define array of tau values
for i = 1:gridsize
    tau(i) = taum/(1+delta)*((1-(xpr(i)-0.5)/0.5)^3+delta);
end


%use some sort of data set for h??
h = ones(gridsize,1);
for i = floor(gridsize/2)+1:gridsize
    h(i) = 1650-(i-gridsize/2)/gridsize*2*200; %linear decrease from 1650 to 1450, 
    %this is just a bad approximation from the map.
end
for i = 1:floor(gridsize/2)
    h(i) = 2050-i/gridsize*2*400; %linear decrease from 2050 to 1650
end

%calculate H
H = zeros(gridsize,1); %define array of H values
for i = 1:gridsize-1
    deriv = min(abs((h(i+1)-h(i)))/dx,0.01);%use minimal value of 0.01
    H(i) = tau(i)/rho/g/deriv;
end
H(gridsize) = tau(gridsize)/rho/g/deriv; %use last value for lower boundary 
%(as there is no derivative there to calculate)

%calculate bed profile from h and H
b = zeros(gridsize,1);
for i = 1:gridsize
    b(i) = h(i) - H(i);
end

%plot the bed profile
figure(1);
plot(x,H);
title('Ice thickness');
figure(2)
plot(x,b);
title('Bed profile');