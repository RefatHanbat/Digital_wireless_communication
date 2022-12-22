clear all;
close all;
clc;
 
%% MESSAGE SIGNAL PARAMETERS
fm=1e3;                                  
harm=[ 1 0.5 2 1 ];                                                              
amp=[ 1 2 3 1 ];                        
system_Sampling_freq=20*max(fm*harm)
sampling_rate=1/(system_Sampling_freq);      
range=2/min(fm*harm);                    
t=0:sampling_rate:range;              
 
%MESSAGE SIGNAL
msg=zeros(size(t));
for k=1:length(harm)
    msg=msg+amp(k)*sin(2*pi*harm(k)*fm*t);
end
minamp=min(msg);
                       
%% SAMPLING
n_sample=5;
fs=n_sample*max(harm*fm);                                                      
%Sampling ferqency .
msamp=zeros(size(msg));
msamp(1:system_Sampling_freq/(fs):length(t))=msg(1:system_Sampling_freq/(fs):length(t));  %Sampled output signal
 
figure(1);
plot(t,msg,'b');
grid on
hold on
stem(t,msamp);
xlabel('time');
ylabel('Message signal,Sampled signal');
title('MESSAGE SIGNAL , SAMPLED MESSAGE SIGNAL ');
legend('Message signal','Sampled Signal');
%%QUANTIZATION
no_of_levels=4;                                                                                  
quantile=(max(msamp)-min(msamp))/(no_of_levels);                          
code=min(msamp):quantile:max(msamp);
mq=zeros(size(msamp));                                                          
for k=1:length(code)
    values=(( msamp>(code(k)-quantile/2) & msamp<(code(k)+quantile/2)));  
    mq(values)=round(code(k));                                          
end
clear values;
stem(t,mq,'mo');
grid on
legend('Message signal','Sampled Signal','Quantized Signal');

%%ENCODING
if min(mq)>=0
    minamp=0;                                                        
end
mq1=mq-round(minamp);                                                      
bits=de2bi(mq1(1:1/(fs*sampling_rate):length(mq)),4,'left-msb')';          
bits=bits(:)';                                                            
figure(5);
stem(bits,'*r');
hold on;
legend('Bit sequence in Transmitter');

%% pass band modulation

fc=1e6; %1MHz of frequency
nsamp=10;
ncyc=2;

tb=0:1/(fc*nsamp):ncyc/fc;
t_tran=0:1/(fc*nsamp):(ncyc*length(bits))/fc+(length(bits)-1)/(fc*nsamp);
mod_sig=zeros(size(t_tran));
l=1;
for k=1:length(tb):length(mod_sig)
    if(bits(l)==1)
        mod_sig(k:k+length(tb)-1)=cos(2*pi*fc*tb);
    else
        mod_sig(k:k+length(tb)-1)=-cos(2*pi*fc*tb);
    end
    l=l+1;
    
end

%% AWGN -Channel
tran_signal=awgn(mod_sig,10);

figure(6)
plot(t_tran,mod_sig,'.-b',t_tran,tran_signal,'r');
axis([0 3*ncyc/fc -2  2])
title('transmitted signal and noise added received signal');
legend('tranmistted','received signal');
xlabel('time')
ylabel('amplitude')
grid on


%% Receiver filter

f_freq=-(fc*nsamp)/2:(fc*nsamp)/length(t_tran):(fc*nsamp)/2-(fc*nsamp)/length(t_tran)

f_tran=fft(tran_signal)

figure(7)
plot(f_freq,fftshift(f_tran),f_freq,fftshift(mod_sig));
xlabel('frequency')
ylabel('signal amplitude')
legend('Modulated signal','Received signal')

f_rece=zeros(size(f_tran));
fir=(f_freq<-3*fc | f_freq>3*fc);
f_rece(fir)=f_tran(fir);
f_rece(~fir)=0.5*f_tran(~fir);
t_rece=ifft(f_rece);

figure(8)
plot(t_tran,t_rece);
grid on;
xlabel('time')
ylabel('received signal')

%% Demodulation Process

dec_data=zeros(size(bits));
l=1;
for k=1:length(tb):length(t_tran)
a=corrcoef(cos(2*pi*fc*tb),t_rece(k:k+length(tb)-1));
b=mean(a);
if(b>0.5)
    dec_data(l)=1;
else
     dec_data(l)=0;
    
end
l=l+1;
end

figure(9)
stem(dec_data,'b');
grid on
xlabel('Bits position')
ylabel('Bits sequencu in the receiver VS transmitter')

%% Decoding

dec_data=reshape(dec_data,4,length(dec_data)/4)';
mq_rece=zeros(size(mq));
mq_rece(1:system_Sampling_freq/(fs):length(mq))=bi2de(dec_data,'left-msb')'+min(mq);

%% signal Reconstruction

f_freq=-1/(2*sampling_rate):1/(sampling_rate*length(t)):1/(2*sampling_rate)-1/(sampling_rate*length(t));
f_rece=fft(mq_rece);
f_out=zeros(size(f_rece));

figure(10)
plot(f_freq,fftshift(f_rece),f_freq,fftshift(fft(msg)));
grid on
xlabel('frequency');
ylabel('FFT msg and FFT received signal')
legend('Bits sequence in rec','Bits sequence in TX')

f_out(f_freq<-17000|f_freq>17000)=f_rece(f_freq<-17000|f_freq>17000);
gain=4;
out=ifft(f_out);
amplified_out=out*gain;
figure(11)

plot(t,amplified_out,t,msg)
grid on
xlabel('time')
ylabel('received signal vs TX signal')
legend('RX signal', 'TX signal')