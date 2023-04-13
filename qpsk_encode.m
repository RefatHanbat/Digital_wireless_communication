%......QPSK model decreasing notse power.....
clc
clear all
close all
% Total number of data bits.
N = 10^6; 
% generating 0,1 with equal probability
X = rand(1,N)>0.5; 
z=rand(1,N)>0.5;
% BPSK modulation 0 -> -1; 1 -> 1 
X_QPSK = 1/sqrt(2)*((2*X-1)+j*(2*z-1));
% SNR for the channel in dB.
SNR_dB =-3:20; 
% white gaussian noise, 0dB variance 
n =1/sqrt(2)*[randn(1,N) + j*randn(1,N)];
SNR=10.^(SNR_dB/10);
% Rayleigh channel is the real and imaginary parts are Gaussian distributed having variance=1 and mean = 0
H = 1/sqrt(2)*[randn(1,N)+j*randn(1,N)];
for k = 1:length(SNR_dB)
   % The noise follows the Gaussian distribution the (0,1)
   % the variance (1), means(0). so that signal power =1,
   y = H.*X_QPSK*sqrt(SNR(k)) + n;
   % The channel(H) is known at the receiver. 
   % Equalization is performed at the receiver by dividing the received symbol(Y) by the apriori known(H).
   Y_receiver = y./H;
   % receiver get 1 bit  from real part
   X_real_bit = real(Y_receiver);
   X_imag_bit = imag(Y_receiver);
   QPSK_bit(find(X_real_bit < 0 & X_imag_bit < 0)) = -1 + -1*j;
   QPSK_bit(find(X_real_bit >= 0 & X_imag_bit > 0)) = 1 + 1*j;
   QPSK_bit(find(X_real_bit < 0 & X_imag_bit >= 0)) = -1 + 1*j;
   QPSK_bit(find(X_real_bit >= 0 & X_imag_bit < 0)) = 1 - 1*j;
   % counting the errors
   X_corrupted_bit(k) = size(find([(sqrt(2)*X_QPSK)- QPSK_bit]),2);
   % Total numbero of errors
   X_corrupted_Total=length(X_corrupted_bit);

end
% simulated ber
BER = X_corrupted_bit/N; 
% Theoretical BER in AWGN channel
theory_Ber_AWGN = 0.5*erfc(sqrt(10.^(SNR_dB/10)));
% Theoretical BER in Rayleigh channel.
%theoryBer_QPSK = erfc(sqrt(0.5*(10.^(SNR_dB/10)))) - (1/4)*(erfc(sqrt(0.5*(10.^(SNR_dB/10))))).^2;
theory_Ber_Ray = 0.5.*(1-sqrt(SNR/4./(SNR/4+1)));
% Plot of BER Rayleigh channel ,theoryBER of AWGN and theory BER Rayleigh channel                  
% plot of BER and theoryBER
close all
semilogy(SNR_dB,theory_Ber_AWGN,'b.-');
hold on
semilogy(SNR_dB,theory_Ber_Ray,'cd-');
semilogy(SNR_dB,BER,'mx-');
axis([-3 15 10^-5 1])
grid on
legend('AWGN-Theory','Rayleigh-Theory', 'Rayleigh-Simulation');
xlabel('SNR, dB');
ylabel('Bit Error Rate');
title('Bit error probability curve for QPSK modulation');