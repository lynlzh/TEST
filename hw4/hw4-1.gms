set type, i;
parameter data(type<,i<);
$gdxin wine.gdx
$load data
$gdxin
set t /1*60/;

parameter a(i), b(i), c(i),pleasure(i,t);

a(i) = data('a', i);
b(i) = data('b', i);
c(i) = data('c', i);

*Calculate pleasure of drink ith wine on t th week
loop((i,t),
    pleasure(i,t) = b(i)*(a(i) + ord(t)-1)**3 - c(i)*(a(i) + ord(t)-1));

binary variable x(i,t);
free variable totalPleasure;

equation
objective 'Objective to maximize total pleasure',
consumeOnce(i) 'Each bottle is consumed exactly once',
consumeEachWeek(t) 'One bottle is consumed each week';

objective..
totalPleasure =e= sum((i,t), pleasure(i,t)*x(i,t));

consumeOnce(i)..
sum(t, x(i,t)) =e= 1;

consumeEachWeek(t)..
sum(i, x(i,t)) =e= 1;
model assign /all/;

solve assign using mip maximizing totalPleasure;

option x:2:0:1;

display x.l;

    