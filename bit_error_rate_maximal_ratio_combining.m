clear
N = 10^6; % number of bits or symbols

% Transmitter
bits = rand(1, N) > 0.5; % generating 0,1 with equal probability
symbols = 2 * bits - 1; % BPSK modulation 0 -> -1; 1 -> 0

numRx = [1 2];
EbN0dB = 0:35; % multiple Eb/N0 values

for jj = 1:length(numRx)

    for ii = 1:length(EbN0dB)

        noise = 1/sqrt(2) * [randn(numRx(jj), N) + 1i * randn(numRx(jj), N)]; % white Gaussian noise, 0 dB variance
        channel = 1/sqrt(2) * [randn(numRx(jj), N) + 1i * randn(numRx(jj), N)]; % Rayleigh channel

        % Channel and noise addition
        symbolDup = kron(ones(numRx(jj), 1), symbols);
        receivedSignal = channel .* symbolDup + 10^(-EbN0dB(ii) / 20) * noise;

        % Equalization: maximal ratio combining 
        equalizedSignal = sum(conj(channel) .* receivedSignal, 1) ./ sum(channel .* conj(channel), 1); 

        % Receiver - hard decision decoding
        decodedBits = real(equalizedSignal) > 0;

        % Counting the errors
        numErrors(jj, ii) = sum(bits ~= decodedBits);

    end

end

simulatedBER = numErrors / N; % simulated bit error rate
EbN0Lin = 10.^(EbN0dB / 10);
theoryBER_nRx1 = 0.5 * (1 - (1 + 1 ./ EbN0Lin).^(-0.5)); 
p = 1/2 - 1/2 * (1 + 1 ./ EbN0Lin).^(-1/2);
theoryBER_nRx2 = p.^2 .* (1 + 2 * (1 - p)); 

close all
figure
semilogy(EbN0dB, theoryBER_nRx1, 'bp-', 'LineWidth', 2);
hold on
semilogy(EbN0dB, simulatedBER(1, :), 'mo-', 'LineWidth', 2);
semilogy(EbN0dB, theoryBER_nRx2, 'rd-', 'LineWidth', 2);
semilogy(EbN0dB, simulatedBER(2, :), 'ks-', 'LineWidth', 2);
axis([0 35 1e-5 0.5])
grid on
legend('nRx=1 (theory)', 'nRx=1 (sim)', 'nRx=2 (theory)', 'nRx=2 (sim)');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for BPSK modulation with Maximal Ratio Combining in Rayleigh channel');
