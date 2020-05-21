Class {
	#name : #GtSmaCCRewriteElement,
	#superclass : #GtSmaCCRewriteAccordion,
	#instVars : [
		'matchElement',
		'matchEditor',
		'transformationElement',
		'transformationEditor'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #ui }
GtSmaCCRewriteElement >> contentElement [
	^ BrHorizontalPane new
		vFitContent;
		hMatchParent;
		addChild: self matchElement;
		addChild: self transformationElement;
		yourself
]

{ #category : #private }
GtSmaCCRewriteElement >> editorElementFor: anEditor [
	^ BrEditorElement new
		effect: (BlGaussianShadowEffect color: Color black width: 3 offset: 0 @ 0);
		background: Color white;
		margin: (BlInsets all: 10);
		padding:
			(BlInsets
				top: 5
				left: 10
				bottom: 5
				right: 10);
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical fitContent ];
		editor: anEditor;
		yourself
]

{ #category : #'initialize-release' }
GtSmaCCRewriteElement >> initialize [
	super initialize.
	matchEditor := BrTextEditor new.
	matchEditor
		when: BrTextEditorInsertedEvent do: [ :event | self matchChanged ];
		when: BrTextEditorDeletedEvent do: [ :event | self matchChanged ].
	transformationEditor := BrTextEditor new.
	transformationEditor
		when: BrTextEditorInsertedEvent
			do: [ :event | self transformationChanged ];
		when: BrTextEditorDeletedEvent do: [ :event | self transformationChanged ]
]

{ #category : #testing }
GtSmaCCRewriteElement >> isCodeTransformation [
	^ rewrite transformation isKindOf: SmaCCRewriteCodeTransformation
]

{ #category : #testing }
GtSmaCCRewriteElement >> isPatternMatch [
	^ rewrite match isKindOf: SmaCCRewriteTreeMatch
]

{ #category : #changes }
GtSmaCCRewriteElement >> matchChanged [
	| string |
	string := matchEditor text asString.
	self isPatternMatch
		ifTrue: [ rewrite match source: string ]
		ifFalse: [ rewrite match code: string ]
]

{ #category : #'match ui' }
GtSmaCCRewriteElement >> matchElement [
	matchElement := BrHorizontalPane new
		vFitContent;
		hMatchParent.
	self updateMatch.
	^ matchElement
]

{ #category : #'match ui' }
GtSmaCCRewriteElement >> matchHeaderElement [
	| typeLabel patternLabel toggle |
	typeLabel := self labelFor: 'Match: Type'.
	toggle := BrToggle new
		look: BrHydraSwitchWithTrackLook new;
		margin: (BlInsets all: 3);
		activated: (rewrite match isKindOf: SmaCCRewriteTypeMatch);
		when: BrToggleActivatedEvent
			do:
				[ :anEvent | rewrite match: (SmaCCRewriteTypeMatch on: SmaCCParseNode) ];
		when: BrToggleDeactivatedEvent
			do: [ :anEvent | rewrite match: SmaCCRewriteTreeMatch new ];
		yourself.
	patternLabel := self labelFor: 'Pattern'.
	^ BrHorizontalPane new
		vFitContent;
		hMatchParent;
		background: (Color veryLightGray alpha: 0.2);
		addChild: typeLabel;
		addChild: toggle;
		addChild: patternLabel;
		yourself
]

{ #category : #'match ui' }
GtSmaCCRewriteElement >> matchNodeClassElement [
	| classLabel classList |
	classLabel := self labelFor: 'Class:'.
	classList := GtSmaCCDropDownList new
		items:
			(SmaCCParseNode withAllSubclasses
				asSortedCollection: [ :a :b | a name < b name ]);
		selectedItem: rewrite match nodeClass;
		when: BrSelectionChanged
			do: [ :event | rewrite match nodeClass: event target selectedItem ];
		yourself.
	^ BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		addChild: classLabel;
		addChild: classList;
		yourself
]

{ #category : #'match ui' }
GtSmaCCRewriteElement >> matchStateElement [
	| stateLabel stateList |
	stateLabel := self labelFor: 'State:'.
	stateList := GtSmaCCDropDownList new
		items:
			(rewrite parserClass
				ifNil: [ #() ]
				ifNotNil: [ :cls | #(nil) , cls startingStateNames ]);
		selectedItem: rewrite match startingState;
		when: BrSelectionChanged
			do: [ :event | rewrite match startingState: event target selectedItem ];
		yourself.
	^ BlElement new
		layout: BlLinearLayout horizontal;
		constraintsDo: [ :c | 
			c horizontal fitContent.
			c vertical fitContent ];
		addChild: stateLabel;
		addChild: stateList;
		yourself
]

{ #category : #private }
GtSmaCCRewriteElement >> patternStyler [
	| styler |
	(rewrite parserClass notNil
		and: [ (styler := rewrite parserClass gtStyler) notNil ])
		ifFalse: [ ^ matchEditor defaultStyler ].
	styler startingState: rewrite match startingStateIndex.
	styler
		addStylerRule:
			(GtSmaCCNodeStylerRule new
				nodeClassName: #SmaCCPatternNode;
				styleBlock: [ :s | 
					s
						foreground: Color black;
						bold ]).
	^ styler
]

{ #category : #private }
GtSmaCCRewriteElement >> sourceStyler [
	^ BrRBTextStyler new
		classOrMetaClass: SmaCCRewriteMatchContext;
		workspace: GtHighlightingBindingStrategy new;
		yourself
]

{ #category : #private }
GtSmaCCRewriteElement >> subscribeEvents [
	rewrite announcer weak
		when: #match send: #updateMatch to: self;
		when: #transformation send: #updateTransformation to: self
]

{ #category : #changes }
GtSmaCCRewriteElement >> transformationChanged [
	| string |
	string := transformationEditor text asString.
	self isCodeTransformation
		ifTrue: [ rewrite transformation code: string ]
		ifFalse: [ rewrite transformation string: string ]
]

{ #category : #'transformation ui' }
GtSmaCCRewriteElement >> transformationElement [
	transformationElement := BrHorizontalPane new
		vFitContent;
		hMatchParent.
	self updateTransformation.
	^ transformationElement
]

{ #category : #'transformation ui' }
GtSmaCCRewriteElement >> transformationHeaderElement [
	| codeLabel stringLabel toggle |
	codeLabel := self labelFor: 'Transformation: Code'.
	toggle := BrToggle new
		look: BrHydraSwitchWithTrackLook new;
		margin: (BlInsets all: 3);
		activated: (rewrite transformation isKindOf: SmaCCRewriteCodeTransformation);
		when: BrToggleActivatedEvent
			do: [ :anEvent | 
			rewrite
				transformation: (SmaCCRewriteCodeTransformation on: 'self continue') ];
		when: BrToggleDeactivatedEvent
			do:
				[ :anEvent | rewrite transformation: SmaCCRewriteStringTransformation new ];
		yourself.
	stringLabel := self labelFor: 'String'.
	^ BrHorizontalPane new
		vFitContent;
		hMatchParent;
		background: (Color veryLightGray alpha: 0.2);
		addChild: codeLabel;
		addChild: toggle;
		addChild: stringLabel;
		yourself
]

{ #category : #'transformation ui' }
GtSmaCCRewriteElement >> updateCodeTransformation [
	transformationEditor text: rewrite transformation code asRopedText.
	transformationEditor text attributes: self defaultTextAttributes.
	transformationEditor styler: self sourceStyler.
	transformationElement addChild: (self editorElementFor: transformationEditor)
]

{ #category : #'match ui' }
GtSmaCCRewriteElement >> updateMatch [
	matchElement isNil
		ifTrue: [ ^ self ].
	matchElement removeChildren.
	matchElement addChild: self matchHeaderElement.
	matchEditor styler: matchEditor defaultStyler.
	self isPatternMatch
		ifTrue: [ self updatePatternMatch ]
		ifFalse: [ self updateTypeMatch ]
]

{ #category : #'match ui' }
GtSmaCCRewriteElement >> updatePatternMatch [
	matchElement addChild: self matchStateElement.
	matchEditor text: rewrite match source asRopedText.
	matchEditor text attributes: self defaultTextAttributes.
	matchEditor styler: self patternStyler.
	matchElement addChild: (self editorElementFor: matchEditor)
]

{ #category : #'transformation ui' }
GtSmaCCRewriteElement >> updateStringTransformation [
	transformationEditor text: rewrite transformation string asRopedText.
	transformationEditor text attributes: self defaultTextAttributes.
	transformationElement addChild: (self editorElementFor: transformationEditor)
]

{ #category : #'transformation ui' }
GtSmaCCRewriteElement >> updateTransformation [
	transformationElement removeChildren.
	transformationElement addChild: self transformationHeaderElement.
	transformationEditor styler: transformationEditor defaultStyler.
	self isCodeTransformation
		ifTrue: [ self updateCodeTransformation ]
		ifFalse: [ self updateStringTransformation ]
]

{ #category : #'match ui' }
GtSmaCCRewriteElement >> updateTypeMatch [
	| element variablesList editorElement |
	matchElement addChild: self matchNodeClassElement.
	matchEditor text: rewrite match code asRopedText.
	matchEditor text attributes: self defaultTextAttributes.
	matchEditor styler: self sourceStyler.
	element := BrHorizontalPane new vFitContent hMatchParent.
	editorElement := self editorElementFor: matchEditor.
	editorElement constraintsDo: [ :c | c vertical matchParent ].
	element addChild: editorElement.
	rewrite match nodeClass notNil
		ifTrue: [ variablesList := BrGridList new.
			variablesList
				vMatchParent;
				margin: (BlInsets all: 10);
				border: (BlBorder paint: Color lightGray width: 1);
				stencil: [ :each :index | 
					BlTextElement new
						text: each asRopedText;
						constraintsDo: [ :c | c horizontal matchParent ];
						padding: (BlInsets all: 5) ];
				items:
					(Set new
						addAll: rewrite match nodeClass allInstVarNames;
						removeAll: SmaCCParseNode allInstVarNames;
						yourself) asSortedCollection.
			element addChild: variablesList.
			element constraintsDo: [ :c | c minHeight: 100 ] ].
	matchElement addChild: element
]
