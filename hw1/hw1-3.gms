set I/p1, p2/;
set R/s1, s2, s3/;

table a(R,I)  "Per-Unit resource requirements"
          p1     p2
s1        5      10
s2        9      2
s3        7      5;

parameters
    sellprice(I) / "p1" 108 , "p2" 84 /
    manhour(I) / "p1" 10, "p2" 8 /
    timebound(R) / "s1"  40,  "s2"  40, "s3"  40/;

free variable Profit "total profit";

positive variables
x(I)     "product"
store(R) "store hours consumed"


equation
profit_eq(R)         "profit definition"
resource_con(R)      "resource limit" 
stores(R)            "store hours consumed";

profit_eq(R)..
  Profit=E=sum(I,sellprice(I)*x(I))-sum(I,manhour(I)*x(I))*5;
  
resource_con(R)..
  sum(I, a(R,I)*x(I)) =L= timebound(R);
  
stores(R)..
  store(R)=E= sum(I, a(R,I)*x(I));
  
model prodmix /all/;

solve prodmix using lp maximizing Profit;

variables make(I),storehours(R);

make.l(I) = x.l(I);

storehours.l(R) = store.l(R);

display storehours.l;

display Profit.l,make.l;
