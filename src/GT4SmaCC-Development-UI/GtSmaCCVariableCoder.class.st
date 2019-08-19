Class {
	#name : #GtSmaCCVariableCoder,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'owner',
		'itemName',
		'expanded',
		'collapsedEditor',
		'sourceEditor',
		'attributes'
	],
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #'instance creation' }
GtSmaCCVariableCoder class >> for: aString in: aGrammarCoder [
	^ self new
		itemName: aString;
		owner: aGrammarCoder;
		yourself
]

{ #category : #announcer }
GtSmaCCVariableCoder >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #elements }
GtSmaCCVariableCoder >> asElement [
	^ GtSmaCCVariableCoderElement onCoder: self
]

{ #category : #accessing }
GtSmaCCVariableCoder >> expanded [
	^ expanded
]

{ #category : #accessing }
GtSmaCCVariableCoder >> expanded: anObject [
	expanded := anObject
]

{ #category : #accessing }
GtSmaCCVariableCoder >> grammar [
	^ owner grammar
]

{ #category : #accessing }
GtSmaCCVariableCoder >> highlighter: highlighter [
]

{ #category : #'initialize-release' }
GtSmaCCVariableCoder >> initialize [
	super initialize.
	expanded := false
]

{ #category : #accessing }
GtSmaCCVariableCoder >> itemName [
	^ itemName
]

{ #category : #accessing }
GtSmaCCVariableCoder >> itemName: aString [
	itemName := aString
]

{ #category : #accessing }
GtSmaCCVariableCoder >> labelText [
	| text |
	text := itemName asRopedText.
	itemName first = $<
		ifTrue: [ GtSmaCCStyler formatToken: text ]
		ifFalse: [ itemName first = $"
				ifTrue: [ GtSmaCCStyler formatKeyword: text ]
				ifFalse: [ GtSmaCCStyler formatProduction: text ] ].
	text bold.
	text attributes: GtSmaCCCoder defaultTextAttributes.
	^ text
]

{ #category : #actions }
GtSmaCCVariableCoder >> nameVariableAt: anInteger as: aString [
	(aString isEmpty or: [ RBScanner isVariable: aString ])
		ifFalse: [ ^ nil ].
	self
		referencesDo: [ :node :index :production | 
			index = anInteger
				ifTrue: [ production
						source:
							(String
								streamContents: [ :stream | 
									stream nextPutAll: (production source first: node name stopPosition).
									aString notEmpty
										ifTrue: [ stream
												nextPutAll: ' ''';
												nextPutAll: aString;
												nextPut: $' ].
									stream
										nextPutAll: (production source allButFirst: node stopPosition) ]).
					^ aString ] ].
	^ nil
]

{ #category : #accessing }
GtSmaCCVariableCoder >> owner [
	^ owner
]

{ #category : #accessing }
GtSmaCCVariableCoder >> owner: aGrammarCoder [
	owner := aGrammarCoder
]

{ #category : #accessing }
GtSmaCCVariableCoder >> referenceTextFor: node at: index in: aProduction [
	| ruleText position styler |
	ruleText := (String
		streamContents: [ :stream | 
			stream
				nextPutAll: aProduction name;
				nextPutAll: ' : ';
				nextPutAll:
					(aProduction source
						copyFrom: (node parentOfType: SmaCCProductionExpressionNode) startPosition
						to: node name stopPosition).
			position := stream position.
			stream
				nextPut: $ ;
				nextPutAll:
					(aProduction source
						copyFrom: node stopPosition + 1
						to: (node parentOfType: SmaCCProductionExpressionNode) stopPosition);
				nextPut: $; ]) asRopedText.
	styler := GtSmaCCGrammarStyler
		for: owner scannerClass
		grammar: owner grammar ast.
	ruleText attributes: GtSmaCCCoder defaultTextAttributes.
	ruleText := styler privateStyle: ruleText.
	ruleText
		clearAttributes: [ :each | each class = BrTextExpandButtonAttribute ].
	(ruleText from: position - node name value size + 1 to: position)
		attributes:
			{(BlTextUnderlineAttribute new
				paint: BrGlamorousColors textHighlightColor;
				width: 3)}.
	(ruleText from: position to: position)
		attributes:
			{(GtSmaCCVariableNameAnnotationAttribute
				for: self
				at: index
				named: node variableName)}.
	^ ruleText
]

{ #category : #accessing }
GtSmaCCVariableCoder >> references [
	| references |
	references := OrderedCollection new.
	self grammar
		activeProductionsDo: [ :each | 
			each ast
				allNodesOfType: SmaCCSymbolNode
				do: [ :node | 
					node name value = itemName
						ifTrue: [ references add: node ] ] ].
	^ references
]

{ #category : #private }
GtSmaCCVariableCoder >> referencesDo: aBlock [
	| index |
	index := 1.
	self grammar
		activeProductionsDo: [ :each | 
			each ast
				allNodesOfType: SmaCCSymbolNode
				do: [ :node | 
					node name value = itemName
						ifTrue: [ aBlock cull: node cull: index cull: each.
							index := index + 1 ] ] ]
]

{ #category : #accessing }
GtSmaCCVariableCoder >> referencesText [
	| references |
	references := OrderedCollection new.
	self
		referencesDo:
			[ :node :index :production | references add: (self referenceTextFor: node at: index in: production) ].
	^ references
]
