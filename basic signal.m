clc
close all
clear all

n = -10:20

u = [zeros(1,10) 1 ones(1,20)]

figure (1)

plot(n,u);
hold on
stem(n,u)
xlabel('Time/discrete intervals');
ylabel('Unit step function');
grid on

uI = [zeros(1,10) 1 zeros(1,20)]


figure (2)

plot(n,uI);
hold on
stem(n,uI)
xlabel('Time/discrete intervals');
ylabel('Unit impulse function');
grid on
axis([-10 20 0 1.2]);

%% sinusoidial signal
n = 0:40;

f = 0.1;

A = 1.5;

p = 0;

arg = ( 2 * pi * f * n + p );

x = sin(arg);


figure (3)

plot(n,x);
stem(n,x);
hold on

stem(n,x);

xlabel('Time/discrete intervals');

ylabel('sine wave');

grid on

%% Discrete Time real exponential signal

n = 0: 35;

c = 0.2;

alpha = 1.2;

x = c * alpha.^n;

figure(4)

stem(n,x)

xlabel('Time/Discrete interval');

ylabel('Real exponent of value');

grid on

%% Complex ecponential value
omega=0.15;
phi=pi/6;
c=-((omega)+phi)*i;
k=2;
n=0:40;
x=k*exp(c*n);
r=real(x);
img=imag(x);
figure(5)
subplot(2,1,1)
stem(n,r)
xlabel('Time/discrete intervals');
ylabel('real expoonent wave');
title('real part');
subplot(2,1,2)
stem(n,img)
xlabel('Time/discrete intervals');
ylabel('imaginary expoonent wave');
title('imaginary part');




