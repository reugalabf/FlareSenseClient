Class {
	#name : #FlareSenseClientTest,
	#superclass : #TestCase,
	#category : #'FlareSenseEndPoint-Tests'
}

{ #category : #private }
FlareSenseClientTest >> oneRawMultiEntriesJson [
^ '[
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

{ #category : #private }
FlareSenseClientTest >> oneRawSingleEntriesJson [
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
}
]'
]

{ #category : #tests }
FlareSenseClientTest >> testHourlyMultiMappings [

	| col agregator rsp |
	rsp := FlareSenseRawClient new transformJSON:
		       self twoRawEntriesJson readStream.

	col := (NeoJSONReader on: rsp readStream) nextListAs:
		       FlareSenseDevelopment.


	agregator := FlareSenseAggregator new.
	agregator
		hourly;
		addAverageMappingFor: #hum;
		addSumMappingFor: #tem;
		addMaxMappingFor: #wind_ws_gust;
		addMinMappingFor: #temperature_ws.
	(agregator aggregate: col) inspect.
	
	self should: [ col size = 3 ].
	self should: [ 
		col first when printString = '2023-11-28T13:03:38.897+00:00' ]
]

{ #category : #tests }
FlareSenseClientTest >> testHourlyMultiMappingsToCSV [

	| col agregator rsp csv array |
	rsp := FlareSenseRawClient new transformJSON:
		       self twoRawEntriesJson readStream.

	col := (NeoJSONReader on: rsp readStream) nextListAs:
		       FlareSenseDevelopment.


	agregator := FlareSenseAggregator new.
	agregator
		hourly;
		addAverageMappingFor: #hum;
		addSumMappingFor: #tem;
		addMaxMappingFor: #wind_ws_gust;
		addMinMappingFor: #temperature_ws.


	self should: [ col size = 3 ].
	self should: [ 
		col first when printString = '2023-11-28T13:03:38.897+00:00' ].

	csv := agregator aggregateCSV: col.
	array := (NeoCSVReader on: csv readStream) upToEnd.

	self should: [ array size = 3 ].
	self should: [ array first first = 'key' ].
	self should: [ ((array at: 2) at: 2) = '70.0' ]
]

{ #category : #tests }
FlareSenseClientTest >> testHourlyMultiMappingsToJSON [

	| col agregator rsp csv array json dicts |
	rsp := FlareSenseRawClient new transformJSON:
		       self twoRawEntriesJson readStream.

	col := (NeoJSONReader on: rsp readStream) nextListAs:
		       FlareSenseDevelopment.


	agregator := FlareSenseAggregator new.
	agregator
		hourly;
		addAverageMappingFor: #hum;
		addSumMappingFor: #tem;
		addMaxMappingFor: #wind_ws_gust;
		addMinMappingFor: #temperature_ws.


	self should: [ col size = 3 ].
	self should: [ 
		col first when printString = '2023-11-28T13:03:38.897+00:00' ].


	json := NeoJSONWriter toStringPretty: col.
	dicts := NeoJSONReader fromString: json.
	self should: [ dicts size = 3 ].
	self should: [ 
		(dicts first at: 'when') = '2023-11-28T13:03:38.897+00:00' ]
]

{ #category : #tests }
FlareSenseClientTest >> testOneRawMultiEntryFlareSense [

	| rsp col |
	rsp := FlareSenseRawClient new transformJSON:
		       self oneRawMultiEntriesJson readStream.


	col := (NeoJSONReader on: rsp readStream) next. "nextListAs:
		       FlareSenseDevelopment"

	self should: [ col size = 2 ].
	self should: [ (col first at: #when) = '2023-11-28T13:38:45.393Z' ].
	self should: [ 
		(col last at: #when) = '2023-11-28T14:08:45.393+00:00' ]
]

{ #category : #tests }
FlareSenseClientTest >> testOneRawMultiEntryFlareSenseObject [

	| rsp col |
	rsp := FlareSenseRawClient new transformJSON:
		       self oneRawMultiEntriesJson readStream.


	col := (NeoJSONReader on: rsp readStream) nextListAs:
		       FlareSenseDevelopment.

	self should: [ col size = 2 ].
	self should: [ 
		col first when printString = '2023-11-28T13:38:45.393+00:00' ].
	self should: [ 
		col last when printString = '2023-11-28T14:08:45.393+00:00' ]
]

{ #category : #tests }
FlareSenseClientTest >> testOneRawSimpleEntryFlareSenseObject [

	| rsp col |
	rsp := FlareSenseRawClient new transformJSON:
		       self oneRawSingleEntriesJson readStream.


	col := (NeoJSONReader on: rsp readStream) nextListAs:
		       FlareSenseDevelopment.

	self should: [ col size = 1 ].
	self should: [ 
		col first when printString = '2023-11-28T13:03:38.897+00:00' ]
]

{ #category : #tests }
FlareSenseClientTest >> testTwoRawMultiEntryFlareSenseObject [

	| rsp col |
	rsp := FlareSenseRawClient new transformJSON:
		       self twoRawEntriesJson readStream.


	col := (NeoJSONReader on: rsp readStream) nextListAs:
		       FlareSenseDevelopment.

	self should: [ col size = 3 ].
	self should: [ 
		col first when printString = '2023-11-28T13:03:38.897+00:00' ].
	self should: [ 
		col last when printString = '2023-11-28T14:08:45.393+00:00' ]
]

{ #category : #private }
FlareSenseClientTest >> twoRawEntriesJson [
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

{ #category : #private }
FlareSenseClientTest >> twoRawSingleEntriesJson [
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
}
]'
]
