Extension { #name : #SmaCCTransformationToolkitDebugAction }

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCTransformationToolkitDebugAction class >> iconNamed: aSymbol [
	| nameToTry |
	nameToTry := (aSymbol beginsWith: 'glamorous')
			ifTrue: [ ((aSymbol at: 10) asLowercase asString , (aSymbol allButFirst: 10)) asSymbol ]
			ifFalse: [ aSymbol ].
	^ (BrGlamorousIcons class canUnderstand: nameToTry)
		ifTrue: [ BrGlamorousIcons perform: nameToTry ]
		ifFalse: [ super iconNamed: aSymbol ]
]
