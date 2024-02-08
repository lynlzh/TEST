sets 
    Destinations / SFO, IAH, DCA, MCO /
    Hubs / ORD, DTW, MSP /
    HubsWithoutORD(Hubs) / DTW, MSP /; 

parameters 
    timeMSNtoHub(Hubs) / ORD 22, DTW 65, MSP 46 /
    timeHubtoDest(Hubs, Destinations) /ORD.SFO 247, ORD.IAH 124, ORD.DCA 82, ORD.MCO 135,
                                       DTW.SFO 280, DTW.IAH 147, DTW.DCA 53, DTW.MCO 130,
                                       MSP.SFO 213, MSP.IAH 139, MSP.DCA 125, MSP.MCO 176 /
*expected value of uniform distributed delay time
    delay(Hubs) / ORD 90, DTW 45, MSP 60 /
*worst scenario delay time
    worst(Hubs) /ORD 180, DTW 90, MSP 120/;

variables
*minimum total flight time flying with United
    TotalTimeUnited
*minimum total time flying with Delta(for 3.1)
    TotalTimeDelta1
*minimum total time flying with Delta and using the same hub everytime(for 3.2)
    TotalTimeDelta2
*minimum total flight time not considering flyer miles and hubs (for 3.3)
    TotalTravelTime;


binary variables
*HubChosenDeltaDTW and HubChosenDeltaMSP are binary variable, if selected, it is assigned a value of 1 and 0 otherwise.
    HubChosenDeltaDTW
    HubChosenDeltaMSP
    RouteChosen(Hubs, Destinations);

equation 
    ObjectiveUnited
    ObjectiveDelta1
    ObjectiveDelta2
    OnlyOneHubChosen
    ObjectiveTotal
    OnlyOneRouteForEachDestination(Destinations);
    
ObjectiveUnited.. 
    TotalTimeUnited =e= sum(Destinations, 3 * (timeMSNtoHub('ORD') + timeHubtoDest('ORD', Destinations) + delay('ORD')));

ObjectiveDelta1..
    TotalTimeDelta1 =e= sum(Destinations, 3 * smin(HubsWithoutORD, timeMSNtoHub(HubsWithoutORD) + timeHubtoDest(HubsWithoutORD, Destinations) + delay(HubsWithoutORD)));

ObjectiveDelta2..
    TotalTimeDelta2 =e= sum(Destinations, 3 * (
        HubChosenDeltaDTW * (timeMSNtoHub('DTW') + timeHubtoDest('DTW', Destinations) + delay('DTW')) 
      + HubChosenDeltaMSP * (timeMSNtoHub('MSP') + timeHubtoDest('MSP', Destinations) + delay('MSP'))
    ));
    
OnlyOneHubChosen..
    HubChosenDeltaDTW + HubChosenDeltaMSP =e= 1;
    
ObjectiveTotal..
    TotalTravelTime =e= sum(Destinations, sum(Hubs, RouteChosen(Hubs, Destinations) * (timeMSNtoHub(Hubs) + timeHubtoDest(Hubs, Destinations) + delay(Hubs))));

OnlyOneRouteForEachDestination(Destinations)..
    sum(Hubs, RouteChosen(Hubs, Destinations)) =e= 1;
    
*(3.1)    
model AirlineChoiceUnited / ObjectiveUnited /;
model AirlineChoiceDelta1 / ObjectiveDelta1 /;

solve AirlineChoiceUnited using lp minimizing TotalTimeUnited;

display TotalTimeUnited.l;

solve AirlineChoiceDelta1 using lp minimizing TotalTimeDelta1;

display TotalTimeDelta1.l;

*TotalTimeDelta1.l=2901 < TotalTimeUnited.l=3108,so Prof. Wright should switch to Delta.


*(3.2)
model AirlineChoiceDelta2 / ObjectiveDelta2, OnlyOneHubChosen /;

solve AirlineChoiceDelta2 using MIP minimizing TotalTimeDelta2;

display TotalTimeUnited.l;

display TotalTimeDelta2.l;

display HubChosenDeltaDTW.l

