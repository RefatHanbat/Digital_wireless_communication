clc;clear;close all
% Figure 1
n_iterations = 10000; % Number of iterations
N = (1:1:16);  % Number of users
SNR_dB = 0;    % SNR in dB
SNR = 10^(SNR_dB/10); % SNR in linear scale
m = 1;
throughput_nakagami = zeros;
throughput_awgn = zeros;
for k = 1:length(N)
   capacity_nakagami = 0;
   for i = 1:n_iterations
%Nakagami fading channel
       Y = zeros(1,k);
       for l = 1:2*m
           Y = Y + randn(1,k).^2; 
       end  
    omega = Y/(2*m);
    phi = 2*pi*rand(1,k);
    h = sqrt(omega).*(cos(phi)+1j*sin(phi)); % random channel gain
    h2 = (abs(h)).^2;
    best_h2 = max(h2); % best channel gain amongst users
   capacity_nakagami = capacity_nakagami + log2(1+(best_h2*SNR)); % Capacity for Rayleigh fading channel
   end
  
   throughput_nakagami(k) = (capacity_nakagami)/n_iterations; % Expected capacity
   throughput_awgn(k) = log2(1+SNR);  % Capacity for AWGN channel
end
plot(N,throughput_nakagami,"LineWidth",1.5)