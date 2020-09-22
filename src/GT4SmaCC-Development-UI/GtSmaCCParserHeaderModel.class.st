Class {
	#name : #GtSmaCCParserHeaderModel,
	#superclass : #GtBehaviorCoderHeaderModel,
	#instVars : [
		'scannerDefinition'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #changes }
GtSmaCCParserHeaderModel >> createParserChange [
	^ definition createBehaviorChange
]

{ #category : #changes }
GtSmaCCParserHeaderModel >> createScannerChange [
	scannerDefinition category package
		name: definition category package name.
	definition category tag name notEmpty
		ifTrue: [ scannerDefinition category tag name: definition category tag name ].
	^ scannerDefinition createBehaviorChange
]

{ #category : #accessing }
GtSmaCCParserHeaderModel >> editors [
	^ {self scannerEditor.
	definition category categoryEditor}
]

{ #category : #accessing }
GtSmaCCParserHeaderModel >> initialize [
	super initialize.
	self definition: GtClassDefinition forNew.
	definition superclass name: #SmaCCParser.
	scannerDefinition := GtClassDefinition forNew.
	scannerDefinition superclass name: #SmaCCScanner
]

{ #category : #testing }
GtSmaCCParserHeaderModel >> isValidForCreation [
	^ super isValidForCreation
		and:
			[ self isValidScannerClassName and: [ self isValidParserClassName ] ]
]

{ #category : #testing }
GtSmaCCParserHeaderModel >> isValidParserClassName [
	self parserClass = #SomeParser
		ifTrue: [ ^ false ].
	Smalltalk at: self parserClass asSymbol ifPresent: [ ^ false ].
	(RBScanner isVariable: self parserClass)
		ifFalse: [ ^ false ].
	^ self parserClass first isUppercase
]

{ #category : #testing }
GtSmaCCParserHeaderModel >> isValidScannerClassName [
	self scannerClass = #SomeScanner
		ifTrue: [ ^ false ].
	Smalltalk at: self scannerClass asSymbol ifPresent: [ ^ false ].
	(RBScanner isVariable: self scannerClass)
		ifFalse: [ ^ false ].
	^ self scannerClass first isUppercase
]

{ #category : #testing }
GtSmaCCParserHeaderModel >> parserClass [
	^ definition name
]

{ #category : #testing }
GtSmaCCParserHeaderModel >> parserClass: aSymbol [
	definition name: aSymbol
]

{ #category : #accessing }
GtSmaCCParserHeaderModel >> scannerClass [
	^ scannerDefinition name
]

{ #category : #accessing }
GtSmaCCParserHeaderModel >> scannerClass: aSymbol [
	scannerDefinition name: aSymbol
]

{ #category : #accessing }
GtSmaCCParserHeaderModel >> scannerDefinition [
	^ scannerDefinition
]

{ #category : #accessing }
GtSmaCCParserHeaderModel >> scannerEditor [
	^ GtCodeDefinitionSingleEditor new
		definition: scannerDefinition;
		title: 'Scanner';
		getSelector: #name;
		setSelector: #name:;
		renameEvent: GtBehaviorRenamed
]
