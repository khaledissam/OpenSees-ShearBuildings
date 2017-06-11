%##############################################################################%
%% Define Building
nStories = 9;
bldg = mdofShearBuilding2d(nStories);

% Units
bldg.units.force = 'kip';
bldg.units.mass  = 'kslug';
bldg.units.length= 'ft';
bldg.units.time  = 'sec';

bldg.g = 32.2;                                  % Acceleration due to gravity

bldg.storyHeight = ones(1,nStories)*15;         % Story heights (ft)
bldg.storyHeight(1) = 20;
storyDL = ones(1,nStories)*0.080;               % Story dead loads (ksf)
storyDL(end) = 0.030;
storyArea = 90*90*ones(1,nStories);             % Story areas (ft^2)
bldg.storyMass = (storyDL .* storyArea)/bldg.g; % Story masses (kslug)

bldg.seismicDesignCategory = 'Dmax';
bldg.respModCoeff = 8;
bldg.deflAmplFact = 8;
bldg.overstrengthFactor = 3;
bldg.impFactor = 1;

springGivens.as       =  0.05;  % strain hardening ratio
springGivens.Lambda_S =  10.00;  % Cyclic deterioration parameter - strength
springGivens.Lambda_K =  10.00;  % Cyclic deterioration parameter - stiffness
springGivens.c_S      =  1.00;  % rate of deterioration - strength
springGivens.c_K      =  1.00;  % rate of deterioration - stiffness
springGivens.Res      =  0.30;  % residual strength ratio (relative to yield)
springGivens.D        =  1.00;  % rate of cyclic deterioration
springGivens.nFactor  =  0.00;  % elastic stiffness amplification factor
springGivens.C_yc     =  0.80;  % ratio of yield strength to capping strength
springGivens.C_pcp    =  2.00;  % ratio of post-capping deflection to pre-capping deflection
springGivens.C_upc    = 20.00;  % ratio of ultimate deflection to u_y + u_p + u_pc
springGivens.theta_pc = 0.3;     % angle of post-capping stiffness (degrees)
springGivens.ad       = 0.15;    % deterioration stiffness ratio

springGivens.stiffnessSafety = 1.0;
springGivens.strengthSafety  = 1.0;

springGivens.enforceMinimumStiffness = false;
springGivens.enforceMinimumStrength = false;
springGivens.minimumRatio = 0.7;

%##############################################################################%
%% Analysis Options
bldg.echoOpenSeesOutput = false;
bldg.deleteFilesAfterAnalysis = true;

bldg.verbose   = true ; % Toggle verbose output
runPushover    = true ; % Toggle pushover analysis
runIDA         = true ; % Toggle IDA
plotHysteretic = false; % Toggle plotting hysteretic curves

% Equivalent lateral force options
iterate    = false;             % Select whether to do iteration
iterOption = 'overstrength';    % Variable to use for convergence: 'period' or 'overstrength'

diffTol = 1e-3;             % Tolerance for iteration

% Pushover analysis options
bldg.pushover_stepSize = 0.001;
bldg.pushover_maxDrift = min(bldg.storyHeight);

bldg.optionsPushover.constraints.type = 'Plain';
bldg.optionsPushover.constraints.penalty.alphaS = 1.0e12;
bldg.optionsPushover.constraints.penalty.alphaM = 1.0e12;

bldg.optionsPushover.test.type       = 'NormDispIncr';
bldg.optionsPushover.test.tolerance  = [1e-5,1e-4,1e-3];
bldg.optionsPushover.test.iterations = 10;
bldg.optionsPushover.test.print      = 1;
bldg.optionsPushover.test.normType   = 2;

bldg.optionsPushover.algorithm = { 'KrylovNewton','Newton','ModifiedNewton' };

% Response history options
bldg.optionsResponseHistory.constraints.type = 'Transformation';
bldg.optionsResponseHistory.constraints.penalty.alphaS = 1.0e12;
bldg.optionsResponseHistory.constraints.penalty.alphaM = 1.0e12;

bldg.optionsResponseHistory.test.type       = 'NormDispIncr';
bldg.optionsResponseHistory.test.tolerance  = [1e-5,1e-4,1e-3];
bldg.optionsResponseHistory.test.iterations = 10;
bldg.optionsResponseHistory.test.print      = 1;
bldg.optionsResponseHistory.test.normType   = 2;

bldg.optionsResponseHistory.algorithm = { 'Newton','KrylovNewton','ModifiedNewton' };

% Incremental dynamic analysis options
bldg.optionsIDA.nMotions = 7;                              % Number of ground motions to analyze
bldg.optionsIDA.tExtra = 5;                                 % Extra analysis time after end of ground motion
bldg.optionsIDA.collapseDriftRatio = 0.05;                  % Story drift ratio that defines collapse
bldg.optionsIDA.ST = 0.25:0.25:8;
bldg.optionsIDA.collapseProbability = 0.2;
bldg.optionsIDA.rating_DR = 'C';
bldg.optionsIDA.rating_TD = 'C';
bldg.optionsIDA.rating_MDL = 'C';
% SF2 = [0:0.25:1.5 , 2:0.5:5 , 5.75:0.75:8]; % Scale factors to use for each IDA curve
