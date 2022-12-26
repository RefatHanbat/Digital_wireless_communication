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
%% Receiver Side
%% Zero forcing Equilizer
g=[1];
zf_linear_awgn2=ZF(g,awgn_bpsk);
zf_linear_awgn4=ZF(g,awgn_4qam);
zf_linear_rayChan2 = ZF(g,rayChan_bpsk);
zf_linear_rayChan4 = ZF(g,rayChan_4qam);

%% Demodulation

for i=1:length(zf_linear_awgn2)
    awgnD2_linear(:,i) = comm.BPSKDemodulator(zf_linear_awgn2(:,i)).';
    awgnD4_linear(:,i) = qamdemod(zf_linear_awgn4(:,i),4);
    rayChan2_linear(:,i) = H2(zf_linear_rayChan2(:,i)).';
    rayChan4_linear(:,i) = qamdemod(zf_linear_rayChan4(:,i),4);
end

function Xh = ZF(h,r)

%r --- signal at the receiver
% h--- impulse response of the channel 
%Computing inverse impulse response

gD=tf(h,1); % Gain of the channel

f=1/gD; % taking inverse of the channel gain

[num,den]=tfdata(f,'v'); % extracting numerator and denominator coefficients 

%Zero forcing
Xh=filter(num,den,r); % filtering 

% Xh=Xh(1:end); %this done for technical reasons 
end


%H2 = comm.BPSKDemodulator;
%% FEC Decoder
%Linear Decoder
for i=1:length(awgnD2_linear)
    awgn_linear_bpsk(:,i) = decode(awgnD2_linear(:,i),n,k);
    awgn_linear_4(:,i) = decode(awgnD4_linear(:,i),n,k);
    rayChan_linear_bpsk(:,i) = decode(rayChan2_linear(:,i),n,k);
    rayChan_linear_4(:,i) = decode(rayChan4_linear(:,i),n,k);
end
%% Deinterleaver
% first take the transpose 
awgn_linear_bpsk=awgn_linear_bpsk';
awgn_linear_4=awgn_linear_4';
rayChan_linear_bpsk=rayChan_linear_bpsk';
rayChan_linear_4=rayChan_linear_4';
% Block Deinterleaving
awgnlinear_bpsk = matdeintrlv(awgn_linear_bpsk, 32, 32);
awgnlinear_4 = matdeintrlv(awgn_linear_4, 32, 32);
rayChanlinear_bpsk = matdeintrlv(rayChan_linear_bpsk, 32, 32);
rayChanlinear_4 = matdeintrlv(rayChan_linear_4, 32, 32);
%% BER Calculation
% Linear AWGN
% BER Plots
EbNo = 1:1:12;
M1=2; % symbols in BPSK
M2=4; % symbols in 4QAM
den=1;
num1 = ones(2,1)/2; % for BPSK
num2 = ones(4,1)/4; % for 4QAM
Nsamp=100; % number of samples to be considered
TX_bpsk=mod_linear_bpsk(:);
TX_4qam=mod_linear_4qam(:);
RX_bpsk_awgn=zf_linear_awgn2(:);
RX_4qam_awgn=zf_linear_awgn4(:);
RX_bpsk_raychan=zf_linear_rayChan2(:);
RX_4qam_raychan=zf_linear_rayChan2(:);
ber_linear_AWGN_2 = semianalytic(TX_bpsk,RX_bpsk_awgn,'psk/nondiff',M1,Nsamp,num1,den,EbNo);
ber_linear_AWGN_4 = semianalytic(TX_4qam,RX_4qam_awgn,'psk/nondiff',M2,Nsamp,num2,den,EbNo);
ber_linear_raychan_2 = semianalytic(TX_bpsk,RX_bpsk_raychan,'psk/nondiff',M1,Nsamp,num1,den,EbNo);
ber_linear_raychan_4 = semianalytic(TX_4qam,RX_4qam_raychan,'psk/nondiff',M2,Nsamp,num2,den,EbNo);
figure(1)
semilogy(EbNo,ber_linear_AWGN_2);
hold on
semilogy(EbNo,ber_linear_AWGN_4);
semilogy(EbNo,ber_linear_raychan_2);
semilogy(EbNo,ber_linear_raychan_4);
grid on
xlabel('EbNo');
ylabel('BER');
legend('AWGN 4QAM','AWGN BPSK','Ray 4QAM','Ray BPSK')

