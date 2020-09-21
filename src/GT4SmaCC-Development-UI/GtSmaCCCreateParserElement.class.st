Class {
	#name : #GtSmaCCCreateParserElement,
	#superclass : #GtCreateBehaviorElement,
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #'private - instance creation' }
GtSmaCCCreateParserElement >> buildDefinitionEditor [
	| saveButton properties |
	properties := super buildDefinitionEditor.
	saveButton := properties children last.
	headerModel scannerDefinition
		when: GtBehaviorChangeEvent
		do: [ :event | saveButton enabled: headerModel isValidForCreation ].
	^ properties
]

{ #category : #private }
GtSmaCCCreateParserElement >> compileBehavior [
	| change parserClass |
	change := headerModel createParserChange.
	change execute.
	headerModel createScannerChange execute.
	parserClass := change definedClass.
	(RBAddMethodChange
		compile:
			'scannerClass
	^' , headerModel scannerClass
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

{ #category : #'initialize-release' }
GtSmaCCCreateParserElement >> initialize [
	super initialize.
	headerModel := GtSmaCCParserHeaderModel new.
	headerModel parserClass: #SomeParser.
	headerModel scannerClass: #SomeScanner.
	self addChild: self buildDefinitionEditor
]
