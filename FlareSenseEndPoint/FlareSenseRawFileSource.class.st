Class {
	#name : #FlareSenseRawFileSource,
	#superclass : #FlareSenseRawSource,
	#instVars : [
		'inputFile'
	],
	#category : #'FlareSenseEndPoint-Clients'
}

{ #category : #accessing }
FlareSenseRawFileSource class >> inputFile: filename [

	^ self new
		  initialize: filename;
		  yourself
]

{ #category : #actions }
FlareSenseRawFileSource >> fetchAs: aClass [

	^ aClass
		  ifNil: [ (NeoJSONReader on: inputFile readStream) next ]
		  ifNotNil: [ 
			  (NeoJSONReader on: (self transformJSONFrom: inputFile readStream)) 
				  nextListAs: aClass ]
]

{ #category : #accessing }
FlareSenseRawFileSource >> initialize: filename [

	inputFile := filename asFileReference
]

{ #category : #accessing }
FlareSenseRawFileSource >> inputFile [

	^ inputFile
]
