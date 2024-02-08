option limrow = 0,limcol = 0, solprint = off;
sets
    I /1*6/
    j /x1*x4/;

parameters
    a(I,J)
    b(I) /1 17, 2 -16, 3 7, 4 -15, 5 6, 6 0/;

table a(I,J)
      x1  x2  x3  x4
    1  8  -2   4  -9
    2  1   6  -1  -5
    3  1  -1   1   0
    4  1   2  -7   4
    5  0   0   1  -1
    6  1   0   1  -1;
    
variables
    x(J),
    e(I),
    ztotdev, 
    zminmax;
    
*define objectives, upper bound and lower bound constraint for each equation
equations
    errorupbound,
    errorlobound,
    objective1,
    objective2;

errorupbound(I)..
    sum(J, a(I,J)*x(J)) =g= b(I) - e(I);

errorlobound(I)..
    sum(J, a(I,J)*x(J)) =l= b(I) + e(I);
    
objective1..
    ztotdev =e= sum(I, e(I));
    
objective2(I).. 
    zminmax =g= e(I);

model deviationmodel /errorupbound,errorlobound,objective1/;
solve deviationmodel using lp minimizing ztotdev;

parameters TotalDevSmall, xValSmall(J);

TotalDevSmall = ztotdev.L;
xValSmall(J) = x.l(J);

display TotalDevSmall, xValSmall;

model minmaxdeviation /errorupbound,errorlobound,objective2/;
solve minmaxdeviation using lp minimizing zminmax;

parameters MinMaxDevSmall;
MinMaxDevSmall = zminmax.L;

display MinMaxDevSmall;
