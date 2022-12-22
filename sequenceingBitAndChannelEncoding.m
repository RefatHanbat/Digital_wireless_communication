clc
close all
clear all
%% generate the random sequence of bits

totalbits=4096;
SourceBit= round(rand(1,totalbits));
%reshape the bite as 4x1024, which means our message signal is 4bits
SourceBit=reshape(SourceBit,length(SourceBit)/4,4);
%% FEC Encoder (Hamming Coding)
n=7;
k=4; % since our message is 4 bits
linearcode=encode(SourceBit,n,k,'hamming');
%%Block interleaver
[a2,b2] = size(linearcode);
bi_linear = matintrlv(linearcode,32,32);

%% Modulation 
% 1) BPSK Modulation
H1=comm.BPSKModulator;
modbits=bi_linear.';
for i=1:length(modbits)
    mod_linear_bpsk(:,i)=H1(bi_linear(i,:).');
end
scatterplot(mod_linear_bpsk(:,1));
grid on;
% 2) 4-QAM Modulation
for i=1:length(modbits)
    mod_linear_4qam(:,i)=qammod(bi_linear(i,:), 4);
end

%%channel model
%1)AWGN
channelBPSK = comm.AWGNChannel('EbNo',15,'BitsPerSymbol',1); % define a channel model
channel4QAM = comm.AWGNChannel('EbNo',15,'BitsPerSymbol',2);
awgn_bpsk=channelBPSK(mod_linear_bpsk);
awgn_4qam = channel4QAM(mod_linear_4qam);
scatterplot(awgn_bpsk(:,1))
title('BPSK constellation after AWGN channel')
grid on;
% 2) Rayleigh channel model 
fm=1e6;
sampling=5*fm;
rayChan = comm.RayleighChannel(...
    'SampleRate',sampling, ...
    'PathDelays',[1e-9 1.5e-5], ...
    'AveragePathGains',[2 1], ...
    'NormalizePathGains',true, ...
    'DopplerSpectrum',{doppler('Gaussian',0.6),doppler('Flat')}, ...
    'RandomStream','mt19937ar with seed', ...
    'Seed',22); % creating the object for the Rayleigh channel
for i=1:length(mod_linear_bpsk)
    rayChan_bpsk(:,i) = rayChan(mod_linear_bpsk(:,i));
end
for i=1:length(mod_linear_4qam)
    rayChan_4qam(:,i) = rayChan(mod_linear_4qam(:,i));
end
scatterplot(rayChan_bpsk(:,1))
title('BPSK constellation after Releigh channel')
grid on;

