clc;
clear;
close all;

%Structs
%problem
%params

%% Problem definition
problem.CostFunction = @(x) Sphere(x); % funcion anonima para tratar Sphere
problem.nVar = 5; % No. de variables
problem.VarMin = [-10 -10 -5 -1 5];
problem.VarMax = [10 10 5 1 8];

%% GA Parameters
params.MaxIt = 100; % No. maximo de iteraciones
params.nPop = 1000; % numero de la población inicial

params.beta = 1;
params.pC = 1; % porcentaje de cruza
params.gamma = 0.1;
params.mu = 0.02;
params.sigma = 0.1;

%% Run GA
out = RunGA(problem,params);

%% Results
figure;

%plot(out.bestcost,'LineWidth',2);
semilogy(out.bestcost,'LineWidth',2);
xlabel('Iterations');
ylabel('Best Cost');
grid on;
