Class {
	#name : #FlareSenseAggregator,
	#superclass : #Object,
	#instVars : [
		'aggregation',
		'mappings',
		'keyBlock'
	],
	#category : #'FlareSenseEndPoint-Clients'
}

{ #category : #api }
FlareSenseAggregator >> addAverageMappingFor: aSymbol [

	mappings at: aSymbol put: self averageAggregationBlock
]

{ #category : #api }
FlareSenseAggregator >> addMaxMappingFor: aSymbol [

	mappings at: aSymbol put: self maxAggregationBlock
]

{ #category : #api }
FlareSenseAggregator >> addMinMappingFor: aSymbol [

	mappings at: aSymbol put: self minAggregationBlock
]

{ #category : #api }
FlareSenseAggregator >> addSumMappingFor: aSymbol [

	mappings at: aSymbol put: self sumAggregationBlock
]

{ #category : #api }
FlareSenseAggregator >> aggregate: bulkCollection [

	| result key |
	bulkCollection do: [ :each | 
		key := keyBlock value: each when .
		self applyMappingsTo: each key: key ].
	result := SortedCollection sortBlock: [ :a :b | a key < b key ].
	aggregation associationsDo: [ :each | result add: each ].


	^ result
]

{ #category : #api }
FlareSenseAggregator >> aggregate: bulkCollection do: aBlock [

	(self aggregate: bulkCollection) do: aBlock
]

{ #category : #private }
FlareSenseAggregator >> applyMappingsTo: row key: key [

	| result |
	result := Dictionary new.
	mappings keysAndValuesDo: [ :k :map | 
		aggregation
			at: key
			ifPresent: [ :v | 
			aggregation at: key put: (map value: row value: v value: k) ]
			ifAbsent: [ 
				aggregation
					at: key
					put: (map value: row value: Dictionary new value: k) ] ]
]

{ #category : #private }
FlareSenseAggregator >> averageAggregationBlock [

	^ [ :bulk :outReg :key | 
	  | value |
	  value := bulk perform: key.
	  outReg
		  at: key
		  ifPresent: [ :v | 
			  outReg at: key put: (v
					   at: 1 put: (v at: 1) + value;
					   at: 2 put: (v at: 2) + 1;
					   yourself) ]
		  ifAbsent: [ 
			  outReg at: key put: { 
					  value.
					  1 } ].
	  outReg ]
]

{ #category : #api }
FlareSenseAggregator >> daily [

	keyBlock := [ :dt | 
	            DateAndTime
		            year: dt year
		            month: dt month
		            day: dt day
		            hour: 0
		            minute: 0
		            second: 0
		            nanoSecond: 0
		            offset: dt offset ]
]

{ #category : #api }
FlareSenseAggregator >> hourly [

	keyBlock := [ :dt | 
	            DateAndTime
		            year: dt year
		            month: dt month
		            day: dt dayOfMonth
		            hour: dt hour
		            minute: 0
		            second: 0
		            nanoSecond: 0
		            offset: dt offset ]
]

{ #category : #initialization }
FlareSenseAggregator >> initialize [

	aggregation := Dictionary new.
	mappings := Dictionary new.
	keyBlock := [ :dt | ^ dt ]
]

{ #category : #private }
FlareSenseAggregator >> maxAggregationBlock [
^[ :bulk :outReg :key | 
		| value |
		value := bulk perform: key.
		outReg
			at: key
			ifPresent: [ :v | outReg at: key put: (value max: v) ]
			ifAbsent: [ outReg at: key put: value ].
		outReg ]
]

{ #category : #private }
FlareSenseAggregator >> minAggregationBlock [
^[ :bulk :outReg :key | 
		| value |
		value := bulk perform: key.
		outReg
			at: key
			ifPresent: [ :v | outReg at: key put: (value min: v) ]
			ifAbsent: [ outReg at: key put: value ].
		outReg ]
]

{ #category : #private }
FlareSenseAggregator >> sumAggregationBlock [
^[ :bulk :outReg :key | 
		| value |
		value := bulk perform: key.
		outReg
			at: key
			ifPresent: [ :v | outReg at: key put: value + v ]
			ifAbsent: [ outReg at: key put: value ].
		outReg ]
]
