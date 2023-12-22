Class {
	#name : #FlareSenseRawSource,
	#superclass : #Object,
	#instVars : [
		'entity'
	],
	#category : #'FlareSenseEndPoint-Clients'
}

{ #category : #actions }
FlareSenseRawSource >> fetch [

	^ self fetchAs: entity
]

{ #category : #API }
FlareSenseRawSource >> splitEntry: dict on: rspCol [

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
FlareSenseRawSource >> transformJSONFrom: readStream [

	| ws |
	ws := WriteStream on: String new.
	self transformJSONFrom: readStream on: ws.
	^ ws contents
]

{ #category : #API }
FlareSenseRawSource >> transformJSONFrom: readStream on: writeStream [

	| inputCol rspCol |
	rspCol := OrderedCollection new.

	inputCol := (NeoJSONReader on: readStream) next.
	inputCol do: [ :dict | self splitEntry: dict on: rspCol ].
	writeStream nextPutAll: (NeoJSONWriter toString: rspCol)
]
