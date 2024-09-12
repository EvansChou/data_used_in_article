% dx=[-2.6,-2.7,-2.75,-2.8,-2.85,-2.9,-3,-3.1,-3.2];
% dpix = [0.0156,0.0571,0.0779,0.0989,0.1198,0.1408,0.1829,0.2253,0.2678];
% n = length(dx)+4;
% initialGuess = [0.5,0.51,0.52,0.53,0.54,0.55,0.56,0.57,0.58,45,7,50,2.3 ];
%     lb =[0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,0.5,40,6,40,2];  %最小值
%     ub =[0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.9,0.9,50,8,60,2.6];  %最大值
%%
% filename = '标定.xlsx';
% sheetname = '无液滴标定';
% xlRange1 = 'H1:H14';
% xlRange2 = 'I1:I14';
% xlRange3 = 'J1:J14';
% xlRange4 = 'K1:K14';
% xlRange5 = 'L1:L14';
% xlRange6 = 'M1:M14';

filename = '标定.xlsx';
sheetname = '红';
xlRange1 = 'E1:E12';
xlRange2 = 'D1:D12';
xlRange3 = 'F1:F12';
xlRange4 = 'G1:G12';
xlRange5 = 'H1:H12';


dx = xlsread(filename,sheetname,xlRange1)/1000;
dpix = xlsread(filename,sheetname,xlRange2)*3.5;
initialGuess1 =xlsread(filename,sheetname,xlRange3);
lb1=xlsread(filename,sheetname,xlRange4);
ub1=xlsread(filename,sheetname,xlRange5);
n=length(dx)+4;

initialGuess =cat(1,initialGuess1,45,7,50,26 );
          lb =cat(1,lb1,40,100,40,25);  %最小值
          ub =cat(1,ub1,50,300,60,30);  %最大值
%%

% residuals  = @(params) solve_y0lphi0theta(dx,dpix,params);
% problem = createOptimProblem('fmincon', 'objective', residuals , 'x0', initialGuess, 'lb', lb, 'ub', ub);
% gs = GlobalSearch('Display', 'iter','NumTrialPoints',10000);
% [xOptGlobal, fValGlobal, exitFlagGlobal, outputGlobal] = run(gs, problem);


residuals  = @(params) solve_y0lphi0theta(dx,dpix,params);
problem = createOptimProblem('fmincon', 'objective', residuals , 'x0', initialGuess, 'lb', lb, 'ub', ub);
gs =MultiStart('Display', 'iter','XTolerance',10e-8,'FunctionTolerance',10e-11,'UseParallel',true);
[xOptGlobal, fValGlobal, exitFlagGlobal, outputGlobal] = run(gs, problem,5000);

% initialGuess=[0.590861773,0.627846105,0.646966239,0.66668223,0.686728664,0.707311366,0.74996383,0.794901498,0.842082097,45,7,50,2.3 ];


%%
theta = xOptGlobal(n-3);
l = xOptGlobal(n-2);
phi0 = xOptGlobal(n-1);
y0= xOptGlobal(n);
disp(['theta = ', num2str(theta)]);
disp(['l =', num2str(l)]);
disp(['phi0 = ', num2str(phi0)]);
disp(['y0 = ', num2str(y0)]);
