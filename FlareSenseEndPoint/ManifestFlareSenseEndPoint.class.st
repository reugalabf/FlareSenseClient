"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestFlareSenseEndPoint,
	#superclass : #PackageManifest,
	#category : #'FlareSenseEndPoint-Manifest'
}

{ #category : #'code-critics' }
ManifestFlareSenseEndPoint class >> ruleToDoRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#FlareSenseRawEndpointClient #splitEntry:on: #false)) #'2023-12-11T15:20:00.447688-03:00') )
]

{ #category : #'code-critics' }
ManifestFlareSenseEndPoint class >> ruleUtilityMethodsRuleV1FalsePositive [
	^ #(#(#(#RGMethodDefinition #(#FlareSenseRawEndpointClient #splitEntry:on: #false)) #'2023-12-11T15:19:56.778373-03:00') )
]
