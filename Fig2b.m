Data.spacingLambda = 1;
Data.nElements = 64;
Data.elementPointDirDeg = 0;
Data.elementHpbwDeg = pi/2;
Data.anglesAoD = linspace(-pi/2,pi/2,500);
Data.AoA = pi/3;
[u,v] = wlanGolaySequence(32);
Data.configA  = u;
Data.configB  = v;
Data = ArrayFactor(Data);

set(groot,'defaultAxesTickLabelInterpreter','latex');

figure
hold on; grid on;
plot(Data.anglesAoD,Data.arrayFactorAdB,'b-','LineWidth',1.5)
plot(Data.anglesAoD,Data.arrayFactorBdB,'r-.','LineWidth',1.5)
plot(Data.anglesAoD,Data.arrayFactorTotaldB,'k:','LineWidth',1.5)

xlim([-1.6 1.6])
xticks ([-pi/2 -pi/4 0 pi/4 pi/2])
xticklabels({'$-\frac{\pi}{2}$' '$-\frac{\pi}{4}$' '$0$' '$\frac{\pi}{4}$' '$\frac{\pi}{2}$'})
legend({'Polarization H ','Polarization V','Total'},'Interpreter','Latex','Location','best','FontSize',12)
xlabel('Azimuth AoD','Interpreter','latex','FontSize',12)
ylabel('Array factor [dB] ','Interpreter','latex','FontSize',12);