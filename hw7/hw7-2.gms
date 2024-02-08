sets T, P, C(P), N(P);
parameters d(T), cost(P), ell(P), u(P);
$gdxin ucdata.gdx
$load T,P,C,N,d,cost,ell,u
$gdxin

positive variable g(p,t);

binary variable
x(p,t)
count(t)
y(n,t);

free variable TotalCost;

equations
objective
DemandConstraint
LowerBoundConstraint
UpperBoundConstraint
NuclearConstraint
SafetyConstraint
Coal1
Coal2
button1
button2;

objective..
TotalCost=e=sum((p,t),g(p,t)*cost(p));

DemandConstraint(t)..
sum(p,g(p,t))=g=d(t);

LowerBoundConstraint(p,t)..
ell(p)*x(p,t)=l=g(p,t);

UpperBoundConstraint(p,t)..
u(p)*x(p,t)=g=g(p,t);

Coal1(t)..
count(t)*(card(c)-1)=g=sum(c,x(c,t))-1;

Coal2(t)..
2*count(t)=l=sum(c,x(c,t));

NuclearConstraint(t)..
sum(n,x(n,t))=g=3*(count(t));

SafetyConstraint(n,t)..
x(n,t)+x(n,t+1)+x(n,t+2)+x(n,t+3)=g=4*y(n,t);

button1(n,t)..
x(n,t) + (1-x(n, t-1))=g=2*y(n,t);

button2(n,t)..
x(n,t)-x(n,t-1)=l=y(n,t);

model powerplants /all/;
powerplants.optcr = 1e-6

solve powerplants using mip minimizing TotalCost;

set oper(p,t);
oper(p,t) = yes$(x.l(p,t) > 0.5);
option oper:0:0:1;
display oper;
