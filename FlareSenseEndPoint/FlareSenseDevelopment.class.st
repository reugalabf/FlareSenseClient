"
Basic representation of a Flaresense row
"
Class {
	#name : #FlareSenseDevelopment,
	#superclass : #Object,
	#instVars : [
		'hum',
		'humidity_ws',
		'nodeId',
		'pressure_ws',
		'rain',
		'tem',
		'temperature_ws',
		'timeDeltaM',
		'when',
		'wind_direction_ws',
		'wind_ws_gust',
		'wind_wspeed_s'
	],
	#category : #'FlareSenseEndPoint-Entities'
}

{ #category : #accessing }
FlareSenseDevelopment class >> neoJsonMapping: mapper [

	mapper for: self do: [ :mapping | 
		mapping mapInstVars:
			#( nodeId timeDeltaM hum humidity_ws pressure_ws rain tem temperature_ws
			   wind_direction_ws wind_ws_gust wind_wspeed_s ).

		(mapping mapInstVar: #when) valueSchema: DateAndTime ].


	mapper for: DateAndTime customDo: [ :mapping | 
		mapping decoder: [ :string | DateAndTime fromString: string ].
		mapping encoder: [ :dateAndTime | dateAndTime printString ] ]
]

{ #category : #accessing }
FlareSenseDevelopment >> hum [

	^ hum
]

{ #category : #accessing }
FlareSenseDevelopment >> hum: anObject [

	hum := anObject
]

{ #category : #accessing }
FlareSenseDevelopment >> humidity_ws [

	^ humidity_ws
]

{ #category : #accessing }
FlareSenseDevelopment >> humidity_ws: anObject [

	humidity_ws := anObject
]

{ #category : #accessing }
FlareSenseDevelopment >> nodeId [

	^ nodeId
]

{ #category : #accessing }
FlareSenseDevelopment >> nodeId: anObject [

	nodeId := anObject
]

{ #category : #accessing }
FlareSenseDevelopment >> pressure_ws [

	^ pressure_ws
]

{ #category : #accessing }
FlareSenseDevelopment >> pressure_ws: anObject [

	pressure_ws := anObject
]

{ #category : #accessing }
FlareSenseDevelopment >> rain [

	^ rain
]

{ #category : #accessing }
FlareSenseDevelopment >> rain: anObject [

	rain := anObject
]

{ #category : #accessing }
FlareSenseDevelopment >> tem [

	^ tem
]

{ #category : #accessing }
FlareSenseDevelopment >> tem: anObject [

	tem := anObject
]

{ #category : #accessing }
FlareSenseDevelopment >> temperature_ws [

	^ temperature_ws
]

{ #category : #accessing }
FlareSenseDevelopment >> temperature_ws: anObject [

	temperature_ws := anObject
]

{ #category : #accessing }
FlareSenseDevelopment >> timeDeltaM [

	^ timeDeltaM
]

{ #category : #accessing }
FlareSenseDevelopment >> timeDeltaM: anObject [

	timeDeltaM := anObject
]

{ #category : #accessing }
FlareSenseDevelopment >> when [

	^ when
]

{ #category : #accessing }
FlareSenseDevelopment >> when: anObject [

	when := anObject
]

{ #category : #accessing }
FlareSenseDevelopment >> wind_direction_ws [

	^ wind_direction_ws
]

{ #category : #accessing }
FlareSenseDevelopment >> wind_direction_ws: anObject [

	wind_direction_ws := anObject
]

{ #category : #accessing }
FlareSenseDevelopment >> wind_ws_gust [

	^ wind_ws_gust
]

{ #category : #accessing }
FlareSenseDevelopment >> wind_ws_gust: anObject [

	wind_ws_gust := anObject
]

{ #category : #accessing }
FlareSenseDevelopment >> wind_wspeed_s [

	^ wind_wspeed_s
]

{ #category : #accessing }
FlareSenseDevelopment >> wind_wspeed_s: anObject [

	wind_wspeed_s := anObject
]
