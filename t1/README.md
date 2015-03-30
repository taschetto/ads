## Queue Diagram

https://github.com/taschetto/ads/blob/master/t1/drawing.svg

## Queues info:

Queue | Type | Min arrival | Max arrival | Min service | Max service
---|--------|-----|-----|-----|-----
CAI|G/G/6/50|1 min|2 min|1 min|15 min
INF|G/G/1/10|4 min|7 min|5 min|12 min
TES|G/G/2/15|8 min|12 min|10 min|35 min
VAL|G/G/3/25|N/A|N/A|2 min|4 min
EMB|G/G/3/30|N/A|N/A|4 min|9 min
TRO|G/G/2/20|10 min|15 min|9 min|14 min

## Probabilities

Src | Dst | Probability
:-----:|:-----------:|-----------:
CAI|INF|0.1
CAI|TES|0.1
CAI|VAL|0.5
CAI|EMB|0.15
CAI|TRO|0.05
CAI|**out**|0.1
INF|CAI|0.55
INF|TES|0.2
INF|**out**|0.25
TES|CAI|0.6
TES|INF|0.1
TES|**out**|0.3
VAL|CAI|0.1
VAL|INF|0.05
VAL|TES|0.02
VAL|**out**|0.83
EMB|CAI|0.05
EMB|INF|0.05
EMB|TES|0.1
EMB|VAL|0.55
EMB|**out**|0.25
TRO|CAI|0.1
TRO|INF|0.1
TRO|TES|0.05
TRO|**out**|0.75
