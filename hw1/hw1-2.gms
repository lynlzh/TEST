set I/light, dark/;
set R/malt, hops, yeast/;

scalar lightmax /13/,darkmax /30/;
*lightmax: min(malt/2,hops/3,yeast/2)=13
*darkmax:  min(malt/3,hops/1,yeast/[5/3])=30

table a(R,I)  "Per-Unit resource requirements"
        light   dark
malt      2      3
hops      3      1
yeast     2     [5/3];

parameters
    profitMargin(I) / "light" 2 , "dark" 1 /
    resourcebound(R) /"malt" 90,"hops" 40, "yeast" 80/;

free variable Profit "total profit";

positive variables
x(I) "beer"
ingre(R) "ingredients"

equation
profit_eq         "profit definition"
resource(R)        "resourcebound"
y(R)               "ingredients";

* EQUATION (MODEL) DEFINITION
profit_eq..
  Profit =E= sum(I,profitMargin(I)*x(I));
  
resource(R)..
  sum(I,a(R,I)*x(I)) =L= resourcebound(R);
  
y(R)..
  ingre(R)=E= sum(I,a(R,I)*x(I));
  
* VARIBLE BOUNDS
x.up('light') = lightmax;
x.up('dark') = darkmax;

model softsuds /all/;

solve softsuds using lp maximizing profit;

variables quant(I),ingredients(R);

quant.l(I) = x.l(I);

ingredients.l(R) = ingre.l(R)

display ingredients.l;

display Profit.l,quant.l;


