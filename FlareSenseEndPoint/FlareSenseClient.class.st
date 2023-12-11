Class {
	#name : #FlareSenseClient,
	#superclass : #Object,
	#instVars : [
		'endPoint',
		'entity',
		'tailParam'
	],
	#category : #'FlareSenseEndPoint-Clients'
}

{ #category : #accessing }
FlareSenseClient class >> endPoint: urlString [

	^ self new
		  initialize: urlString;
		  yourself
]

{ #category : #actions }
FlareSenseClient >> buildCallURL [

	| result |
	endPoint ifNil: [ self error: 'No EndPoint' ].
	result := endPoint.
	(tailParam notNil and: [ tailParam > 0 ]) ifTrue: [ 
		result last = $/ ifFalse: [ result := result , '/' ].
		result := result , tailParam asString ].
	^ result
]

{ #category : #actions }
FlareSenseClient >> fetch [

	^ self fetchAs: entity
]

{ #category : #actions }
FlareSenseClient >> fetchAs: aClass [

	| rsp |
	rsp := ZnEasy get: self buildCallURL.
	rsp isError ifTrue: [ 
		^ self error: 'Error fetching from endPoint ' , endPoint ].
	^ entity
		  ifNil: [ (NeoJSONReader on: rsp entity readStream) next ]
		  ifNotNil: [ 
		  (NeoJSONReader on: rsp entity readStream) nextListAs: aClass ]
]

{ #category : #initialization }
FlareSenseClient >> initialize: urlString [

	endPoint := urlString
]
