sets i Product   /i1*i2/
     j Part      /j1*j5/;
     
Table Data(*,*)
          j1      j2      j3      j4      j5   l     q     d
c         10      30      10      100     50
v         1       8       2       30      10
i1        10      5       5       1       1    500   1200  10
i2        8       5       0       2       1    600   3000  20;

set r /1*3/;

table cd(i,r,*)
       1.v 1.p  2.v  2.p  3.v  3.p
i1    5.00 0.1  10.0 0.2  12.0 0.7
i2    17.0 0.1  20.0 0.2  25.0 0.7;

set s/s1*s9/;

table d(i,s)
    s1   s2   s3   s4   s5   s6   s7   s8   s9
i1  5    5    5    10   10   10   12   12   12
i2  17   20   25   17   20   25   17   20   25 ;

parameter
prob(s)
/s1 0.01,s2 0.02,s3 0.07,s4 0.02,s5 0.04,s6 0.14,s7 0.07,s8 0.14,s9 0.49/;

parameters
       a(i,j) how many part j needed to make a unit of product i
       c(j)   cost of procuring a unit of part j
       v(j)   salvage value of a unit of part j
       l(i)   manufacturing cost of a unit of product i
       q(i)   selling price of a unit of product i,
       md(i)  mean demand of product i;

a(i,j) = Data(i,j);
c(j)   = Data('c',j);
v(j)   = Data('v',j);
l(i)   = Data(i,'l');
q(i)   = Data(i,'q');
md(i)  = Data(i,'d');

parameter
cost(i);

cost(i)=sum(j,c(j)*a(i,j));
*display cost;

positive variable
x(i)
y(j);

variable tc;

equations obj
          demand
          prodn;
obj..
  tc=e=sum(i,x(i)*(q(i)-l(i)))-sum(j,y(j)*c(j))+sum(j,(y(j)-sum(i,a(i,j)*x(i)))*v(j));

demand(i)..
  x(i)=l=md(i);
  
prodn(j)..
 y(j)=g=sum(i,x(i)*a(i,j)); 

model assem /all/;

solve assem using mip maximizing tc;

positive variable x_d(i,s),y_d(j);
variable tc_d;

equations obj_d,demand_d,prodn_d;

prodn_d(j,s)..
 y_d(j)=g=sum(i,x_d(i,s)*a(i,j)); 

demand_d(i,s)..
  x_d(i,s)=l=d(i,s);
  
obj_d..
  tc_d=e=sum((i,s),x_D(i,s)*(q(i)-l(i))*prob(s))-sum(j,y_d(j)*c(j))+sum(j,(y_d(j)-sum((i,s),a(i,j)*x_d(i,s)*prob(s)))*v(j));
  
model assem_d /obj_d,demand_d,prodn_d/;

solve assem_d using mip maximizing tc_d;


display x_d.l,y_d.l,tc_d.l;

$funclibin stolib stodclib
Functions
randpoisson     /stolib.dpoisson/,
setseedh     /stolib.SetSeed /;
scalar seedno; seedno=setseedh(39183);

*100 scenarios
$onmultir
$if not set NSCEN $set NSCEN 100
set s ’scenarios’ / s1*s%NSCEN% /;

parameter o(*),f(*,j);
Parameter
       d(i,s) demand of product i in scenario s,
       prob(s)   scenario probability;
d('i1',s) = randpoisson(10); d('i2',s) = randpoisson(20);
prob(s)  =  1/card(s);
positive variable x_d(i,s),y_d(j);
variable tc_d;

equations obj_d
          demand_d
          prod_d;
obj_d..
  tc_d=e=sum((i,s),x_D(i,s)*(q(i)-l(i))*prob(s))-sum(j,y_d(j)*c(j))+sum(j,(y_d(j)-sum((i,s),a(i,j)*x_d(i,s)*prob(s)))*v(j));

demand_d(i,s)..
  x_d(i,s)=l=d(i,s);
  
prod_d(j,s)..
 y_d(j)=g=sum(i,x_d(i,s)*a(i,j)); 
  
model assem100 /obj_d,demand_d,prodn_d/;

solve assem100 using mip maximizing tc_d;

o('%NSCEN%')=tc_d.l;
f('%NSCEN%',j)=y_d.l(j);

*200 scenarios
$set NSCEN 200
set s ’scenarios’ / s1*s%NSCEN% /;
parameter
       d(i,s) demand of product i in scenario s,
       prob(s)   scenario probability;
d('i1',s) = randpoisson(10); d('i2',s) = randpoisson(20);
prob(s)  =  1/card(s);
positive variable x_d(i,s),y_d(j);
variable tc_d;

equations obj_d,demand_d,prodn_d;

obj_d..
  tc_d=e=sum((i,s),x_D(i,s)*(q(i)-l(i))*prob(s))-sum(j,y_d(j)*c(j))+sum(j,(y_d(j)-sum((i,s),a(i,j)*x_d(i,s)*prob(s)))*v(j));

demand_d(i,s)..
  x_d(i,s)=l=d(i,s);
  
prodn_d(j,s)..
 y_d(j)=g=sum(i,x_d(i,s)*a(i,j)); 

model assem200 /obj_d,demand_d,prodn_d/;

