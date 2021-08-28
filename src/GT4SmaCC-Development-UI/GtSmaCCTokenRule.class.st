Class {
	#name : 'GtSmaCCTokenRule',
	#superclass : 'GtSmaCCGrammarItem',
	#category : 'GT4SmaCC-Development-UI-Model'
}

{ #category : 'testing' }
GtSmaCCTokenRule >> isReferenced [
	^ super isReferenced or: [ self isScannerMethod ]
]

{ #category : 'testing' }
GtSmaCCTokenRule >> isScannerMethod [
	^ ((grammar scannerClass ifNil: [ SmaCCScanner ])
		whichClassIncludesSelector: self methodName)
		ifNil: [ false ]
		ifNotNil: [ :class | class includesBehavior: SmaCCScanner ]
]

{ #category : 'testing' }
GtSmaCCTokenRule >> isTokenRule [
	^ true
]

{ #category : 'accessing' }
GtSmaCCTokenRule >> methodName [
	^ self name
		ifNil: [ #'' ]
		ifNotNil: [ :name | (name copyFrom: 2 to: name size - 1) asSymbol ]
]

{ #category : 'private' }
GtSmaCCTokenRule >> parserStartingState [
	^ SmaCCDefinitionParser startingStateForRegexRule
]
