option limrow = 0, limcol = 0;

sets
   sites /area1,area2,area3,area4/
   species /Pine, Spruce, Walnut, Hardwd/;

parameters
   area(sites)            /"area1" 1500, "area2" 1700, "area3" 900, "area4" 600/
   yield(sites, species) /area1.Pine 17, area1.Spruce 14, area1.Walnut 10, area1.Hardwd 9,
                          area2.Pine 15, area2.Spruce 16, area2.Walnut 12, area2.Hardwd 11,
                          area3.Pine 13, area3.Spruce 12, area3.Walnut 14, area3.Hardwd 8,
                          area4.Pine 10, area4.Spruce 11, area4.Walnut 8, area4.Hardwd 6/;

parameter
minreqyield(species) /Pine 22500, Spruce 9000, Walnut 4800, Hardwd 3500/;

parameter
revenue(sites, species) /area1.Pine 16, area1.Spruce 12, area1.Walnut 20, area1.Hardwd 18,
                        area2.Pine 14, area2.Spruce 13, area2.Walnut 24, area2.Hardwd 20,
                        area3.Pine 17, area3.Spruce 10, area3.Walnut 28, area3.Hardwd 20,
                        area4.Pine 12, area4.Spruce 11, area4.Walnut 18, area4.Hardwd 17/;  

positive variables
grow(sites, species);
   
free variables
profit;
   
equations
   totalareaallocated(sites)
   minyieldrequirement(species)
   profit_con;

totalareaallocated(sites)..
sum(species, grow(sites, species)) =l= area(sites);

minyieldrequirement(species)..
sum(sites, yield(sites, species) * grow(sites, species)) =g= minreqyield(species);

profit_con..
profit =e= sum((sites, species), revenue(sites, species) * grow(sites, species));

model forest /all/;

solve forest using lp maximizing profit;

scalar mstat,sstat;

mstat = forest.Modelstat;

sstat = forest.Solvestat;

display grow.l, profit.l;

display mstat,sstat;