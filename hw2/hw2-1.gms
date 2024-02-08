set R /r1,r2,r3/;
set T /t1,t2,t3/;
set C1 /c1/;
set C2 /c2/;

table a(R,T)
    t1  t2  t3
r1  9   6    4
r2  5   8   11
r3  50 75  100;

table chem1(C1,T)
    t1 t2  t3
c1  9  7   10;

table chem2(C2,T)
    t1 t2  t3
c2  6  10  6;

parameters
  resourcebound(R) /"r1" 200,"r2" 400,"r3" 1850/
  chemical1(T) /"t1" 9, "t2" 7, "t3" 10/
  chemical2(T) /"t1" 6, "t2" 10, "t3" 6/;

free variables
blend;

positive variables
x(T);

equation
  resource_con(R)
  chemical1_con(C1)
  chemical2_con(C2);

resource_con(R)..
  sum(T,a(R,T)*x(T)) =L= resourcebound(R);
  
chemical1_con(C1)..
  5*blend =L= sum(T,chem1(C1,T)*x(T));

chemical2_con(C2)..
  2*blend =L= sum(T,chem2(C2,T)*x(T));

model chemmod /all/;

solve chemmod using lp max blend;

scalar mstat,sstat;

mstat = chemmod.Modelstat;

sstat = chemmod.Solvestat;

parameter proctime(T);

proctime(T) = x.l(T);

display mstat,sstat,blend.l,proctime;

   
  