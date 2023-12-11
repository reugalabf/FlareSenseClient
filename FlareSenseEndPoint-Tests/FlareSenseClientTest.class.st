Class {
	#name : #FlareSenseClientTest,
	#superclass : #TestCase,
	#category : #'FlareSenseEndPoint-Tests'
}

{ #category : #tests }
FlareSenseClientTest >> testHourlyMultiMappings [

	| col agregator |
	col := (NeoJSONReader on: self twoEntriesJson readStream) 
		       nextListAs: FlareSenseDevelopment.

	agregator := FlareSenseAggregator new.
	agregator
		hourly;
		addAverageMappingFor: #hum;
		addSumMappingFor: #tem;
		addMaxMappingFor: #wind_ws_gust;
		addMinMappingFor: #temperature_ws.
	agregator aggregate: col.
	agregator inspect.
	self should: [ col size = 2 ].
	self should: [ 
		col first when printString = '2023-11-28T13:03:38.897+00:00' ]
]

{ #category : #tests }
FlareSenseClientTest >> testRawFlareSense [

	| rsp col |
	rsp := FlareSenseRawClient new transformJSON:
		       self twoEntriesJson readStream.
	rsp inspect.

	col := (NeoJSONReader on: rsp readStream) "nextListAs:
		       FlareSenseDevelopment" next.
	col inspect
	"	self should: [ col size = 2 ].
	self should: [ 
		col first when printString = '2023-11-28T13:03:38.897+00:00' ]"
]

{ #category : #tests }
FlareSenseClientTest >> testReadingFromJSON [

	| col |
	col := (NeoJSONReader on: self twoEntriesJson readStream) 
		       nextListAs: FlareSenseDevelopment.

	self should: [ col size = 2 ].
	self should: [ 
		col first when printString = '2023-11-28T13:03:38.897+00:00' ]
]

{ #category : #private }
FlareSenseClientTest >> twoEntriesJson [
^ '[{
"fw": "Miramar-sep2022",
"hum": [
73.3
],
"humidity_ws": [
69.4
],
"nodeId": "3c610528e00c",
"pressure_ws": [
1012
],
"raing": [
0
],
"tem": [
25.3
],
"temperature_ws": [
25.3
],
"timeDeltaM": 30,
"when": "2023-11-28T13:03:38.897Z",
"wind_direction_ws": [
0.6
],
"wind_ws_gust": [
36
],
"wind_wspeed_s": [
17.8
]
},
{
"fw": "Miramar-sep2022",
"hum": [
66.7,
71.6
],
"humidity_ws": [
65.5,
66.3
],
"nodeId": "3c610528e00c",
"pressure_ws": [
1011.9,
1011.7
],
"raing": [
0,
0
],
"tem": [
28.1,
26.1
],
"temperature_ws": [
26.8,
26.5
],
"timeDeltaM": 30,
"when": "2023-11-28T13:38:45.393Z",
"wind_direction_ws": [
0,
1.2
],
"wind_ws_gust": [
11.6,
28.8
],
"wind_wspeed_s": [
4.4,
14.4
]
}
]'
]
