N = 1e6; % number of bits or symbols

% Transmitter
bits = rand(1, N) > 0.5; % generating 0,1 with equal probability
symbols = 2 * bits - 1; % BPSK modulation 0 -> -1; 1 -> 0

numRx = [1, 2, 3];
EbN0dB = 0:35; % multiple Eb/N0 values

numErrors = zeros(length(numRx), length(EbN0dB));

for jj = 1:length(numRx)
    for ii = 1:length(EbN0dB)
        noise = (1/sqrt(2)) * (randn(numRx(jj), N) + 1i * randn(numRx(jj), N)); % white Gaussian noise, 0 dB variance
        channel = (1/sqrt(2)) * (randn(numRx(jj), N) + 1i * randn(numRx(jj), N)); % Rayleigh channel

        % Channel and noise addition
        symbolDup = repmat(symbols, numRx(jj), 1);
        receivedSignal = channel .* symbolDup + 10^(-EbN0dB(ii) / 20) * noise;

        % Equalization and combining
        if jj == 1
            % Selection Diversity
            equalizedSignal = max(abs(channel) .* receivedSignal, [], 1);
        elseif jj == 2
            % Equal Gain Combining
            equalizedSignal = sum(receivedSignal, 1) / numRx(jj);
        else
            % Maximal Ratio Combining
            equalizedSignal = sum(conj(channel) .* receivedSignal, 1) ./ sum(channel .* conj(channel), 1);
        end

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
theoryBER_nRx3 = p.^3 .* (1 + 3 * (1 - p) + 3 * (1 - p).^2);

figure;
semilogy(EbN0dB, theoryBER_nRx1, 'bp-', 'LineWidth', 2, 'DisplayName', 'Selection Diversity (Theory)');
hold on;
semilogy(EbN0dB, simulatedBER(1, :), 'mo-', 'LineWidth', 2, 'DisplayName', 'Selection Diversity (Simulated)');
semilogy(EbN0dB, theoryBER_nRx2, 'rd-', 'LineWidth', 2, 'DisplayName', 'Equal Gain Combining (Theory)');
semilogy(EbN0dB, simulatedBER(2, :), 'ks-', 'LineWidth', 2, 'DisplayName', 'Equal Gain Combining (Simulated)');
semilogy(EbN0dB, theoryBER_nRx3, 'g+-', 'LineWidth', 2, 'DisplayName', 'Maximal Ratio Combining (Theory)');
semilogy(EbN0dB, simulatedBER(3, :), 'c+-', 'LineWidth', 2, 'DisplayName', 'Maximal Ratio Combining (Simulated)');
legend;
xlabel('Eb/No (dB)');
ylabel('Bit Error Rate');
title('Bit Error Rate Comparison for Diversity Combining Techniques');
grid on;
