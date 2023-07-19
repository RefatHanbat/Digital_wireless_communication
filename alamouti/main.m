
simBerMaximalRatio = maximalRatioCombining();
simBerAlamouti = alamouti_2Tx_1Rx();
close all
figure
semilogy(Eb_N0_dB,simBerMaximalRatio(2,:),'mo-','LineWidth',2);

hold on
semilogy(Eb_N0_dB,simBerMaximalRatio(4,:),'ks-','LineWidth',2);

semilogy(Eb_N0_dB,simBerAlamouti,'-ro','LineWidth',2);
axis([0 35 10^-5 0.5])
grid on
legend('nRx=2 (simulated)', 'nRx=4 (simulated)','Tx = 2 Rx = 1 (simulated');
xlabel('Eb/No, dB');
ylabel('Bit Error Rate');
title('BER for BPSK modulation with Maximal Ratio Combining in Rayleigh channel');
