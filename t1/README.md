## Queue Diagram

https://github.com/taschetto/ads/blob/master/t1/drawing.svg

## Queues info:

Queue | Type | Min arrival | Max arrival | Min service | Max service
---|--------|-----|-----|-----|-----
CAI|G/G/6/50|1 min|2 min|1 min|15 min
INF|G/G/1/10|1 min|2 min|5 min|12 min
TES|G/G/2/15|1 min|2 min|10 min|35 min
VAL|G/G/3/25|N/A|N/A|2 min|4 min
EMB|G/G/3/30|N/A|N/A|4 min|9 min
TRO|G/G/2/20|1 min|2 min|8 min|14 min

## Probabilities

Src | Dst | Probability
:-----:|:-----------:|-----------:
CAI|INF|.1
CAI|TES|.1
CAI|VAL|.5
CAI|EMB|.15
CAI|TRO|.05
CAI|**out**|.1
INF|CAI|.55
INF|TES|.2
INF|**out**|.25
TES|CAI|.6
TES|INF|.1
TES|**out**|.3
VAL|CAI|.1
VAL|INF|.05
VAL|TES|.02
VAL|**out**|.83
EMB|CAI|.05
EMB|INF|.05
EMB|TES|.1
EMB|VAL|.55
EMB|**out**|.25
TRO|CAI|.1
TRO|INF|.1
TRO|TES|.05
TRO|**out**|.75
