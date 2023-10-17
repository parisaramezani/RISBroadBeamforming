nbrofUsers = 1000;
Data.spacingLambda = 1;
Data.nElements = 120;
Data.elementPointDirDeg = 0;
Data.elementHpbwDeg = pi/2;
Data.anglesAoD = unifrnd(-pi/2,pi/6,1,nbrofUsers);
Data.AoA = pi/3;

dBS_RIS = 50;
dUE_RIS = unifrnd(50,100,nbrofUsers,1);
noise = -90; %dBm

theta1  = [1 1 -1 1i 1 -1 -1i -1 -1i 1i].';
theta2 = [1 1 -1i 1 -1i -1i 1 1i 1i -1i].';
u = [1 1i 1].';
v = [1 1 -1].';
Data.configA = [kron(u,theta1);kron(-v,flip(conj(theta2)))];
Data.configB = [kron(u,theta2);kron(v,flip(conj(theta1)))];

Data=ArrayFactor(Data);


power = 47; %dBm
SNR = 10^((power-noise)/10);
UEpathloss_dB = -37.5-22*log10(dUE_RIS);
UEpathloss = 10.^(UEpathloss_dB/10);

BSpathloss_dB = -37.5-22*log10(dBS_RIS);
BSpathloss = 10^(BSpathloss_dB/10);

% Spectral Efficiency
SE_prop = log2(1+SNR*BSpathloss* (Data.RadPatternTotal.' .* UEpathloss));



%% Benchmarks
%Beamforming towards the user with the best channel condition
psi = 2*pi*Data.spacingLambda*(sin(Data.AoA) + sin(Data.anglesAoD));
steeringVec = exp (1i*(0:Data.nElements/2 - 1).'*psi);
[~,idx] = min(dUE_RIS);
config_bench1 = exp(-1i*angle(steeringVec(:,idx)));
RadPatternTotal_bench1 = 2* abs(config_bench1.' * steeringVec).^2;

    SE_bench1 = log2(1+SNR*BSpathloss* (RadPatternTotal_bench1.' .* UEpathloss));


%Random configuration of the RIS so that it acts as a diffuse scatterer
nbrofRandomRealizations = 1000;
SE_random = zeros(nbrofUsers,nbrofRandomRealizations);
for i =1:nbrofRandomRealizations
configA_bench2 = exp(1i*2*pi*rand(Data.nElements/2,1));
configB_bench2 = exp(1i*2*pi*rand(Data.nElements/2,1));
RadPatternTotal_bench2 = abs(configA_bench2.'*steeringVec).^2 + abs(configB_bench2.'*steeringVec).^2;
SE_random(:,i) = log2(1+SNR*BSpathloss* (RadPatternTotal_bench2.' .* UEpathloss));
end

SE_bench2 = mean(SE_random,2);


figure
hold on;
h_prop = cdfplot(SE_prop);
h_bench1 = cdfplot(SE_bench1);
h_bench2 = cdfplot(SE_bench2);
set(h_prop, 'LineStyle', '-', 'Color', 'b','LineWidth',1.5);
set(h_bench1, 'LineStyle', ':', 'Color', 'r','LineWidth',1.5);
set(h_bench2, 'LineStyle', '--', 'Color', 'g','LineWidth',1.5);
legend('Proposed','Closest UE','Random','Interpreter','Latex','Location','southeast','FontSize',12)
xlabel('Spectral Efficiency (bps/Hz)','Interpreter','Latex','FontSize',12);
ylabel('CDF','Interpreter','Latex','FontSize',12);