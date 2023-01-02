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