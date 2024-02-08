option limrow=100, limcol=0;
sets 
    P "Places" / 'Hogwarts', 'Godric’s Hollow', 'Little Whinging', 'Shell Cottage', 'The Leaky Cauldron', 'Ollivander’s', 'Zonko’s Joke Shop', 'Dervish and Banges', 'Little Hangleton', 'Weasley’s Wizard Wheezes'/;

alias(P, Q);  

parameters 
    x(P) / 'Hogwarts' 0, 'Godric’s Hollow' 20, 'Little Whinging' 18, 'Shell Cottage' 30, 'The Leaky Cauldron' 35, 'Ollivander’s' 33, 'Zonko’s Joke Shop' 5, 'Dervish and Banges' 5, 'Little Hangleton' 11, 'Weasley’s Wizard Wheezes' 2/
    y(P) / 'Hogwarts' 0, 'Godric’s Hollow' 20, 'Little Whinging' 10,'Shell Cottage' 12, 'The Leaky Cauldron' 0, 'Ollivander’s' 25, 'Zonko’s Joke Shop' 27, 'Dervish and Banges' 10, 'Little Hangleton' 0, 'Weasley’s Wizard Wheezes' 15/
    requiredBrooms(P) / 'Hogwarts' 10, 'Godric’s Hollow' 6, 'Little Whinging' 8, 'Shell Cottage'11, 'The Leaky Cauldron' 9, 'Ollivander’s' 7, 'Zonko’s Joke Shop' 15, 'Dervish and Banges' 7, 'Little Hangleton' 9, 'Weasley’s Wizard Wheezes' 12/
    currentBrooms(P) / 'Hogwarts' 8, 'Godric’s Hollow' 13,'Little Whinging' 4, 'Shell Cottage' 8, 'The Leaky Cauldron' 12, 'Ollivander’s' 2, 'Zonko’s Joke Shop' 14, 'Dervish and Banges' 11, 'Little Hangleton' 15, 'Weasley’s Wizard Wheezes' 7/;

variables 
    flow(P, Q) "Flow of brooms from p to q"
    cost "Total cost of transportation";

positive variable flow;

parameters 
    dist(P,Q) "Euclidean distance between places"
    isNotFromClosest(P) "Binary parameter to indicate if a place does not receive brooms from its closest location";

* Calculate distances between all pairs
dist(P,Q)$(not sameas(P,Q)) = sqrt(sqr(x(P) - x(Q)) + sqr(y(P) - y(Q)));

* Identify the closest place for each P
parameter closestDist(P);
closestDist(P) = smin(Q$(not sameas(P,Q)), dist(P,Q));

* Identify if Q is the closest place for P
parameter isClosest(P,Q) "Binary parameter to indicate if Q is the closest place to P";
isClosest(P,Q)$(not sameas(P,Q) and dist(P,Q) = closestDist(P)) = 1;


equations 
    obj "Objective function"
    conservation(P) "Conservation of flow for each node";

obj.. cost =e= sum((P,Q), 0.5 * sqrt(sqr(x(P) - x(Q)) + sqr(y(P) - y(Q))) * flow(P,Q));

conservation(P).. sum(Q, flow(Q,P)) - sum(Q, flow(P,Q)) =e= requiredBrooms(P) - currentBrooms(P);

model Transport / obj, conservation /;

Transport.optfile=1;

$onecho>cplex.opt
lpmethod 3
netfind 2
preind 0
$offEcho

solve Transport using mip minimizing cost;

loop(P,
    if(sum(Q$(isClosest(P,Q)), flow.l(Q,P)) = 0 and requiredBrooms(P) > currentBrooms(P), 
        isNotFromClosest(P) = 1;
    else 
        isNotFromClosest(P) = 0;
    );
);
set not_from_closest(P) ;

not_from_closest(P) = yes$(isNotFromClosest(P) = 1);

option not_from_closest:0:0:1;

display not_from_closest;
