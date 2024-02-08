set orig(*), dest(*);
parameter supply(orig), demand(dest), rate(orig,dest), limit(orig,dest);
$macro trnfn(x) x/(1 - (x)**0.8/limit(orig,dest))
$gdxin C:\Users\lanya\Documents\GAMS\Studio\workspace\nltrans.gdx
$load orig,dest,supply,demand,rate,limit
$gdxin

set bpp 'price break points' /0*3/;
set bps(bpp) 'price break segments' /1*3/;
alias(i,bps);

variables
x(orig,dest)
y(orig,dest)
w(orig,dest,bpp);

binary variables sup(orig,dest,bpp);

table p(orig, dest, bpp);
p(orig, dest, '0') = 0;
p(orig, dest, '1') = limit(orig, dest)/3;
p(orig, dest, '2') = 2*limit(orig, dest)/3;
p(orig, dest, '3') = limit(orig, dest);

table cost(orig,dest,bpp);
cost(orig, dest, '0') = trnfn(0);
cost(orig, dest, '1') = trnfn([1/3]*limit(orig, dest));
cost(orig, dest, '2') = trnfn([2/3]*limit(orig, dest));
cost(orig, dest, '3') = trnfn(limit(orig, dest));

parameter
intercept(orig,dest,bpp)
slope(orig,dest,bpp);

slope(orig,dest,i)$(ord(i) lt 3) = (cost(orig,dest,i)-cost(orig,dest,i-1))/(p(orig,dest,i)-p(orig,dest,i-1));

intercept(orig,dest,i)$(ord(i) lt 3) = cost(orig,dest,i-1) - slope(orig,dest,i)*p(orig,dest,i-1);

slope(orig,dest,'3') = (trnfn([11/12]*limit(orig,dest)) - cost(orig,dest,'2'))/([11/12]*limit(orig, dest) - p(orig,dest,'2'));

intercept(orig,dest,'3') = cost(orig,dest,'2') - slope(orig,dest,'3')*p(orig,dest,'2');;

positive variable trans(orig,dest) ’units to ship’;
variables total_cost, total_cost1;
equations
objective
objective1
obj(orig,dest)
supplycons(orig)
demandcons(dest)
supplycons1(orig)
demandcons1(dest)
buy(orig,dest)
w_lo(orig,dest,i)
w_up(orig,dest,i)
onecons(orig,dest);

objective..
total_cost =e= sum((orig,dest), rate(orig,dest)*y(orig,dest));
    
objective1..
total_cost1 =e= sum((orig,dest), rate(orig,dest)*trnfn(trans(orig,dest)) );

obj(orig,dest)..
y(orig,dest) =e= sum(i$bps(i), intercept(orig,dest,i)*sup(orig,dest,i) + slope(orig,dest,i) * w(orig,dest,i));
  
supplycons(orig)..
sum(dest, x(orig,dest)) =e= supply(orig);

demandcons(dest)..
sum(orig, x(orig,dest)) =e= demand(dest);

supplycons1(orig)..
sum(dest, trans(orig,dest)) =e= supply(orig);

demandcons1(dest)..
sum(orig, trans(orig,dest)) =e= demand(dest);

buy(orig,dest)..
sum(i$bps(i), w(orig,dest,i)) =e= x(orig,dest);

w_lo(orig,dest,i)$bps(i)..
p(orig,dest,i-1) * sup(orig,dest,i) =l= w(orig,dest,i);

w_up(orig,dest,i)$bps(i)..
w(orig,dest,i) =l= p(orig,dest,i) * sup(orig,dest,i);

onecons(orig,dest)..
sum(i$bps(i), sup(orig,dest,i)) =e= 1;

model nltranstest /objective1, supplycons1, demandcons1/;
trans.l(orig,dest) = limit(orig,dest)/2;
trans.lo(orig,dest) = 1e-10;
trans.up(orig,dest) = 0.99*limit(orig,dest);
solve nltranstest using nlp minimizing total_cost1;

model nltrans /objective,obj, supplycons, demandcons,buy, w_lo, w_up, onecons/;
x.l(orig,dest) = limit(orig,dest)/2;
x.lo(orig,dest) = 1e-10;
x.up(orig,dest) = 0.99*limit(orig,dest);
solve nltrans using mip minimizing total_cost;

parameter fracdiff(orig,dest);
fracdiff(orig,dest) = 100*abs(trans.l(orig,dest)- x.l(orig,dest))/max(1, trans.l(orig,dest))
display total_cost.l, fracdiff;

