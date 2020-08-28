Extension { #name : #SmaCCProductionExpressionNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCProductionExpressionNode >> astNodeName [
	^ self attributeNamed: #astNodeName ifAbsent: [ self originalAstNodeName ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCProductionExpressionNode >> astNodeName: aString [
	^ self attributeNamed: #astNodeName put: aString
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCProductionExpressionNode >> buildASTNodeInterfaceElement [
	| toggle element label textEditor editorElement textChangedBlock |
	textEditor := BrTextEditor new.
	element := BlElement new.
	element
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ].
	element layout: BlFlowLayout horizontal.
	label := BlTextElement text: self styledProductionLabel asRopedText.
	label margin: (BlInsets all: 7).
	toggle := BrToggle new
		look: BrMaterialToggleLabelledLook;
		label: 'AST';
		margin: (BlInsets all: 1).
	toggle activated: self hasNodeDefined.
	toggle viewModel
		when: BrToggleActivatedEvent do: [ self definesNode: true ];
		when: BrToggleDeactivatedEvent
			do: [ self definesNode: false.
			self removeAttributeNamed: #astNodeName.
			textEditor text: '' asRopedText ].
	textEditor text: self astNodeName asRopedText.
	textChangedBlock := [ :event | 
	| astNode |
	astNode := textEditor text asString.
	(astNode notEmpty and: [ toggle isActivated not ])
		ifTrue: [ toggle activate.
			self definesNode: true ].
	self astNodeName: astNode ].
	textEditor
		when: BrTextEditorInsertedEvent do: textChangedBlock;
		when: BrTextEditorDeletedEvent do: textChangedBlock.
	editorElement := BrEditorElement new.
	editorElement editor: textEditor.
	editorElement size: 200 @ 23.
	editorElement
		border: (BlBorder paint: Color lightGray);
		margin: (BlInsets all: 4).
	element addChild: toggle.
	element addChild: editorElement.
	element addChild: label.
	^ element
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCProductionExpressionNode >> definesNode: aBoolean [
	^ self attributeNamed: #hasNodeDefined put: aBoolean
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCProductionExpressionNode >> hasNodeDefined [
	^ self attributeNamed: #hasNodeDefined ifAbsent: [ self class == SmaCCClassProductionExpressionNode ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCProductionExpressionNode >> originalAstNodeName [
	^ ''
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCProductionExpressionNode >> styledProductionLabel [
	^ self styledText
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCProductionExpressionNode >> styledText [
	| text rule |
	rule := self parentOfType: SmaCCProductionRuleNode.
	text := rule source asRopedText.
	text attributes: GtSmaCCCoder defaultTextAttributes.
	GtSmaCCGrammarStyler new style: text.
	^ text
		copyFrom: self startPosition - rule startPosition + 1
		to: self stopPosition - rule startPosition + 1
]
