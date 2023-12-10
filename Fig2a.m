clear
close all
[u,v] = wlanGolaySequence(32); % Golay sequence pair of length 32
acfu = xcorr(u);
acfv = xcorr(v);
acftotal = acfu + acfv;
lags = -31:31;

set(groot,'defaultAxesTickLabelInterpreter','latex');
figure
plot(lags,acfu,'bo-',lags,acfv,'rd-.',lags,acftotal,'k:','LineWidth',1.5)
grid on
axis ([-31 31 -10 65])
ylabel('Autocorrelation function','Interpreter','latex','FontSize',12);
xlabel('Lag','Interpreter','latex','FontSize',12)
legend({'$R_{\mathbf{\phi}_H}(\tau)$','$R_{\mathbf{\phi}_V}(\tau)$','$R_{\mathbf{\phi}_H}(\tau) + R_{\mathbf{\phi}_V}(\tau)$'},'Interpreter','Latex','FontSize',12,'Location','northwest')
