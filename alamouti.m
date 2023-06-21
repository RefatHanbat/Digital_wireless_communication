% BER Performance Comparison of Coherent BPSK with MRRC and Alamouti's Transmit Diversity
clear all;
close all;
clc;

% Parameters
numBits = 10^6;             % Number of bits to transmit
SNRdB = -10:2:20;           % SNR values in dB
SNR = 10.^(SNRdB/10);       % SNR values in linear scale
numTx = [1, 1, 2, 2];       % Number of transmitters
numRx = [1, 2, 1, 2];       % Number of receivers

% Generate random bits
txBits = randi([0, 1], 1, numBits);

% Modulation
txSymbols = 2*txBits - 1;   % BPSK modulation: 0 -> -1, 1 -> +1

% Initialize BER matrix
BER = zeros(length(numTx), length(SNRdB));

% Channel and Noise
for i = 1:length(numTx)
    for j = 1:length(SNRdB)
        % Channel
        channel = sqrt(0.5)*(randn(numRx(i), numTx(i)) + 1i*randn(numRx(i), numTx(i)));
        
        % AWGN Noise
        noise = sqrt(0.5/SNR(j))*(randn(numRx(i), numBits) + 1i*randn(numRx(i), numBits));
        
        % Transmit Diversity Techniques
        if numTx(i) == 1
            % No Diversity (Direct Transmission)
            rxSymbols = channel*txSymbols + noise;
        elseif numRx(i) == 2
            % MRRC (1Tx, 2Rx)
            rxSymbols = sum(conj(channel).*repmat(txSymbols, numRx(i), 1), 1) + noise;
        else
            % MRRC (1Tx, 4Rx)
            rxSymbols = sum(conj(channel).*repmat(txSymbols, numRx(i), 1), 1) + noise;
        end
        
        % Receiver
        rxBits = real(rxSymbols) > 0;   % Decision based on the received symbols
        
        % Calculate Bit Error Rate (BER)
        numErrors = sum(txBits ~= rxBits);
        BER(i, j) = numErrors/numBits;
    end
end

% Plotting the BER Performance
figure;
semilogy(SNRdB, BER(1, :), '-o', 'LineWidth', 2); hold on;
semilogy(SNRdB, BER(2, :), '-*', 'LineWidth', 2);
semilogy(SNRdB, BER(3, :), '-s', 'LineWidth', 2);
semilogy(SNRdB, BER(4, :), '-d', 'LineWidth', 2);
grid on;
xlabel('SNR (dB)');
ylabel('BER');
title('BER Performance Comparison');
legend('Coherent BPSK', 'MRRC (1Tx, 2Rx)', 'MRRC (1Tx, 4Rx)', 'Alamouti (2Tx, 2Rx)', 'Location', 'best');