solve assem200 using mip maximizing tc_d;

o('%NSCEN%')=tc_d.l;
f('%NSCEN%',j)=y_d.l(j);


*400 scenarios
$set NSCEN 400
set s  / s1*s%NSCEN% /;
Parameter
       d(i,s) demand of product i in scenario s,
       prob(s)   scenario probability;
d('i1',s) = randpoisson(10); d('i2',s) = randpoisson(20);
prob(s)  =  1/card(s);
positive variable x_d(i,s),y_d(j);
variable tc_d;

equations obj_d,demand_d,prodn_d;

obj_d..
  tc_d=e=sum((i,s),x_D(i,s)*(q(i)-l(i))*prob(s))-sum(j,y_d(j)*c(j))+sum(j,(y_d(j)-sum((i,s),a(i,j)*x_d(i,s)*prob(s)))*v(j));

demand_d(i,s)..
  x_d(i,s)=l=d(i,s);
  
prodn_d(j,s)..
 y_d(j)=g=sum(i,x_d(i,s)*a(i,j)); 

model assem400 /obj_d,demand_d,prodn_d/;

solve assem400 using mip maximizing tc_d;

o('%NSCEN%')=tc_d.L;
f('%NSCEN%',j)=y_d.l(j);

*800 scenarios
$set NSCEN 800
set s ’scenarios’ / s1*s%NSCEN% /;
parameter
       d(i,s) demand of product i in scenario s,
       prob(s)   scenario probability;
d('i1',s) = randpoisson(10); d('i2',s) = randpoisson(20);
prob(s)  =  1/card(s);
positive variable x_d(i,s),y_d(j);
variable tc_d;

equations obj_d
          demand_d
          prodn_d;

obj_d..
  tc_d=e=sum((i,s),x_D(i,s)*(q(i)-l(i))*prob(s))-sum(j,y_d(j)*c(j))+sum(j,(y_d(j)-sum((i,s),a(i,j)*x_d(i,s)*prob(s)))*v(j));

demand_d(i,s)..
  x_d(i,s)=l=d(i,s);
  
prodn_d(j,s)..
 y_d(j)=g=sum(i,x_d(i,s)*a(i,j)); 
  
model assem800 /obj_d,demand_d,prodn_d/;

solve assem800 using mip maximizing tc_d;

o('%NSCEN%')=tc_d.l;
f('%NSCEN%',j)=y_d.l(j);

*1600 scenarios
$set NSCEN 1600
set s ’scenarios’ / s1*s%NSCEN% /;
Parameter
       d(i,s) demand of product i in scenario s,
       prob(s)   scenario probability;
d('i1',s) = randpoisson(10); d('i2',s) = randpoisson(20);
prob(s)  =  1/card(s);
positive variable x_d(i,s),y_d(j);
variable tc_d;

equations obj_d
          demand_d
          prodn_d;
obj_d..
  tc_d=e=sum((i,s),x_D(i,s)*(q(i)-l(i))*prob(s))-sum(j,y_d(j)*c(j))+sum(j,(y_d(j)-sum((i,s),a(i,j)*x_d(i,s)*prob(s)))*v(j));
  
demand_d(i,s)..
  x_d(i,s)=l=d(i,s);
  
prodn_d(j,s)..
 y_d(j)=g=sum(i,x_d(i,s)*a(i,j)); 

model assem1600 /obj_d,demand_d,prodn_d/;

solve assem1600 using mip maximizing tc_d;

o('%NSCEN%')=tc_d.l;
f('%NSCEN%',j)=y_d.l(j);

*10000 scenarios
$set NSCEN 10000
set s  / s1*s%NSCEN% /;
Parameter
       d(i,s) demand of product i in scenario s,
       prob(s)   scenario probability;
d('i1',s) = randpoisson(10); d('i2',s) = randpoisson(20);
prob(s)  =  1/card(s);
positive variable
x_d(i,s)
y_d(j);
variable tc_d;

equations obj_d
          demand_d
          prodn_d;
obj_d..
  tc_d=e=sum((i,s),x_D(i,s)*(q(i)-l(i))*prob(s))-sum(j,y_d(j)*c(j))+sum(j,(y_d(j)-sum((i,s),a(i,j)*x_d(i,s)*prob(s)))*v(j));

demand_d(i,s)..
  x_d(i,s)=l=d(i,s);
  
prodn_d(j,s)..
 y_d(j)=g=sum(i,x_d(i,s)*a(i,j)); 
  
model assem10000 /obj_d,demand_d,prodn_d/;

solve assem10000 using mip maximizing tc_d;

o('%NSCEN%')=tc_d.l;
f('%NSCEN%',j)=y_d.l(j);

display o,f;

*The expected profit values in parameter o fluctuate as the number of scenarios increases, but they don't show a clear trend towards convergence. This might suggest that the model's objective value is sensitive to the scenario sampling and might require more scenarios for convergence or a different approach to sampling to achieve stability. The first-stage variables in parameter f representing the parts quantities remain mostly constant as the number of scenarios increases, with a minor change in j3 when the number of scenarios is 1600. This indicates that the first-stage decisions are robust to the number of scenarios, showing a strong sign of convergence and stability.