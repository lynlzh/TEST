*$include 2.1.inc
*$include 2.2.1.inc
*$include 2.2.2.inc
$include 2.2.3.inc

free variable profit "total profit";

parameter resprof(*);      

positive variables
produce(I);

equation
  profit_eq
  resource_con(R);

profit_eq..
  profit=e=sum(I,profitMargin(I)*produce(I));
  
resource_con(R)..
  sum(I,a(R,I)*produce(I))=L=resourcebound(R);

model books /all/;

solve books using lp maximizing profit;

*resprof('2.1') = Profit.l;

*resprof('2.2.1') = Profit.l;

*resprof('2.2.2') = Profit.l;

resprof('2.2.3') = profit.l;

display resprof,produce.l;