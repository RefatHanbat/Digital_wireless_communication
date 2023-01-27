clear
N = 10^6; % number of bits or symbols
%rand('state',100); % initializing the rand() function
%randn('state',200); % initializing the randn() function
ip1 = rand(1,N) > 0.5;
ip2 = rand(1,N) > 0.5;
% QPSK symbol mapping
I = (2*ip1) - 1;
Q = (2*ip2) - 1;
s = I + 1j *Q; 
n = 1/sqrt(2)*(randn(1,N) + 1j*randn(1,N)); % white gaussian noise, 0dB variance 
Eb_N0_dB = -3:10; % multiple Eb/N0 values
SNRlin=10.^(Eb_N0_dB/10);
for ii = 1:length(Eb_N0_dB)
   % Noise addition
   y = 10^(Eb_N0_dB(ii)/20) * s + n; % additive white gaussian noise

   % receiver - hard decision decoding
    sig_I = real(y); % I component
    sig_Q = imag(y); % Q component
    
    bld_I = sig_I > 0; % I decision 
    bld_Q = sig_Q > 0; % Q decision

    b1_error = (bld_I ~= ip1); % Inphase bit error
    b2_error = (bld_Q ~= ip2); % Quadrature bit error
    
    Error_bit = sum(b1_error) + sum(b2_error); % Total bit error
    BER(ii) = sum(Error_bit)/ N; % Simulated BER

end

BER_theo =2 * qfunc(sqrt(2*SNRlin)); % Theoretical BER 
%BER_theo = 0.5*erfc(sqrt(10.^(Eb_N0_dB/10))); % theoretical ber

figure(1);
semilogy(Eb_N0_dB, BER_theo,'r-')  
hold on
semilogy(Eb_N0_dB, BER,'k*')                                 
xlabel('SNR[dB]')                                    
ylabel('Bit Error Rate');                                         
legend('Theoretical', 'Simulated');
title(['Probability of Bit Error for QPSK Modulation']);
grid on;
hold on;