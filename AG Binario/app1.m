clc;
clear;
close all;

%Structs
%problem
%params

%% Problem definition
problem.CostFunction = @(x) MinOne(x); % funcion anonima para tratar MinOne
problem.nVar = 100; % No. de variables

%% GA Parameters
params.MaxIt = 100; % No. maximo de iteraciones
params.nPop = 100; % numero de la población inicial

params.beta = 1;
params.pC = 1; % porcentaje de cruza
params.mu = 0.02;

%% Run GA
out = RunGA(problem,params);

%% Results
figure;

plot(out.bestcost,'LineWidth',2);
xlabel('Iterations');
ylabel('Best Cost');
grid on;
