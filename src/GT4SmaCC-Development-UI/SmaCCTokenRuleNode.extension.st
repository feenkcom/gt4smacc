Extension { #name : #SmaCCTokenRuleNode }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> buildInterfaceIn: presentation [
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
	self buildSourceInterfaceIn: presentation label: 'Definition'.
	self buildMethodInterfaceIn: presentation
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> buildMethodInterfaceIn: presentation [
	self isMethod
		ifFalse: [ ^ self ].
	presentation bloc
		title: 'Method';
		element: [ | text styler editor editorElement |
			text := ((self scannerClass whichClassIncludesSelector: self selector) sourceCodeAt: self selector) asRopedText.
			text attributes: { (BlFontSizeAttribute size: 14) beNotOverwritableByStyler}.
			styler := BrRBTextStyler new.
			styler classOrMetaClass: self scannerClass.
			editor := BrTextEditorModel new.
			editor styler: styler.
			editor text: text.
			editorElement := BrEditorElement new.
			editorElement
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical matchParent ].
			editorElement editor: editor.
			editorElement ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> displayString [
	^ name value
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> isMethod [
	^ (self scannerClass whichClassIncludesSelector: self selector)
		ifNil: [ false ]
		ifNotNil: [ :cls | cls includesBehavior: SmaCCScanner ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> ruleReferences [
	^ self ruleReferencesTo: self name value
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> selector [
	^ (self name value copyFrom: 2 to: self name value size - 1) asSymbol
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> tags [
	^ self isMethod
		ifTrue: [ #('Token' 'Method') ]
		ifFalse: [ #('Token') ]
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCTokenRuleNode >> testTokensDo: aBlock [
	aBlock value: name
]
