"
FlareSense Source adapter
"
Class {
	#name : #FlareSenseRawSource,
	#superclass : #Object,
	#instVars : [
		'filterBlock',
		'badEntries',
		'keepBadEntries',
		'fixTimezone'
	],
	#category : #'FlareSenseEndPoint-Clients'
}

{ #category : #accessing }
FlareSenseRawSource class >> source: aString [

	^ self subclassResponsibility
]

{ #category : #API }
FlareSenseRawSource >> checkConsistency: dictEntry [

	"dictEntry needs to have the DeltaTimeM key or the number of values is "

	^ dictEntry includesKey: 'timeDeltaM'
]

{ #category : #actions }
FlareSenseRawSource >> fetch [

	^ self fetchAs: nil
]

{ #category : #actions }
FlareSenseRawSource >> fetchAs: aClass [

	^ self subclassResponsibility
]

{ #category : #accessing }
FlareSenseRawSource >> filterBlock: anObject [

	filterBlock := anObject
]

{ #category : #accessing }
FlareSenseRawSource >> fixTimezone: secondsOffset [

	fixTimezone := secondsOffset
]

{ #category : #accessing }
FlareSenseRawSource >> ignoreBadEntries [

	keepBadEntries := false
]

{ #category : #initialization }
FlareSenseRawSource >> initialize [

	filterBlock := [ :dt | true ].
	badEntries := OrderedCollection new.
	keepBadEntries := false.
	fixTimezone := 0
]

{ #category : #API }
FlareSenseRawSource >> isUsableEntry: dictEntry [

	^ (filterBlock value: dictEntry) and: [ 
		  self checkConsistency: dictEntry ]
]

{ #category : #accessing }
FlareSenseRawSource >> keepBadEntries [

	keepBadEntries := true
]

{ #category : #API }
FlareSenseRawSource >> splitEntry: dict on: rspCol [

	| count holder deltaCount |
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
	deltaCount := 0.
	holder reverseDo: [ :each | 
		| date |
		date := (DateAndTime fromString: (each at: #when))
		        - (Duration minutes: (each at: #timeDeltaM) * deltaCount).
		each at: #when put: (date translateTo: fixTimezone) printString.


		date printString.
		deltaCount := deltaCount + 1 ].


	rspCol addAllLast: holder
]

{ #category : #API }
FlareSenseRawSource >> transformJSONFrom: readStream [

	| ws |
	ws := WriteStream on: String new.
	self transformJSONFrom: readStream on: ws.
	^ ReadStream on: ws contents
]

{ #category : #API }
FlareSenseRawSource >> transformJSONFrom: readStream on: writeStream [

	| inputCol rspCol |
	rspCol := OrderedCollection new.

	inputCol := (NeoJSONReader on: readStream) next.
	inputCol do: [ :dict | 
		(self isUsableEntry: dict)
			ifTrue: [ self splitEntry: dict on: rspCol ]
			ifFalse: [ keepBadEntries and: [ badEntries addLast: dict ] ] ].
	writeStream nextPutAll: (NeoJSONWriter toString: rspCol)
]
