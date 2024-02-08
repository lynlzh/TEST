option limrow = 100, limcol=0;

sets people /p1*p7/, months /Feb, Mar, Apr, May, Jun, Jul, Aug, Sept/,
    nodes(people,months);
    
parameter workers(months) /Feb 3, Mar 4, Apr 6, May 7, Jun 4, Jul 6, Aug 2, Sept 3/;

alias(people, m, n, g);

nodes(m,months) = Yes$(workers(months)/ord(m) < 1.25);

nodes(m, 'Feb') = No;
nodes('p3', 'Feb') = Yes;

nodes(m, 'Sept') = No;
nodes('p3', 'Sept') = Yes;

parameter b(people,months);

b('p3', 'Feb')= 1;

b('p3', 'Sept')= -1;

set arcs(people, months, people, months);

arcs(m,months, n, months+1)= Yes$(((ord(n)-ord(m)) le [1/3]*ord(m)) and abs(ord(n)- ord(m)) le 3);

parameter move(people, months, people, months), sh(people, months, people, months);

sh(m, months, n, months+1)$(arcs(m, months, n, months+1)) = abs(ord(n)-workers(months+1)) * 200;

move(m, months, n, months+1)$(arcs(m, months, n, months+1)) = n.ord - m.ord;

move(m, months, n, months+1)$(move(m, months, n, months+1) < 0) = move(m, months, n, months+1)*160;

move(m, months, n, months+1)$(move(m, months, n, months+1) > 0) = move(m, months, n, months+1)*100;

move(m, months, n, months+1) = abs(move(m, months, n, months+1));

move(m, months, n, months+1) = move(m, months, n, months+1) + sh(m, months, n, months+1);

positive variable flow(people, months, people, months);

variable totime;

equations
  obj,
  balance(people, months);
  
obj..
  totime =e= sum(arcs, move(arcs) * flow(arcs));

balance(m, months)..
  b(m, months) =e= sum(nodes(n, months+1)$(arcs(m, months, n, months+1)), flow(m, months, n, months+1))- sum(nodes(n, months-1)$arcs(n, months-1, m, months), flow(n, months-1, m, months));
  
model short /all/;

$onecho>cplex.opt
lpmethod 3
netfind 2
preind 0
$offecho

solve short using lp minimizing totime;

option flow:0:0:1;

display flow.l;

display workers;


