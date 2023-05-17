clear
N = 10^6; % number of bits or symbols

% Transmitter
bits = rand(1,N)>0.5; % generating 0,1 with equal probability
s = 2*bits-1; % BPSK modulation 0 -> -1; 1 -> 0

num_rx = [1 2];
Eb_N0_dB = [0:35]; % multiple Eb/N0 values

for jj = 1:length(num_rx)
    
    for ii = 1:length(Eb_N0_dB)
        
        noise = 1/sqrt(2)*[randn(num_rx(jj),N) + 1j*randn(num_rx(jj),N)]; % white Gaussian noise, 0dB variance
        channel = 1/sqrt(2)*[randn(num_rx(jj),N) + 1j*randn(num_rx(jj),N)]; % Rayleigh channel
        
        % Channel and noise addition
        sD = kron(ones(num_rx(jj),1),s);
        y = channel.*sD + 10^(-Eb_N0_dB(ii)/20)*noise;
        
        % finding the power of the channel on all rx chains
        channel_power = abs(channel).^2;
        
        % finding the maximum power on each transmission
        [hMaxVal, hMaxInd] = max(channel_power, [], 1);
        
        % selecting the chain with the maximum power
        ySel = y(sub2ind(size(y), hMaxInd, 1:N));
        hSel = channel(sub2ind(size(channel), hMaxInd, 1:N));
        
        % equalization with the selected rx chain
        yHat = ySel./hSel;
        yHat = reshape(yHat,1,N); % just to get the matrix dimensions proper
        
        % receiver - hard decision decoding
        bits_hat = real(yHat)>0;
        
        % counting the errors
        nErr(jj,ii) = sum(bits ~= bits_hat);
        
    end
    
end

simBer = nErr/N; % simulated BER
EbN0Lin = 10.^(Eb_N0_dB/10);
theoryBer_nRx1 = 0.5.*(1-1*(1+1./EbN0Lin).^(-0.5));
theoryBer_nRx2 = 0.5.*(1-2*(1+1./EbN0Lin).^(-0.5) + (1+2./EbN0Lin).^(-0.5));

% plot
close all
figure

semilogy(Eb_N0_dB,theoryBer_nRx1,'bp-','LineWidth',2);
hold on
semilogy(Eb_N0_dB,simBer(1,:),'mo-','LineWidth',2);
semilogy(Eb_N0_dB,theoryBer_nRx2,'rd-','LineWidth',2);
semilogy(Eb_N0_dB,simBer(2,:),'ks-','LineWidth',2);
axis([0 35 10^-5 0.5])
grid on
legend('nRx=1 (theory)', 'nRx=1 (sim)', 'nRx=2 (theory)', 'nRx=2 (sim)');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for BPSK modulation with Selection diversity in Rayleigh channel');
