import numpy as np
from ypstruct import structure

def run(problem,params):

    # Problem information
    costfunc = problem.costfunc
    nvar = problem.nvar
    varmin = problem.varmin
    varmax = problem.varmax

    # Parameters
    maxit = params.maxit
    npop = params.npop
    beta = params.beta
    pc = params.pc
    nc = int(np.round(pc*npop/2)*2)
    gamma = params.gamma
    mu = params.mu
    sigma = params.sigma
 
    # Empty individual template
    empty_individual = structure()
    empty_individual.position = None
    empty_individual.cost = None

    # Best solution ever found
    bestsol = empty_individual.deepcopy()
    bestsol.cost = np.inf

    # Initialize population
    pop = empty_individual.repeat(npop)
    for i in range(0,npop):
        pop[i].position = np.random.uniform(varmin, varmax, nvar)
        pop[i].cost = costfunc(pop[i].position)
        if pop[i].cost < bestsol.cost:
            bestsol = pop[i].deepcopy()
    
    #Best cost of iterations
    bestcost = np.empty(maxit)

    # Main loop
    for it in range(maxit):

        costs = np.array([x.cost for x in pop])
        avg_cost = np.mean(costs)
        if avg_cost != 0:
            costs = costs/avg_cost
        probs = np.exp(-beta*costs)    

        popc = []
        for _ in range(nc//2):
            
            # Select parents
            q = np.random.permutation(npop)
            p1 = pop[q[0]]
            p2 = pop[q[1]]
            
            # Perform crossover
            c1, c2 = crossover(p1,p2,gamma)

            # Perform mutation
            c1 = mutate(c1, mu, sigma)
            c2 = mutate(c2, mu, sigma)

            # Apply bounds
            apply_bound(c1,varmin,varmax)
            apply_bound(c2,varmin,varmax)

            # Evaluate first offspring
            c1.cost = costfunc(c1.position)
            if c1.cost < bestsol.cost:
                bestsol = c1.deepcopy()
            
            # Evaluate second offspring
            c2.cost = costfunc(c2.position)
            if c2.cost < bestsol.cost:
                bestsol = c2.deepcopy()

            # Add oofsprings to popc
            popc.append(c1)
            popc.append(c2)

        # Merge, sort and select
        pop += popc
        pop = sorted(pop, key=lambda x: x.cost)
        pop = pop[0:npop]

        # Store best cost
        bestcost[it] = bestsol.cost

        # Show iteration information
        print(f"Iteration {it}: Best cost {bestcost[it]}")

    # Output
    out = structure()
    out.pop = pop
    out.bestsol = bestsol
    out.bestcost = bestcost
    return out

def crossover(p1,p2,gamma=0.1):

    c1 = p1.deepcopy()
    c2 = p1.deepcopy()

    alpha = np.random.uniform(-gamma,1+gamma,*c1.position.shape)
    c1.position = alpha*p1.position + (1-alpha)*p2.position
    c2.position = alpha*p2.position + (1-alpha)*p1.position
    return c1, c2

def mutate(x,mu,sigma):

    y = x.deepcopy()
    flag = np.random.rand(*x.position.shape) <= mu
    ind = np.argwhere(flag)
    y.position[ind] += sigma*np.random.randn(*ind.shape)
    return y

def apply_bound(x,varmin,varmax):
    x.position = np.maximum(x.position, varmin)
    x.position = np.minimum(x.position, varmax)

def roulette_wheel_selection(p):
    c = np.cumsum(p)
    r = sum(p)*np.random.rand()
    ind = np.argwhere(r <= c)
    return ind[0][0]
