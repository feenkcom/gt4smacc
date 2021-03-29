Class {
	#name : #GtSmaCCCreateParserElement,
	#superclass : #GtPharoCreateBehaviorElement,
	#instVars : [
		'scannerDefinition'
	],
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #'private - instance creation' }
GtSmaCCCreateParserElement >> buildDefinitionEditor [
	| saveButton properties |
	properties := super buildDefinitionEditor.
	saveButton := properties children last.
	self scannerDefinition
		when: GtBehaviorChangeEvent
		do: [ :event | saveButton enabled: definition isValidForCreation ].
	^ properties
]

{ #category : #private }
GtSmaCCCreateParserElement >> compileBehavior [
	| change parserClass |
	change := self createParserChange.
	change execute.
	self createScannerChange execute.
	parserClass := change definedClass.
	(RBAddMethodChange
		compile:
			'scannerClass
	^' , self scannerClass
		in:
			parserClass class
		classified: #generated) execute.
	(RBAddMethodChange
		compile:
			'definitionComment
	"Start 
	:
	;"'
		in:
			parserClass class
		classified: #generated) execute.
	behaviorBlock notNil
		ifTrue: [ behaviorBlock cull: parserClass ]
]

{ #category : #private }
GtSmaCCCreateParserElement >> createParserChange [
	^ definition createBehaviorChange
]

{ #category : #private }
GtSmaCCCreateParserElement >> createScannerChange [
	scannerDefinition category package
		name: definition category package name.
	definition category tag name notEmpty
		ifTrue: [ scannerDefinition category tag name: definition category tag name ].
	^ scannerDefinition createBehaviorChange
]

{ #category : #private }
GtSmaCCCreateParserElement >> editors [
	^ {
		self scannerEditor. definition category categoryEditor
	}
]

{ #category : #'initialize-release' }
GtSmaCCCreateParserElement >> initialize [
	super initialize.
	
	definition := GtClassDefinition forNew.
	definition superclass name: #SmaCCParser.
	scannerDefinition := GtClassDefinition forNew.
	scannerDefinition superclass name: #SmaCCScanner.
	
	self parserClass: #SomeParser.
	self scannerClass: #SomeScanner.
	
	self addChild: self buildDefinitionEditor
]

{ #category : #'private - testing' }
GtSmaCCCreateParserElement >> isValidParserClassName [
	self parserClass = #SomeParser
		ifTrue: [ ^ false ].
	Smalltalk at: self parserClass asSymbol ifPresent: [ ^ false ].
	(RBScanner isVariable: self parserClass)
		ifFalse: [ ^ false ].
	^ self parserClass first isUppercase
]

{ #category : #'private - testing' }
GtSmaCCCreateParserElement >> isValidScannerClassName [
	self scannerClass = #SomeScanner
		ifTrue: [ ^ false ].
	Smalltalk at: self scannerClass asSymbol ifPresent: [ ^ false ].
	(RBScanner isVariable: self scannerClass)
		ifFalse: [ ^ false ].
	^ self scannerClass first isUppercase
]

{ #category : #accessing }
GtSmaCCCreateParserElement >> parserClass [
	^ definition name
]

{ #category : #accessing }
GtSmaCCCreateParserElement >> parserClass: aSymbol [
	definition name: aSymbol
]

{ #category : #accessing }
GtSmaCCCreateParserElement >> scannerClass [
	^ scannerDefinition name
]

{ #category : #accessing }
GtSmaCCCreateParserElement >> scannerClass: aSymbol [
	scannerDefinition name: aSymbol
]

{ #category : #accessing }
GtSmaCCCreateParserElement >> scannerDefinition [
	^ scannerDefinition
]

{ #category : #private }
GtSmaCCCreateParserElement >> scannerEditor [
	^ GtCodeDefinitionSingleEditor new
		definition: scannerDefinition;
		title: 'Scanner';
		getSelector: #name;
		setSelector: #name:;
		renameEvent: GtBehaviorRenamed
]
