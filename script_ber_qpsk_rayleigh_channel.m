close all
clear
N = 10^6; % number of bits or symbols
b1 = rand(1,N) > 0.5;
b2 = rand(1,N) > 0.5;
% Transmitter
ip = rand(1,N)>0.5; % generating 0,1 with equal probability
I = (2*b1) - 1;
Q = (2*b2) - 1;
S = I + j*Q;; % qpsk modulation 0 -> -1; 1 -> 0 

 
Eb_N0_dB = [-3:35]; % multiple Eb/N0 values

for ii = 1:length(Eb_N0_dB)
   
   n = 1/sqrt(2)*[randn(1,N) + j*randn(1,N)]; % white gaussian noise, 0dB variance 
   h = 1/sqrt(2)*[randn(1,N) + j*randn(1,N)]; % Rayleigh channel
   
   % Channel and noise Noise addition
   y = h.*S + 10^(-Eb_N0_dB(ii)/20)*n; 

   % equalization
   yHat = y./h;

   % receiver - hard decision decoding
   ipHat_1 = real(yHat)>0;
   ipHat_2 = imag(yHat)>0;
   ipHat = ipHat_1 + ipHat_2;

   % counting the errors
   nErr(ii) = size(find([ip- ipHat]),2);

end

simBer = nErr/N; % simulated ber
theoryBerAWGN = 0.5*erfc(sqrt(10.^(Eb_N0_dB/10))); % theoretical ber
EbN0Lin = 10.^(Eb_N0_dB/10);
theoryBer = 0.5.*(1-sqrt(EbN0Lin./(EbN0Lin+1)));

% plot
close all
figure
semilogy(Eb_N0_dB,theoryBerAWGN,'cd-','LineWidth',2);
hold on
semilogy(Eb_N0_dB,theoryBer,'bp-','LineWidth',2);
semilogy(Eb_N0_dB,simBer,'mx-','LineWidth',2);
axis([-3 35 10^-5 0.5])
grid on
legend('AWGN-Theory','Rayleigh-Theory', 'Rayleigh-Simulation');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for QPSK modulation in Rayleigh channel');









