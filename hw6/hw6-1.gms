set I /1*6/;

parameter
 minInvest(I) /1 3, 2 2, 3 9, 4 5, 5 12, 6 4/,
 maxInvest(I) /1 27, 2 12, 3 35, 4 15, 5 46, 6 18/,
 expReturn(I) /1 113, 2 109, 3 117, 4 110, 5 122, 6 112/;

positive variable investAmount(I);

binary variable investDecision(I);

variable z;

equation
objFunction
totalInvestmentConstraint
maxAmountConstraint(I)
minAmountConstraint(I)
x5Constraint
x6Constraint;

objFunction..
z =e= sum(I, investAmount(I)*expReturn(I)/100);

totalInvestmentConstraint..
sum(I, investAmount(I)) =l= 80;

maxAmountConstraint(i)..
investAmount(I) =l= maxInvest(I) * investDecision(I);

minAmountConstraint(I)..
investAmount(I) =g= minInvest(I) * investDecision(I);

x6Constraint..
investAmount('6') =g= minInvest('6') * investDecision('3');

x5Constraint..
investAmount('5') =l= (investAmount('2') + investAmount('4') + investAmount('6'));

model investmentmodel /all/;

solve investmentmodel using MIP maximizing z;

parameter expectedReturn;
expectedReturn = z.l;display expectedReturn;

set investments(I);
investments(I) = (investAmount.l(I) > 0.5);
options investments:0:0:1; display investments;




