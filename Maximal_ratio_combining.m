clear

N = 10^3; % number of bits or symbols

% Transmitter
bits = rand(1,N)>0.5; % generating 0,1 with equal probability
symbols = 2*bits-1; % BPSK modulation 0 -> -1; 1 -> 0

numRx = [1:20];
EbN0dB = [25]; % multiple Eb/N0 values

for jj = 1:length(numRx)

    for ii = 1:length(EbN0dB)

        noise = 1/sqrt(2)*[randn(numRx(jj),N) + 1i*randn(numRx(jj),N)]; % white Gaussian noise, 0dB variance
        channel = 1/sqrt(2)*[randn(numRx(jj),N) + 1i*randn(numRx(jj),N)]; % Rayleigh channel

        % Channel and noise addition
        symbolMatrix = kron(ones(numRx(jj),1),symbols);%symbolMatrix = 1;
        receivedSignal = channel.*symbolMatrix + 10^(-EbN0dB(ii)/20)*noise;

        % Maximal ratio combining
        combinedSignal = sum(conj(channel).*receivedSignal,1);

        % Effective SNR
        EbN0EffSim(ii,jj) = mean(abs(combinedSignal));
        EbN0EffTheory(ii,jj) = numRx(jj);

    end

end

close all
figure
plot(numRx, 10*log10(EbN0EffTheory), 'bd-', 'LineWidth', 2);
hold on
plot(numRx, 10*log10(EbN0EffSim), 'mp-', 'LineWidth', 2);
axis([1 20 0 16])
grid on
legend('Theory', 'Simulation');
xlabel('Number of receive antennas');
ylabel('SNR gain, dB');
title('SNR improvement with Maximal Ratio Combining');
