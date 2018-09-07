Extension { #name : #SmaCCSymbolNode }

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCSymbolNode >> buildVariableNameInterfaceElement: aBrTextEditor [
	| expression element isCommon textEditor labelText editorElement commonNameBlock nameEditorBlock |
	expression := self
		lookupNode: [ :node | (node isKindOf: SmaCCProductionExpressionNode) and: [ node parent isKindOf: SmaCCProductionRuleNode ] ].
	expression isNil
		ifTrue: [ ^ nil ].
	isCommon := self variableName = aBrTextEditor text asString.
	textEditor := BrTextEditor new.
	commonNameBlock := [ :event | 
	| newName |
	newName := aBrTextEditor text asString.
	isCommon
		ifTrue: [ textEditor text: newName asRopedText.
			self variableName: newName ].
	isCommon := textEditor text asString = aBrTextEditor text asString ].
	aBrTextEditor
		when: BrTextEditorInsertedEvent do: commonNameBlock;
		when: BrTextEditorDeletedEvent do: commonNameBlock.
	nameEditorBlock := [ :event | 
	self variableName: textEditor text asString.
	isCommon := textEditor text asString = aBrTextEditor text asString ].
	textEditor
		when: BrTextEditorInsertedEvent do: nameEditorBlock;
		when: BrTextEditorDeletedEvent do: nameEditorBlock.
	element := BlElement new.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element layout: BlFlowLayout horizontal.
	textEditor text: self variableName asRopedText.
	editorElement := BrEditorElement new.
	editorElement editor: textEditor.
	editorElement size: 200 @ 23.
	editorElement
		border: (BlBorder paint: Color lightGray);
		margin: (BlInsets all: 4).
	labelText := expression styledText.
	(labelText from: self startPosition - parent startPosition + 1 to: self stopPosition - parent startPosition + 1)
		underlinePaint: Color black
		width: 3.
	element
		addChild: editorElement;
		addChild:
			((BlTextElement text: labelText)
				margin: (BlInsets all: 7);
				yourself).
	^ element
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCSymbolNode >> definition [
	^ nil
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCSymbolNode >> updateSource: aSmaCCString [
	| name |
	name := self attributeNamed: #variableName ifAbsent: [ ^ self ].
	name isEmpty
		ifTrue: [ variableNameToken notNil
				ifTrue: [ aSmaCCString deleteFrom: variableNameToken startPosition to: variableNameToken stopPosition ] ]
		ifFalse: [ variableNameToken notNil
				ifTrue: [ aSmaCCString deleteFrom: variableNameToken startPosition to: variableNameToken stopPosition.
					aSmaCCString insert: '''' , name , '''' at: variableNameToken startPosition ]
				ifFalse: [ aSmaCCString insert: ' ''' , name , '''' at: (aSmaCCString nextIndex: self name stopPosition) ] ]
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCSymbolNode >> variableName [
	^ self
		attributeNamed: #variableName
		ifAbsent: [ variableNameToken isNil
				ifTrue: [ '' ]
				ifFalse: [ variableNameToken value copyFrom: 2 to: variableNameToken value size - 1 ] ]
]

{ #category : #'*GT-SmaCC-Development-UI' }
SmaCCSymbolNode >> variableName: aString [
	^ self attributeNamed: #variableName put: aString
]
