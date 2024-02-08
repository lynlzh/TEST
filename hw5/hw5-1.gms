option limrow = 100, limcol=0;
*1.1
set nodes /s, month1*month4, project1*project3, t/;

alias(i,j,k,nodes);

set month(nodes) /month1*month4/;

set project(nodes) /project1*project3/;

set arcs(i,j);
arcs('s',month) = yes;
arcs(month,project) = yes;
arcs(project,'t') = yes;

parameter u(i,j);
u('s',month) = 8;
u(month,project) = 6;
u('month1','project3') = 12;  
u('project1','t') = 8;
u('project2','t') = 10;
u('project3','t') = 12;

positive variables x(i,j);

variable totalworkers;

equations defobj, balance(i);

defobj..
  totalworkers =e= sum(j$arcs('s',j), x('s',j));

balance(i)$(not (sameas(i,'s') or sameas(i,'t')))..
    sum(k$arcs(i,k), x(i,k)) - sum(j$arcs(j,i), x(j,i)) =e= 0;

model maxflow /defobj,balance/;

x.up(arcs) = u(arcs);

$onecho > cplex.opt
lpmethod 3
netfind 2
preind 0
$offecho
maxflow.optfile = 1;

solve maxflow using lp maximizing totalworkers;

option x:0:1:1;

display x.l;

variable dualobj,totmonths;

positive variables pi(i,j);

variables phi(i);

equation
  def_dualobj,
  dualcons(i,j),
  def_totmonths;

def_dualobj..
  dualobj =e= sum((i,j)$arcs(i,j), u(i,j)*pi(i,j));

dualcons(i,j)$arcs(i,j)..
  phi(i)$(not sameas(i,'s')) + pi(i,j) - phi(j)$(not sameas(j,'t')) =g= 1$sameas(i,'s');

def_totmonths..
  totmonths =e= sum(month, x('s', month));

model dualflow /def_dualobj, dualcons, def_totmonths/;


solve dualflow using lp minimizing dualobj;

option pi:2:0:1;

display totmonths.l, dualobj.l, pi.l;