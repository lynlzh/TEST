*1.1
set t/t1*t3/
    p/salsa, ketchup, tomato-paste/
    r/tomatoes, sugar, labor, spices/
    sc/s1*s4/;

set s(sc);

table c(p,t)
               t1      t2      t3
salsa         2.5     2.75     3
ketchup       1.5     1.75     2.0
tomato-paste  1.0     1.1      1.2;

table a(p,r)
              tomatoes  sugar  labor  spices
salsa            0.5     1.0    1.0    3.0
ketchup          0.5     0.5    0.8    1.0
tomato-paste     1.0      0     0.5    0.25 ;

parameter alpha(p)
                /"tomato-paste" 0.5, "ketchup" 0.25, "salsa" 0.2/
          
          beta(p)
               /"tomato-Paste" 4.0, "ketchup" 6.0, "salsa" 12.0/
          
          b(R)
              /tomatoes 250, sugar 300, labor 200, spices 100/
          g(R)
              /tomatoes 0.5, sugar 1.0, labor 2.0, spices 1.0/
          rho(sc)
              /s1 0.15,s2 0.4,s3 0.15,s4 0.3/
         
          demand(P,T);

table d(p,t,sc)
                   s1         s2         s3        s4      
salsa.t1            5          5          5         5
ketchup.t1         30         30         30        30
tomato-paste.t1   100        100        100       100
salsa.t2            5          5         20        20
ketchup.t2         30         30         40        40
tomato-paste.t2   100        100        200       200
salsa.t3            5         20          5        20
ketchup.t3         30         40         30        40
tomato-paste.t3   100        200        100       200;

parameter results(*);
positive variable
               x(p,t)
               y(r,t,sc)
               sur(p,t,sc)
               un(p,t,sc)
               x_d(p,t)
               y_d(r,t)
               sur_d(p,t)
               un_d(p,t);
               
variable tc,tc_d,tc_vss;  

demand(P,T)= sum(sc, rho(sc)*d(P,T,sc));
*display demand;

equations 
          obj
          obj_d
          obj_vss
          res
          res_d
          res_vss
          dem
          dem_d
          dem_vss;
obj..
 tC =e= sum((P,T), (c(P, T) * x(P, T))) + sum((sc,p,t),rho(sc)* alpha(P) * sur(p,t,sc)) +
    sum((sc,p,t),beta(P)*un(p,t,sc)*rho(sc)) + sum((r,sc,t),y(r,t,sc)*g(r)*rho(sc));

obj_d..
 tc_d =e= sum((P,T), (c(P, T) * x_d(P, T)) +  (alpha(P) * sur_d(p,t)) +
   (beta(P)*un_d(p,t))) + sum((r,t),y_d(r,t)*g(r));

obj_vss..
 tC_vss =e= sum((P,T), (c(P, T) * x(P, T))) + sum((s,p,t),rho(s)* alpha(P) * sur(p,t,s)) +
    sum((s,p,t),beta(P)*un(p,t,s)*rho(s)) + sum((r,s,t),y(r,t,s)*g(r)*rho(s));
    
res(r,sc,T)..
 sum(p,x(p,t)*a(p,r))=l=b(r)+y(r,t,sc);
 
res_d(r,T)..
 sum(p,x_d(p,t)*a(p,r))=l=b(r)+y_d(r,t);

res_vss(r,s,T)..
 sum(p,x(p,t)*a(p,r))=l=b(r)+y(r,t,s);
 
dem(p,t,sc)..
 x(p,t)+un(p,t,sc)+sur(p,t-1,sc)=e=d(P,T,sc)+sur(p,t,sc);
 
dem_d(p,t)..
 x_d(p,t)+un_d(p,t)+sur_d(p,t-1)=e=demand(P,T)+sur_d(p,t);
 
dem_vss(p,t,s)..
 x(p,t)+un(p,t,s)+sur(p,t-1,s)=e=d(P,T,S)+sur(p,t,s);
 
model TTT /res_d,obj_d,dem_d/;

solve TTT using lp minimizing tc_d;

results('MeanValue')=tc_d.l;

model TTT_d /res,dem,obj/;
solve TTT_d using lp minimizing tc;
results('Stochastic')=tc.l;
model TTT_vss /res_vss,dem_vss,obj_vss/;

*1.2
s(sc) = yes;
scalar vss;
x.fx(p,t) = x_d.l(p,t);
solve TTT_vss using lp minimizing tc_vss;
display tc_vss.l;
vss = -tc_vss.l;

x.lo(p,t) = 0;
x.up(p,t) = inf;
solve TTT_vss using lp minimizing tc_vss;
vss = - tc_vss.l-vss;

*1.3
scalar evpi;
evpi = tc.l;
display evpi;

parameter objval(sc),pi(sc);
s(sc) = no;
loop(sc,
  s(sc) = yes;
  pi(sc)=rho(sc);
  rho(sc) = 1;
  solve TTT_vss using lp minimizing tc_vss;
  objval(sc)=tc_vss.l;
  s(sc) = no; rho(sc) = 0;
);
evpi=evpi-sum(sc,pi(sc)*objval(sc));
display vss,evpi,results;