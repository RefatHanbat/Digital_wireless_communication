function [simBerMaximalRatio] = maximalRatioCombining()
    clear
    N = 10^6; % number of bits or symbols
    
    % Transmitter
    
    ip = rand(1,N)>0.5; % generating 0,1 with equal probability
    
    s = 2*ip-1; % BPSK modulation 0 -> -1; 1 -> 0
    
    nRx =  [1 2 3 4];
    
    Eb_N0_dB = [0:35]; % multiple Eb/N0 values
    
    for jj = 1:length(nRx)
    
        for ii = 1:length(Eb_N0_dB)
    
            n = 1/sqrt(2)*[randn(nRx(jj),N) + j*randn(nRx(jj),N)]; % white gaussian noise, 0dB variance
            h = 1/sqrt(2)*[randn(nRx(jj),N) + j*randn(nRx(jj),N)]; % Rayleigh channel
    
            % Channel and noise Noise addition
            sD = kron(ones(nRx(jj),1),s);
            y = h.*sD + 10^(-Eb_N0_dB(ii)/20)*n;
    
            % equalization maximal ratio combining 
            yHat =  sum(conj(h).*y,1)./sum(h.*conj(h),1); 
    
            % receiver - hard decision decoding
            ipHat = real(yHat)>0;
    
            % counting the errors
            nErr(jj,ii) = size(find([ip- ipHat]),2);
    
        end
    
    end
    simBerMaximalRatio = nErr / N;
end
