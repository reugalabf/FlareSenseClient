Class {
	#name : #FlareSenseRawClient,
	#superclass : #Object,
	#instVars : [
		'endPoint',
		'entity',
		'tailParam'
	],
	#category : #'FlareSenseEndPoint-Clients'
}

{ #category : #accessing }
FlareSenseRawClient class >> endPoint: urlString [

	^ self new
		  initialize: urlString;
		  yourself
]

{ #category : #API }
FlareSenseRawClient >> aggregateWith: aggregator [

	"returns a dictionary produced by the aggregator"

	| rsp |
	rsp := ZnEasy get: self buildCallURL.
	rsp isError ifTrue: [ 
		^ self error: 'Error fetching from endPoint ' , endPoint ].
	^ aggregator aggregate: (self transformJSON: rsp entity readStream)
]

{ #category : #actions }
FlareSenseRawClient >> buildCallURL [

	| result |
	endPoint ifNil: [ self error: 'No EndPoint' ].
	result := endPoint.
	(tailParam notNil and: [ tailParam > 0 ]) ifTrue: [ 
		result last = $/ ifFalse: [ result := result , '/' ].
		result := result , tailParam asString ].
	^ result
]

{ #category : #actions }
FlareSenseRawClient >> fetch [

	^ self fetchAs: entity
]

{ #category : #API }
FlareSenseRawClient >> fetchAs: aClass [

	| rsp |
	rsp := ZnEasy get: self buildCallURL.
	rsp isError ifTrue: [ 
		^ self error: 'Error fetching from endPoint ' , endPoint ].
	^ entity
		  ifNil: [ (NeoJSONReader on: rsp entity readStream) next ]
		  ifNotNil: [ 
			  (NeoJSONReader on: (self transformJSON: rsp entity readStream)) 
				  nextListAs: aClass ]
]

{ #category : #initialization }
FlareSenseRawClient >> initialize: urlString [

	endPoint := urlString
]

{ #category : #API }
FlareSenseRawClient >> splitEntry: dict on: rspCol [

	| count holder |
	holder := OrderedCollection new.
	count := dict inject: 1 into: [ :size :each | 
		         size max: (each isArray
				          ifTrue: [ each size ]
				          ifFalse: [ 1 ]) ].
	count timesRepeat: [ holder addLast: Dictionary new ].
	dict keysAndValuesDo: [ :key :value | 
		value isArray
			ifFalse: [ 
			1 to: count do: [ :idx | (holder at: idx) at: key put: value ] ]
			ifTrue: [ 
				1 to: value size do: [ :idx | 
				(holder at: idx) at: key put: (value at: idx) ] ] ].

	2 to: holder size do: [ :idx | 
		| date entry |
		date := (DateAndTime fromString:
			         ((entry := holder at: idx) at: #when))
		        + (Duration minutes: (entry at: #timeDeltaM) * (idx - 1)).
		entry at: #when put: date printString ].
	rspCol addAllLast: holder
]

{ #category : #API }
FlareSenseRawClient >> transformJSON: readStream [

	| inputCol ws rspCol |
	rspCol := OrderedCollection new.
	ws := WriteStream on: String new.
	inputCol := (NeoJSONReader on: readStream) next.
	inputCol do: [ :dict | self splitEntry: dict on: rspCol ].
	ws nextPutAll: (NeoJSONWriter toString: rspCol).
	^ ws contents
]
