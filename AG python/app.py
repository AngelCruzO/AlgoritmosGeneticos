import numpy as np
import matplotlib.pyplot as plt
from ypstruct import structure
import ga

# Cost function
def sphere(x):
    return sum(x**2)

# Problem definition
problem = structure()
problem.costfunc = sphere
problem.nvar = 5
problem.varmin = [-10,-10,-1,-5,4]
problem.varmax = [10,10,1,5,10]

# GA parameters
params = structure()
params.maxit = 100
params.npop = 20
params.beta = 1
params.pc = 1
params.gamma = 0.1
params.mu = 0.1
params.sigma = 0.01

# Run GA
out = ga.run(problem,params)

# Results
plt.plot(out.bestcost)
#plt.semilogy(out.bestcost)
plt.xlim(0, params.maxit)
plt.xlabel('Iterations')
plt.ylabel('Best cost')
plt.title('Genetic algorithm (GA)')
plt.grid(True)
plt.show()
