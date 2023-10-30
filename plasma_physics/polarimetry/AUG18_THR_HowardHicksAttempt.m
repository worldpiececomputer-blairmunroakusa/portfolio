% Attempt to simulate combinter polerimeter interferometer per Howard/Hicks, 2012

clear all
close all

% fundamental constants
c = 3e8; %  m/s

% sweep frequency extrema
freq1 = 300e9; % Hz
freq2 = 299e9; % Hz
freqDiff = abs( freq1 - freq2 ); % Hz

% fundamental modulation frequency
freqMod = 1000; % Hz

% modulation harmonics
harmN2 = 2; % second, multiples of modulation frequency
harmN4 = 4; % fourth, ''
harmN6 = harmN2 + harmN4; % sixth, ''

% <begin> assumption
%   wavelength differences throughout sweep are negligible
% <end>

% radiation wavelength
lambda = c / mean( [freq1, freq2] ); % m

% transmitter / receiver characteristics
sampleRate = 25000; % Hz

% signal characteristics
signalLeng = 1e2; % frames, 1 per time increment
simDuration = signalLeng / sampleRate; % s

% generate test phase shift due to plasma
r_e = 2.82e-15; % m
n_e = 15e19; % 1/m^3
L = 0.25; % m
testDegPHI = r_e * lambda * L * n_e; % deg
testRadPHI = deg2rad( testDegPHI ); % rad

% generate test Faraday rotation due to parallel B field
B = 1.5; % T
testDegPSI = 2.6e-13 * lambda^2 * L * n_e * B; % deg
testRadPSI = deg2rad( testDegPSI ); % rad

% generate time vector
t = linspace( 0, simDuration, signalLeng); % s
% time increment
dt = simDuration / length( t );

% generate expected detector waveform
I_0 = 1;
I_lo = 1;
I = I_lo + I_0/2 + ...
    I_0/2 * cos( 2 * pi * freqMod * harmN2 * t + 2 * testDegPSI ) + ...
    sqrt( I_0 * I_lo ) * cos( 2 * pi * freqMod * harmN4 * t + testDegPHI - testDegPSI ) + ...
    sqrt( I_0 * I_lo ) * cos( 2 * pi * freqMod * harmN6 * t + testDegPHI + testDegPSI );

% sweep period
sweepT = 1 / freqMod;

% number of points per sweep
nInSweep = floor( sweepT / dt );

% number of complete sweeps over sim duration
nSweeps = floor( length( t ) / nInSweep );

% generate sawtooth Voltage(t) vector
VCOvMinIn = 1; % V
VCOvMaxIn = 9; % V
VCOvRange = VCOvMaxIn - VCOvMinIn; % V
VCOincrement = VCOvRange / nInSweep;

% complete voltage vector at fundamental frequency, freqMod
V = VCOvRange * sawtooth( 2*pi*freqMod*t ) + VCOvMinIn;

% generate nonlinear unit time vector
tPUnit = linspace( .5, 1, nInSweep ).^2;
tPUnit = repmat( tPUnit, 1, nSweeps );
nTail = length( t ) - length( tPUnit );
tPUnit = [ tPUnit, tPUnit( 1 : nTail ) ];

% complete non linear frequency vector at fundamental frequency
F = freqDiff * sawtooth( 2 * pi * freqMod * t ) .* tPUnit + freq1;

% display control voltage(t), beam frequency(t)
subplot( 3, 1, 1 )
plot( t, V )
title( 'VCO Signal Control Voltage' )
xlabel( 'time, s' )
ylabel( 'voltage, V' )

% interferometer phase shift
puPHIshift = testDegPHI / 360;
shiftIndex1 = round( nInSweep * puPHIshift );

interF = [ F( nInSweep - shiftIndex1 : ( nInSweep - 1 )), F( 1 : end - shiftIndex1 ) ];

% polarimeter phase shift 
% puPSIshift = testDegPSI / 360;
% shiftIndex2 = round( ldsscc * puPSIshift );
% 
% interF = freqDiff * sawtooth( 2 * pi * freqMod * t * harmN1 - puPSIshift ) .* tPUnit + freq1;

subplot( 3, 1, 2 )
plot( t, F )
hold on 
plot( t, interF )
title( 'Beam Frequency' )
xlabel( 'time, s' )
ylabel( 'frequency, Hz' )
legend( 'F', 'shifted F' )
 
subplot( 3, 1, 3 )
plot( t, I )
title( 'Expected Output' )
xlabel( 'time, s' )
ylabel( 'Intensity' )
