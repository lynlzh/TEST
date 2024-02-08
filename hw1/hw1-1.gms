option limrow = 0, limcol = 0;

parameter x1val, x2val, x3val, objval;

free variable obj;

positive variable x1, x2, x3;

equation objective,conLes,conGr,conE;

objective..
obj =e= 3*x1 + 4*x2-20*x3;

conLes..
x1-4*x2+2*x3 =l= 10;

conGr..
5*x1-9*x2+3 =l= 0;

conE..
3*x1+6*x3 =e= 12;

model hw1_1 /all/;
solve hw1_1 using lp minimizing obj;


objval = obj.l; x1val = x1.l; x2val = x2.l; x3val = x3.l;

display "Parameters";

display objval, x1val, x2val, x3val ;
