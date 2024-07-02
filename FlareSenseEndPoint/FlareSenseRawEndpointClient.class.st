Class {
	#name : #FlareSenseRawEndpointClient,
	#superclass : #FlareSenseRawSource,
	#instVars : [
		'endPoint',
		'tailParam'
	],
	#category : #'FlareSenseEndPoint-Clients'
}

{ #category : #accessing }
FlareSenseRawEndpointClient class >> endPoint: urlString [

	^ self new
		  initialize: urlString;
		  yourself
]

{ #category : #API }
FlareSenseRawEndpointClient >> aggregateWith: aggregator [

	"returns a dictionary produced by the aggregator"

	| rsp |
	rsp := ZnEasy get: self buildCallURL.
	rsp isError ifTrue: [ 
		^ self error: 'Error fetching from endPoint ' , endPoint ].
	^ aggregator aggregate: (self transformJSONFrom: rsp entity readStream)
]

{ #category : #actions }
FlareSenseRawEndpointClient >> buildCallURL [

	| result |
	endPoint ifNil: [ self error: 'No EndPoint' ].
	result := endPoint.
	(tailParam notNil and: [ tailParam > 0 ]) ifTrue: [ 
		result last = $/ ifFalse: [ result := result , '/' ].
		result := result , tailParam asString ].
	^ result
]

{ #category : #API }
FlareSenseRawEndpointClient >> fetchAs: aClass [

	| rsp |
	rsp := ZnEasy get: self buildCallURL.
	rsp isError ifTrue: [ 
		^ self error: 'Error fetching from endPoint ' , endPoint ].
	^ aClass
		  ifNil: [ (NeoJSONReader on: rsp entity readStream) next ]
		  ifNotNil: [ 
			  (NeoJSONReader on: (self transformJSONFrom: rsp entity readStream)) 
				  nextListAs: aClass ]
]

{ #category : #initialization }
FlareSenseRawEndpointClient >> initialize: urlString [

	endPoint := urlString
]
