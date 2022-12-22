%%AM signal
clc
close all
clear all

n = 1: 100; 

m = 0.4;

fh = 0.1;

fl = 0.01;

xh = sin(2 * pi * fh *n );

xl = sin(2 * pi * fl *n );

y = (1 + m*xl).*xh;

stem(n,y)

grid;

xlabel('time index');

ylabel('amplitude');

%%swept frequency

a = 0.15;

n = 0: 800;

arg = a *n.^2;

x = cos(arg);

plot(n,x)

grid;
axes([0, 100, -1.5, 1.5])

xlabel('time index');

ylabel('amplitude');
