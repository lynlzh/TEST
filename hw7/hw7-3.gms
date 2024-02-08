set i /1*10/;
alias(i,j);
table clean(i,j)
    1   2    3   4    5   6    7   8   9    10
1   0   11   7   13  11   12   4   9   7    11
2   5    0   13  15  15    6   8   10  9     8
3  13   15   0   23  11   11   16  18  5     7
4  9    13   5   0   3     8   10  12  14    5
5  3     7   7   7   0     9   10  11  12   13
6  10    6   3   4   14    0    8   5  11   12
7  4     6   7   3   13    7    0  10  4     6
8  7     8   9   9   12   11   10   0  10    9
9  9    14   8   4    9    6   10   8   0   12
10 11   17  11   6   10    4    7   9  11    0;

parameter dur(i) / 1 40, 2 35, 3 45, 4 32, 5 50, 6 42, 7 44, 8 30, 9 33, 10 55 /; 

free variable
obj;

positive variable
m(i);

binary variables
x(i,j);


equations
objective,
batchCons(i,j),
assignCon1,
assignCon2;

assignCon1(j)..
sum(i$(not sameas(i,j)), x(i,j)) =e= 1;

assignCon2(i)..
sum(j$(not sameas(i,j)), x(i,j)) =e= 1;

batchCons(i,j)$(ord(i) ne 1 and ord(j) ne 1)..
(card(i) - 1) * (1 - x(i,j)) =g= m(i) - m(j) +1;

objective..
obj =e= sum((i,j),(clean(i,j) + dur(i))*x(i,j));


model mtz /all/;

m.up(i) = card(i);
m.lo(i) = 2;

m.fx(i)$(i.ord eq 1) = 1;

solve mtz using mip minimizing obj;
display obj.l,m.l,x.l;

parameter batchlength;
batchlength = obj.L;
parameter order(i) ;
loop(j,
     order(i)$(abs(m.L(j) - ord(i)) < 0.5) = ord(j);
);
display batchlength;
display order;
