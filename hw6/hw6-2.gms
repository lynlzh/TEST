*2.1
sets
    nodes /A, B, C, D, E, F, G, H, I, J/
    doors /d1*d8/;
alias(nodes, n);

* Mapping of which doors cover which nodes
table cover1(n,doors)
       d1  d2  d3  d4  d5  d6  d7  d8
    A  1   0   1   1   0   0   0   1
    B  0   0   1   0   0   0   0   0
    C  0   0   0   1   0   0   0   0
    D  0   0   0   0   0   0   1   0
    E  0   0   0   0   0   1   1   0
    F  0   0   0   0   1   1   0   1
    G  0   1   0   0   1   0   0   0
    H  0   1   0   0   0   0   0   0
    I  1   0   0   0   0   0   0   0
    J  1   0   0   0   0   0   0   0;

binary Variable x1(doors);

variable totalGuards;

equations
    guardObjective,
    coverEachNode(n);

guardObjective..
totalGuards =e= sum(doors, x1(doors));

coverEachNode(n)..
sum(doors$cover1(n,doors), x1(doors)) =g= 1;

model museumGuardProblem /all/;

solve museumGuardProblem using MIP minimizing totalGuards;

option limcol=0;
display x1.l,totalGuards.l;

*2.2
set s "room set" /A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,W,X,Y,Z/;
set d "doors" /d1*d28/; 
alias (s,i);

set cover2(i,d) "room i is seen from door d"
/A.d1,A.d2,A.d3,
 B.d3,B.d6,
 C.d6,C.d10,C.d11,
 D.d10,
 E.d7,E.d11,E.d17,E.d19,
 F.d7,
 G.d19,G.d24,
 H.d24,
 I.d16,I.d17,I.d18,
 J.d18,
 K.d15,K.d16,K.d23,
 L.d23,L.d25,L.d26,
 M.d25,
 N.d26,
 O.d14,O.d15,
 P.d12,P.d13,P.d14,
 Q.d21,Q.d27,
 R.d27,R.d28,
 S.d20,S.d28,
 T.d13,T.d20,
 U.d12,U.d8,U.d9,
 W.d9,
 X.d4,X.d8,
 Y.d4,
 Z.d2,Z.d5/;

binary variables x2(d);
variable totalUsed;

equation
coverConstraint(i)
objective;

objective..
    totalUsed =e= sum(d, x2(d));

coverConstraint(i)..
    sum(d$cover2(i,d), x2(d)) =g= 1;

model setcover /all/;

setcover.optca = 0.999;

solve setcover using mip minimizing totalUsed;

display x2.l,totalUsed.l;

set stations(d, s) 'stations showing guards placed at doors';

loop((d)$(x2.l(d) > 0.5),
    loop((i, s)$(cover2(i, d) and ord(i) < ord(s) and cover2(s, d)),
        stations(d, i) = yes;
        stations(d, s) = yes;
    )
);

display stations;

