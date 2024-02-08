set oper /o1*o8/
    machine /m1,m2/
    part /p1*p3/
    t(part,oper)/p1.o1,p1.o2,p2.o3,p2.o4,p2.o5,p3.o6,p3.o7,p3.o8/;

alias (oper,i,j);
alias (part,x,y);

parameter procdata(part,oper,machine)
/ p1.o1.m1      4
  p1.o2.m2      2
  p2.o3.m2      3
  p2.o4.m1      2
  p2.o5.m1      2
  p3.o6.m2      3
  p3.o7.m1      2
  p3.o8.m2      1/;

binary variables
m(machine,part,oper,part,oper)
o(part,oper,oper);

positive variables
start(part,oper);

free variable makespan;

scalar total;
total=sum((part,oper,machine), procdata(part,oper,machine));

equations
objective
ordm1
ordm2
ordo1
ordo2
part1
part2
part2con
part3;

objective(part,oper,machine)..
makespan=g=start(part,oper)+procdata(part,oper,machine);

ordm1(machine,x,i,y,j)$((procdata(x,i,machine) gt 0) and (procdata(y,j,machine) gt 0)  and t(x,i) and t(y,j) and  (i.ord<j.ord))..
start(x,i) + procdata(x,i,machine)  =l= start(y,j) + total*(1-m(machine,x,i,y,j));

ordm2(machine,x,i,y,j)$((procdata(x,i,machine) gt 0) and (procdata(y,j,machine) gt 0) and t(x,i) and t(y,j) and  (i.ord<j.ord))..
start(y,j) + procdata(y,j,machine) =l= start(x,i) + total*m(machine,x,i,y,j);
  
ordo1(machine,part,i,j)$((procdata(part,i,machine) gt 0) and (procdata(part,j,machine) gt 0) and t(part,i) and t(part,j) and i.ord<j.ord)..
start(part,i)+procdata(part,i,machine) =l= start(part,j) + total*(1-o(part,i,j));
  
ordo2(machine,part,i,j)$((procdata(part,i,machine) gt 0) and (procdata(part,j,machine) gt 0) and t(part,i) and t(part,j) and i.ord<j.ord)..
start(part,j)+procdata(part,j,machine) =l= start(part,i) + total*o(part,i,j);
  
part1..
start('p1','o2')=g=start('p1','o1')+procdata('p1','o1','m1');
  
part2..
start('p2','o5')=g=start('p2','o3')+procdata('p2','o3','m2');

part2con..
start('p2','o5')=g=start('p2','o4')+procdata('p2','o4','m1');
  
part3..
start('p3','o8')=g=start('p3','o7')+procdata('p3','o7','m1');
  
model makespanmodel /all/;
solve makespanmodel using mip minimizing makespan;

loop((part,oper)$(t(part,oper)),
    start.l(part,oper) = max(start.l(part,oper),EPS);
);

option makespan:1,start:1:0:1;
display makespan.l, start.l;