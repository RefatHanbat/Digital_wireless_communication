function [simBerAlamouti] = alamouti_2Tx_1Rx()
clear
    N = 10^6; % number of bits or symbols

    Eb_N0_dB = [0:35]; % multiple Eb/N0 values

    for ii = 1:length(Eb_N0_dB)
        % Transmitter
        ip = rand(1,N)>0.5; % generating 0,1 with equal probability
        s = 2*ip-1; % BPSK modulation 0 -> -1; 1 -> 0
        % Alamouti STBC 
        sCode = zeros(2,N);
        sCode(:,1:2:end) = (1/sqrt(2))*reshape(s,2,N/2); % [x1 x2  ...]
        sCode(:,2:2:end) = (1/sqrt(2))*(kron(ones(1,N/2),[-1;1]).*flipud(reshape(conj(s),2,N/2))); % [-x2* x1* ....]
        h = 1/sqrt(2)*[randn(1,N) + j*randn(1,N)]; % Rayleigh channel
        hMod = kron(reshape(h,2,N/2),ones(1,2)); % repeating the same channel for two symbols    
        n = 1/sqrt(2)*[randn(1,N) + j*randn(1,N)]; % white gaussian noise, 0dB variance
        % Channel and noise Noise addition
        y = sum(hMod.*sCode,1) + 10^(-Eb_N0_dB(ii)/20)*n;
        % Receiver
        yMod = kron(reshape(y,2,N/2),ones(1,2)); % [y1 y1 ... ; y2 y2 ...]
        yMod(2,:) = conj(yMod(2,:)); % [y1 y1 ... ; y2* y2*...]
     
        % forming the equalization matrix
        hEq = zeros(2,N);
        hEq(:,[1:2:end]) = reshape(h,2,N/2); % [h1 0 ... ; h2 0...]
        hEq(:,[2:2:end]) = kron(ones(1,N/2),[1;-1]).*flipud(reshape(h,2,N/2)); % [h1 h2 ... ; h2 -h1 ...]
        hEq(1,:) = conj(hEq(1,:)); %  [h1* h2* ... ; h2 -h1 .... ]
        hEqPower = sum(hEq.*conj(hEq),1);
        yHat = sum(hEq.*yMod,1)./hEqPower; % [h1*y1 + h2y2*, h2*y1 -h1y2*, ... ]
        yHat(2:2:end) = conj(yHat(2:2:end));
        % receiver - hard decision decoding
        ipHat = real(yHat)>0;
        % counting the errors
        nErr(ii) = size(find([ip- ipHat]),2);

end
    simBerAlamouti = nErr / N;
end
