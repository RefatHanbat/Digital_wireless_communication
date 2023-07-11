

clear
N = 10^6; % number of bits or symbols

% Transmitter
ip = rand(1,N)>0.5; % generating 0,1 with equal probability
s = 2*ip-1; % BPSK modulation 0 -> -1; 1 -> 0

nRx = [1 2];
Eb_N0_dB =   [0:35]; % multiple Eb/N0 values
nErr_selection = zeros(length(nRx), length(Eb_N0_dB));
nErr_equal_gain = zeros(length(nRx), length(Eb_N0_dB));
nErr_maximal_ratio = zeros(length(nRx), length(Eb_N0_dB));
for jj = 1:length(nRx)

    for ii = 1:length(Eb_N0_dB)

        n = 1/sqrt(2)*[randn(nRx(jj),N) + j*randn(nRx(jj),N)]; % white gaussian noise, 0dB variance
        h = 1/sqrt(2)*[randn(nRx(jj),N) + j*randn(nRx(jj),N)]; % Rayleigh channel

        % Channel and noise Noise addition
        sD = kron(ones(nRx(jj),1),s);
        y = h.*sD + 10^(-Eb_N0_dB(ii)/20)*n;


        % finding the power of the channel on all rx chain
        hPower = h.*conj(h);
        
        % finding the maximum power
        [hMaxVal ind] = max(hPower,[],1);
        hMaxValMat = kron(ones(nRx(jj),1),hMaxVal);
        
        % selecting the chain with the maximum power
        ySel = y(hPower==hMaxValMat);
        hSel = h(hPower==hMaxValMat);

        % equalization with the selected rx chain
        yHat = ySel./hSel;
        yHat = reshape(yHat,1,N); % just to get the matrix dimension proper

        % Equal Gain Combining
        yHat = y.*exp(-j*angle(h)); % removing the phase of the channel
        egcSignal = sum(yHat,1); % adding values from all the receive chains

         % Maximal Ratio Combining
       
        mrcSignal = sum(conj(h).*y,1)./sum(h.*conj(h),1);

        % receiver - hard decision decoding

        ipHat = real(yHat)>0;

        ipHat_equal_gain = real(egcSignal) > 0;

        ipHat_maximal_ratio = real(mrcSignal) > 0;

        % counting the errors

        nErr_selection(jj,ii) = size(find([ip- ipHat]),2);

        nErr_equal_gain(jj, ii) = sum(ip ~= ipHat_equal_gain);

        nErr_maximal_ratio(jj, ii) = sum(ip ~= ipHat_maximal_ratio);

    end

end
simBer_selection = nErr_selection / N; % simulated bit error rate for Selection Combining
simBer_equal_gain = nErr_equal_gain / N; % simulated bit error rate for Equal Gain Combining
simBer_maximal_ratio = nErr_maximal_ratio / N; % simulated bit error rate for Maximal Ratio Combining

EbN0Lin = 10.^(Eb_N0_dB/10);
theoryBer_nRx1 = 0.5 * (1 - (1 + 1 ./ EbN0Lin).^(-0.5));
theoryBer_nRx2 = 0.5 * (1 - sqrt(EbN0Lin .* (EbN0Lin + 2)) ./ (EbN0Lin + 1));

% Plot
close all
figure
semilogy(Eb_N0_dB, theoryBer_nRx1, 'bp-', 'LineWidth', 2);
hold on
semilogy(Eb_N0_dB, simBer_selection(1, :), 'mo-', 'LineWidth', 2);
semilogy(Eb_N0_dB, theoryBer_nRx2, 'rd-', 'LineWidth', 2);
semilogy(Eb_N0_dB, simBer_equal_gain(1, :), 'gs-', 'LineWidth', 2);
semilogy(Eb_N0_dB, theoryBer_nRx2, 'co-', 'LineWidth', 2);
semilogy(Eb_N0_dB, simBer_maximal_ratio(1, :), 'k^-', 'LineWidth', 2);
axis([0, 35, 1e-5, 0.5])
grid on
legend('Selection Combining (Theory)', 'Selection Combining (Simulated)', 'Equal Gain Combining (Theory)', 'Equal Gain Combining (Simulated)', 'Maximal Ratio Combining (Theory)', 'Maximal Ratio Combining (Simulated)');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER Comparison for Diversity Combining Techniques');









