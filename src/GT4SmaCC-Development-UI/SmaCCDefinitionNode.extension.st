Extension { #name : #SmaCCDefinitionNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCDefinitionNode >> buildInterfaceIn: presentation [
	self buildSourceInterfaceIn: presentation label: nil
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCDefinitionNode >> buildSourceInterfaceIn: presentation label: aString [
	| bloc |
	bloc := presentation bloc.
	aString notNil
		ifTrue: [ bloc title: aString ].
	bloc
		element: [ | styler text editor element |
			text := self source asRopedText.
			text attributes: GtSmaCCCoder defaultTextAttributes.
			styler := GtSmaCCGrammarStyler for: SmaCCScanner.
			editor := BrTextEditorModel new.
			editor text: (styler style: text).
			element := BrEditorElement new.
			element editor: editor.
			element
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			element ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCDefinitionNode >> buildVariableNameInterfaceFor: aString in: presentation [
	| bloc refs count commonName |
	refs := (self allReferencesTo: aString) select: [ :each | each isKindOf: SmaCCSymbolNode ].
	refs isEmpty
		ifTrue: [ ^ self ].
	count := 0.
	commonName := ''.
	(Bag withAll: (refs collect: [ :e | e variableName ]))
		doWithOccurrences: [ :each :occ | 
			(each = '' or: [ occ > count ])
				ifTrue: [ count := occ.
					commonName := each ] ].
	bloc := presentation bloc.
	bloc title: 'Variable Names'.
	bloc
		element: [ | element defaultNameElement defaultNameEditor |
			element := BlElement new.
			element
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			element layout: BlFlowLayout vertical.
			defaultNameEditor := BrTextEditorModel new.
			defaultNameEditor text: commonName asRopedText.
			refs size > 1
				ifTrue: [ defaultNameElement := BlElement new
						constraintsDo: [ :c | 
							c horizontal matchParent.
							c vertical fitContent ];
						layout: BlFlowLayout horizontal;
						yourself.
					defaultNameElement
						addChild:
							((BlTextElement text: 'Default name:' asRopedText)
								margin: (BlInsets all: 7);
								yourself).
					defaultNameElement
						addChild:
							(BrEditorElement new
								editor: defaultNameEditor;
								size: 200 @ 23;
								border: (BlBorder paint: Color lightGray);
								margin: (BlInsets all: 4);
								yourself).
					element addChild: defaultNameElement.
					element
						addChild:
							(BlLineElement new
								fromAnchor: (BlElementBottomLeftAnchor element: defaultNameElement);
								toAnchor: (BlElementBottomRightAnchor element: defaultNameElement);
								height: 2;
								border: (BlBorder paint: (Color black alpha: 0.75) width: 1)) ].
			refs
				do: [ :each | 
					(each buildVariableNameInterfaceElement: defaultNameEditor)
						ifNotNil: [ :refElement | 
							element
								addChild: refElement;
								addChild:
									(BlLineElement new
										fromAnchor: (BlElementBottomLeftAnchor element: refElement);
										toAnchor: (BlElementBottomRightAnchor element: refElement);
										height: 2;
										border: (BlBorder paint: (Color black alpha: 0.75) width: 1)) ] ].
			element ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCDefinitionNode >> defaultTextAttributes [
	^ GtSmaCCCoder defaultTextAttributes
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCDefinitionNode >> matches: aString [
	^ (self source asLowercase indexOfSubCollection: aString asLowercase) > 0
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCDefinitionNode >> scannerClass [
	^ self topParent attributeNamed: #scannerClass ifAbsent: [ SmaCCScanner ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCDefinitionNode >> tags [
	^ #()
]
