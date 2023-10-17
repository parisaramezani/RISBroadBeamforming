Data.spacingLambda = 1;
Data.nElements = 20;
Data.elementPointDirDeg = 0;
Data.elementHpbwDeg = pi/2;
Data.anglesAoD = linspace(-pi/2,pi/2,500);
Data.AoA = pi/3;
Data.configA  = [1 1 -1 1i 1 -1 -1i -1 -1i 1i].';
Data.configB = [1 1 -1i 1 -1i -1i 1 1i 1i -1i].';
Data=ArrayFactor(Data);

set(groot,'defaultAxesTickLabelInterpreter','latex');

figure
hold on; grid on;
plot (Data.anglesAoD,Data.elementPatternDb,'g--','LineWidth',1.5)
plot (Data.anglesAoD,Data.RadPatternTotalDb,'r:','LineWidth',1.5)



u = [1 1i 1].';
v = [1 1 -1].';
configA = [kron(u,Data.configA);kron(-v,flip(conj(Data.configB)))];
configB = [kron(u,Data.configB);kron(v,flip(conj(Data.configA)))];

Data.nElements = 120;
Data.configA = configA;
Data.configB = configB;
Data=ArrayFactor(Data);

plot (Data.anglesAoD,Data.RadPatternTotalDb,'b-','LineWidth',1.5)
xlim([-1.6 1.6])
ylim([-5 40])
xticks ([-pi/2 -pi/4 0 pi/4 pi/2])
xticklabels({'$-\frac{\pi}{2}$' '$-\frac{\pi}{4}$' '$0$' '$\frac{\pi}{4}$' '$\frac{\pi}{2}$'})
xlabel('Azimuth AoD','Interpreter','latex','FontSize',12)
ylabel('Radiation power pattern [dB] ','Interpreter','latex','FontSize',12);
legend({'One RIS element','$2M=20$','$4MN = 120$'},'Interpreter','Latex','Location','northwest','FontSize',12)
h = get(gca,'Children');
set(gca,'Children',[h(3) h(2) h(1)])

