clear all;
close all;
clc;
%SNR for channel in DB
SNRdB = -8 : 1 : 12; % set signal to noise ration in db
%Get SNR value, SNRdB = 10 * log(10) (Signal power / noise power)
% Calculate and get SNR value from SNR db values
SNR = 10.^(SNRdB / 10);
%data bits 
N = 10^5;
x = randsrc(1,N,[0,1]);
%BPSK data generation
x_BPSK = 1- 2 * x;
%AWGN noise
n = randn(1,N);
for k = 1:length(SNR)
    %Assume that the noise follows the gaussian distribution
    %,the (0,1),where mean = 0 and variance = 1 so that noise power 1;
    y = (sqrt(SNR(k)) * x_BPSK) + n;
    % (+1) * (-1) -> (-1), flipped 
    % (-1) * (+1) -> (-1), flipped 
    % (-1) * (-1) -> (+1), not flipped 
    % (+1) * (+1) -> (+1), not flipped 
    %no of indice which are less than one(+1), because (-1) indices the bit
    %values has flipped

    noisy_bits = y.* x_BPSK; % Logic to get number of corrupted bits by noise
    %get indice of currupted bits by noise
    indices_currupted = find((noisy_bits) < 0);
    %get number of currupted bits by noise
    NumberOfCurrupted_bits(k) =length(find(indices_currupted)) ;

end
%BER (bit error rate calculation)
ber = NumberOfCurrupted_bits / N;
%simulation result 
figure;
%practical
prac = semilogy(SNRdB,ber,'b*-','linewidth',1);
hold on;
%theoritical
theoritical = qfunc(sqrt(SNR));
theo = semilogy(SNRdB,theoritical,'r+-','LineWidth',1);
xlabel("SNR in dB");
ylabel("Bit Error rate -BER");
legend([prac theo],'Practical', 'theoritical');
grid on;
datacursormode on;