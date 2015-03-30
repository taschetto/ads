## Queue Diagram

https://github.com/taschetto/ads/blob/master/t1/drawing.svg

## Queues info:

Queue | Type | Min arrival | Max arrival | Min service | Max service
---|-------|-----|-----|-----|-----
CAI|G/G/C/K|1 min|2 min|3 min|4 min
INF|G/G/C/K|1 min|2 min|3 min|4 min
TES|G/G/C/K|1 min|2 min|3 min|4 min
VAL|G/G/C/K|1 min|2 min|3 min|4 min
EMB|G/G/C/K|1 min|2 min|3 min|4 min
TRO|G/G/C/K|1 min|2 min|3 min|4 min

## Probablities

Source | Destination | Probability
-------|-------------|--------------
CAI|INF|.5
CAI|TES|.5
CAI|VAL|.5
CAI|EMB|.5
CAI|TRO|.5
CAI|out|.5
INF|CAI|.5
INF|TES|.5
INF|out|.5
TES|CAI|.5
TES|INF|.5
TES|out|.5
VAL|CAI|.5
VAL|INF|.5
VAL|TES|.5
EMB|CAI|.5
EMB|INF|.5
EMB|TES|.5
EMB|VAL|.5
TRO|CAI|.5
TRO|INF|.5
TRO|TES|.5
TRO|out|.5
