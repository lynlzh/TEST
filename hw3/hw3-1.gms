option limrow = 0,limcol = 0, solprint = off;

sets
    month /Jan, Feb, Mar, Apr/ 
    period /one, two, three, four/;

alias (month, m);
alias (month, start_m);
alias (period, p);

scalars
    initialcash /400/;

parameters
    revenues(month) /Jan 600, Feb 800, Mar 250, Apr 300/,
    bills(month) /Jan 700, Feb 500, Mar 600, Apr 250/,
    interestrate(period) /one 0.0025, two 0.0035, three 0.004, four 0.006/;

positive variables
    investments(month, period),
    cash_balance(month);

free variables
    finalCash;
equations
    initialCashBalanceEq,
    cashBalanceEq,
    cashmay,
    investmentConstraint;
    
initialCashBalanceEq..
    cash_balance('Jan') =e= initialcash;
    
cashBalanceEq(m)$(ord(m) > 1 )..
    cash_balance(m) =e= cash_balance(m-1)
                     + revenues(m-1) - bills(m-1)
                     - sum(p, investments(m-1,p))
                     + sum((start_m,p)$(ord(start_m) + ord(p) = ord(m)-1), investments(start_m,p)*(1 + interestrate(p)));

investmentConstraint(m)$(ord(m) < card(month))..
    sum(p, investments(m,p)) =l= cash_balance(m)+revenues(m)-bills(m)
 +sum((start_m,p)$(ord(start_m) + ord(p) = ord(m)), investments(start_m,p)*(1 + interestrate(p)));
 
cashmay..
    finalCash=e= cash_balance('Apr')+revenues('Apr')-bills('Apr')- sum(p, investments('Apr',p))
                     + sum((start_m,p)$(ord(start_m) + ord(p) = 4), investments(start_m,p)*(1 + interestrate(p)));
                     
model finco /all/;
solve finco maximizing finalCash using lp;

display finalCash.l;


