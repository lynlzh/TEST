option limrow = 0,limcol = 0, solprint = off;
sets
*set of month
m /March, April/
*set of reservior
r /A, B/;           

parameters
*Initialize various parameters 
storageCapacity(r) /A 2000, B 1500/
minLevel(r)        /A 1200, B 800/
inflow(m, r)       /March.A 200, March.B 40, April.A 130, April.B 15/
initialLevel(r)    /A 1900, B 850/
conversion(r)      /A 400, B 200/
powercapacity(r)   /A 60000, B 35000/

normalRate         /5/
excessRate         /3.5/
normalRateLimit    /50000/;

*Define positive variables representing spills, power generated, outflow, normal and excess powerfor each month
positive variables
spill(m, r) 
power(m, r)
outflow(m, r)
normalPower(m)
excessPower(m)
normalProfit(m)
excessProfit(m);

*Define variable representing the total profit and the water level in each reservoir at the end of each month
variables
*total profit of power March and April
profit
*water in reservior at the end of month
reservoirLevel(m, r);

equations
*reservoir A in April
levelbalanceA1

*reservoir A in March
levelbalanceA2

*reservoir B in April
levelbalanceB1

*reservoir B in March
levelbalanceB2

*POWER BOUNDARY
totalpower

*TOTAL PROFIT
profitcal

*POWER CAPACITY
powercapacityconstraint

*max Reservoir Constraint
maxreservoirconstraint

*min Reservoir Constraint
minreservoirconstraint

*normal power profit
normalProfitConstraint

*excessive power profit
excessProfitConstraint(m);

levelbalanceA1(m)$(ord(m) > 1)..
    reservoirLevel(m-1, 'A') + inflow(m, 'A') - spill(m, 'A')- outflow(m, 'A') - power(m, 'A') / conversion('A') =g= minLevel('A');

levelbalanceA2('March')..
    initialLevel('A') + inflow('March', 'A') - spill('March', 'A')
    - outflow('March', 'A') - power('March', 'A') / conversion('A') =g= minLevel('A');

levelbalanceB1(m)$(ord(m) > 1)..
    reservoirLevel(m-1, 'B') + inflow(m, 'B') + outflow(m, 'A')
    - spill(m, 'B') - power(m, 'B') / conversion('B') =g= minLevel('B');

levelbalanceB2('March')..
    initialLevel('B') + inflow('March', 'B') + outflow('March', 'A')
    - spill('March', 'B') - power('March', 'B') / conversion('B') =g= minLevel('B');
    
*Calculate total power
totalpower(m)..
    sum(r, power(m, r)) =e= normalPower(m) + excessPower(m);
    
*Power Plant Capacity Constraint
powercapacityconstraint(m, r)..
    power(m, r) =l= powercapacity(r);

maxreservoirconstraint(m, r)..
    reservoirLevel(m, r) =l= storageCapacity(r);

minreservoirconstraint(m, r)..
    reservoirLevel(m, r) =g= minLevel(r);
    
*Calculate normal power pofit
normalProfitConstraint(m)..
    normalProfit(m) =l= normalRate * min(normalRateLimit, normalPower(m));
    
*Calculate excess power pofit
excessProfitConstraint(m)..
    excessProfit(m) =l= excessRate * max(0, normalPower(m) - normalRateLimit);
    
*total profit   
profitcal..
    profit =e= sum(m, normalProfit(m) + excessProfit(m))

model powerprofit /all/;
solve powerprofit using dnlp maximizing profit;

display profit.l;