*Conlusion: TotalTimeDelta2.l=3150 > TotalTimeUnited.l=3108. Prof.Wright should not switch to delta

*(3.3)
model BestRouteForEachDestination / ObjectiveTotal, OnlyOneRouteForEachDestination /;

solve BestRouteForEachDestination using miP minimizing TotalTravelTime;

display TotalTravelTime.l, RouteChosen.l;

*Conlusion: The minimum time cost is 958 when flyer miles is not considered.

$ontext
The above progra is designed base on using expected value of uniform distributed delay time
The following program is based on the worst scenario (longest delay time for each hub)
$offtext

variables
*minimum total flight time flying with United
    w_TotalTimeUnited
*minimum total time flying with Delta(for 3.1)
    w_TotalTimeDelta1
*minimum total time flying with Delta and using the same hub everytime(for 3.2)
    w_TotalTimeDelta2
*minimum total flight time not considering flyer miles and hubs (for 3.3)
    w_TotalTravelTime;


equation 
    w_ObjectiveUnited
    w_ObjectiveDelta1
    w_ObjectiveDelta2
    w_OnlyOneHubChosen
    w_ObjectiveTotal
    w_OnlyOneRouteForEachDestination(Destinations);
    
w_ObjectiveUnited.. 
    w_TotalTimeUnited =e= sum(Destinations, 3 * (timeMSNtoHub('ORD') + timeHubtoDest('ORD', Destinations) + worst('ORD')));

w_ObjectiveDelta1..
    w_TotalTimeDelta1 =e= sum(Destinations, 3 * smin(HubsWithoutORD, timeMSNtoHub(HubsWithoutORD) + timeHubtoDest(HubsWithoutORD, Destinations) + worst(HubsWithoutORD)));

w_ObjectiveDelta2..
    w_TotalTimeDelta2 =e= sum(Destinations, 3 * (
        HubChosenDeltaDTW * (timeMSNtoHub('DTW') + timeHubtoDest('DTW', Destinations) + worst('DTW')) 
      + HubChosenDeltaMSP * (timeMSNtoHub('MSP') + timeHubtoDest('MSP', Destinations) + worst('MSP'))
    ));
    
w_OnlyOneHubChosen..
    HubChosenDeltaDTW + HubChosenDeltaMSP =e= 1;
    
w_ObjectiveTotal..
    w_TotalTravelTime =e= sum(Destinations, sum(Hubs, RouteChosen(Hubs, Destinations) * (timeMSNtoHub(Hubs) + timeHubtoDest(Hubs, Destinations) + worst(Hubs))));

w_OnlyOneRouteForEachDestination(Destinations)..
    sum(Hubs, RouteChosen(Hubs, Destinations)) =e= 1;

*(3.1)    
model w_AirlineChoiceUnited / w_ObjectiveUnited /;
model w_AirlineChoiceDelta1 / w_ObjectiveDelta1 /;

solve w_AirlineChoiceUnited using lp minimizing w_TotalTimeUnited;

display w_TotalTimeUnited.l;

solve w_AirlineChoiceDelta1 using lp minimizing w_TotalTimeDelta1;

display w_TotalTimeDelta1.l;

*TotalTimeDelta1.l=3522 < TotalTimeUnited.l=4188,so Prof. Wright should switch to Delta.

*(3.2)
model w_AirlineChoiceDelta2 / w_ObjectiveDelta2, w_OnlyOneHubChosen /;

solve w_AirlineChoiceDelta2 using MIP minimizing w_TotalTimeDelta2;

display w_TotalTimeUnited.l;

display w_TotalTimeDelta2.l;

display  RouteChosen.l;
*Conlusion: TotalTimeDelta2.l=3690 < TotalTimeUnited.l=4188. Prof.Wright should fly delta from dtw

*(3.3)
model w_BestRouteForEachDestination / w_ObjectiveTotal, w_OnlyOneRouteForEachDestination /;

solve w_BestRouteForEachDestination using mip minimizing w_TotalTravelTime;

display w_TotalTravelTime.l, RouteChosen.l;

*Conlusion: The minimum time cost is 1174 when flyer miles is not considered.

