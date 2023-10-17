function Data = ArrayFactor(Data)

% Compute radiation power pattern and array factor for a given RIS setup and phase shift configurations
% =========================================================================

% Read parameters
nElements           = Data.nElements;
spacingLambda       = Data.spacingLambda; %This is the spacing between two elements of the same polarization, so, it is twice the spacing between adjacent elements
configA             = Data.configA;
configB             = Data.configB;
elementPointDirDeg  = Data.elementPointDirDeg;
elementHpbwDeg      = Data.elementHpbwDeg;
anglesAoD           = Data.anglesAoD;
AoA                 = Data.AoA;


% Compute steering vector
psi = 2*pi*spacingLambda*(sin(AoA) + sin(anglesAoD));
steeringVec = exp (1i*(0:nElements/2 - 1).'*psi);

% Compute array factors
arrayFactorA = abs(configA.'*steeringVec).^2;
arrayFactorB = abs(configB.'*steeringVec).^2;
arrayFactorTotal = arrayFactorA + arrayFactorB;
arrayFactorAdB = 10*log10(arrayFactorA);
arrayFactorBdB = 10*log10(arrayFactorB);
arrayFactorTotaldB = 10*log10(arrayFactorTotal);


% Radiation pattern of an element
elementGainFunctionDb = inline('-min(12*( (x-offset)./hpbw).^2, 30)', 'x', 'offset', 'hpbw');

% Radiaition pattern of the RIS 
elementPatternDb1 = 8 + elementGainFunctionDb(AoA, elementPointDirDeg, elementHpbwDeg); %BS to RIS
elementPatternDb2 = 8 + elementGainFunctionDb(anglesAoD, elementPointDirDeg, elementHpbwDeg); %RIS to users
elementPatternDb = elementPatternDb1 + elementPatternDb2;
elementPattern1 = 10.^(elementPatternDb1/10);
elementPattern2 = 10.^(elementPatternDb2/10);
elementPattern = elementPattern1*elementPattern2;


% Compute Radiation Power Pattern
RadPatternA = arrayFactorA .* elementPattern;
RadPatternB = arrayFactorB .* elementPattern;
RadPatternTotal = arrayFactorTotal .* elementPattern;
RadPatternADb = 10*log10(RadPatternA);
RadPatternBDb = 10*log10(RadPatternB);
RadPatternTotalDb = 10*log10(RadPatternTotal);



% Pass the results outside
Data.arrayFactorAdB = arrayFactorAdB;
Data.arrayFactorBdB = arrayFactorBdB;
Data.arrayFactorTotaldB = arrayFactorTotaldB;
Data.elementPatternDb = elementPatternDb;
Data.RadPatternADb = RadPatternADb;
Data.RadPatternBDb = RadPatternBDb;
Data.RadPatternTotal = RadPatternTotal;
Data.RadPatternTotalDb = RadPatternTotalDb;

end