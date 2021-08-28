Extension { #name : 'SmaCCProductionRuleNode' }

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCProductionRuleNode >> buildASTNodeInterfaceIn: presentation [
	| bloc |
	bloc := presentation bloc.
	bloc title: 'AST'.
	bloc
		element: [ | element |
			element := BlElement new.
			element
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			element layout: BlFlowLayout vertical.
			self expressions
				do: [ :each | 
					| nodeElement |
					nodeElement := each buildASTNodeInterfaceElement.
					element addChild: nodeElement.
					element
						addChild:
							(BlLineElement new
								fromAnchor: (BlElementBottomLeftAnchor element: nodeElement);
								toAnchor: (BlElementBottomRightAnchor element: nodeElement);
								height: 2;
								border: (BlBorder paint: (Color black alpha: 0.75) width: 1)) ].
			element ]
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCProductionRuleNode >> buildInterfaceIn: presentation [
	self buildASTNodeInterfaceIn: presentation.
	self buildVariableNameInterfaceFor: name value in: presentation.
	presentation list
		title: 'References';
		display: [ self ruleReferences ];
		format: [ :each | each displayString ];
		tags: [ :each | each tags ].
	presentation list
		title: 'Uses';
		display: [ self uses ];
		format: [ :each | each displayString ];
		tags: [ :each | each tags ].
	self buildSourceInterfaceIn: presentation label: 'Definition'
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCProductionRuleNode >> displayString [
	^ name value
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCProductionRuleNode >> nodeName [
	^ String
		streamContents: [ :stream | 
			| nextIsUppercase |
			nextIsUppercase := true.
			name source
				do: [ :each | 
					each = $_
						ifTrue: [ nextIsUppercase := true ]
						ifFalse: [ stream
								nextPut:
									(nextIsUppercase
										ifTrue: [ each asUppercase ]
										ifFalse: [ each ]).
							nextIsUppercase := false ] ] ]
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCProductionRuleNode >> ruleReferences [
	^ self ruleReferencesTo: self name value
]

{ #category : '*GT4SmaCC-Development-UI' }
SmaCCProductionRuleNode >> tags [
	| hasClass noClass code tags |
	hasClass := noClass := code := false.
	self expressions
		do: [ :each | 
			(each isKindOf: SmaCCClassProductionExpressionNode)
				ifTrue: [ hasClass := true ]
				ifFalse: [ (each isKindOf: SmaCCCodeProductionExpressionNode)
						ifTrue: [ code := true ]
						ifFalse: [ noClass := true ] ] ].
	tags := OrderedCollection new.
	hasClass
		ifTrue: [ tags add: 'AST' ].
	code
		ifTrue: [ tags add: 'Expression' ].
	noClass
		ifTrue: [ tags add: 'Default' ].
	^ tags asArray
]
