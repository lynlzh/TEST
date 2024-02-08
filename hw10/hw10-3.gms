parameters
   CostPerHour /52/
   CostTool /87/;

variables
   l
   N
   f
   k
   cost;

equations
   tool_l
   totalcost_c;

tool_l..
l =e= [10.0/(N*(f*0.6))]**[6.667];

totalcost_c..
cost =e= (52*42 / (60*(f * N)))+((5.2+87)*42 / (l*(f * N)));

model machinewear /all/;

N.l = 300;
N.up = 600;
N.lo = 200;

f.up = 0.005;
f.lo = 0.001;

f.l = 0.002;
l.l = 1;

solve machinewear using nlp minimizing cost;

display cost.L,N.L, f.L;