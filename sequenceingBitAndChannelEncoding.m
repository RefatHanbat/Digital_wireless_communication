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

