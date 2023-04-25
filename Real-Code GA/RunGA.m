%RunGA
%inicia el GA
%problem: struct con la definicion del problema
%params: struct con los parametros para el GA
%out
function out = RunGA(problem, params)

    % Problem
    CostFunction = problem.CostFunction;
    nVar = problem.nVar;
    SizeVar = [1,nVar];
    VarMin = problem.VarMin;
    VarMax = problem.VarMax;

    % Params
    MaxIt = params.MaxIt;
    nPop = params.nPop;
    beta = params.beta;
    pC = params.pC;
    gamma = params.gamma;
    nC = round(pC*nPop/2)*2; % numero par
    mu = params.mu;
    sigma = params.sigma;

    % Template for empty individuals
    empty_individual.Position = [];
    empty_individual.Cost = [];

    % Best solution ever found
    bestsol.Cost = inf;

    % Initialization
    pop = repmat(empty_individual, nPop, 1); %poblacion inicial
    for i=1:nPop
        % Generate random solution
        pop(i).Position = unifrnd(VarMin,VarMax,SizeVar); %individuo nuevo
        pop(i).Cost = CostFunction(pop(i).Position); %costo del individuo valuado en fitness
        
        % eleccion del mejor costo
        if pop(i).Cost < bestsol.Cost
            bestsol = pop(i);
        end

    end

    % Best cost iterations
    bestcost = nan(MaxIt,1);

    % Main loop
    for it=1:MaxIt
        
        % Initialize offsprings population
        popc = repmat(empty_individual, nC/2, 2); % nuevos individuos
        
        % Crossover
        for k=1:nC/2
            
            % Selection probabilities
            c = [pop.Cost];
            avgc = mean(c);
            if avgc ~= 0
                c = c/avgc;
            end
            probs = exp(-beta*c);

            % Select parents
            %q = randperm(nPop);
            %p1 = pop(q(1));
            %p2 = pop(q(2));
            p1 = pop(RouletteWheelsSelection(probs));
            p2 = pop(RouletteWheelsSelection(probs));
                    
            % Perfom crossover
            [popc(k, 1).Position, popc(k,2).Position] = ...
                UniformCrossover(p1.Position, p2.Position,gamma);

        end
        
        % Convert popc to single-column matrix
        popc = popc(:);

        % Mutation
        for l=1:nC
            % Perform mutation
            popc(l).Position = Mutate(popc(1).Position,mu,sigma);
            
            % Check for variable bounds
            popc(1).Position = max(popc(1).Position,VarMin);
            popc(1).Position = min(popc(1).Position,VarMax);

            % Evaluate
            popc(l).Cost = CostFunction(popc(1).Position);

            if popc(l).Cost < bestsol.Cost
                bestsol = popc(l);
            end

        end

        % Merge and Sort population
        pop = SortPopulation([pop; popc]);

        % Remove extra indivuduals
        pop = pop(1:nPop);

        % Update best cost of iteration
        bestcost(it) = bestsol.Cost;

        % Display iteration information
        disp(['Iteration ' num2str(it) ': Best Cost = ' num2str(bestcost(it))]);

    end
    
    % Results
    out.pop = pop;
    out.bestsol = bestsol;
    out.bestcost = bestcost;

end