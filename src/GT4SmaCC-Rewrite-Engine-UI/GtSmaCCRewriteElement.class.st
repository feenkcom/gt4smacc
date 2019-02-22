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

{ #category : #updating }
GtSmaCCRewriteElement >> contentElement [
	^ BlElement new
		look: BrLayoutLook linearVertical vFitContent hMatchParent;
		addChild:
			((self labelFor: 'Match')
				hMatchParent;
				background: (Color veryLightGray alpha: 0.2);
				yourself);
		addChild: self matchElement;
		addChild:
			((self labelFor: 'Transformation')
				hMatchParent;
				background: (Color veryLightGray alpha: 0.2);
				yourself);
		addChild: self transformationElement;
		yourself
]

{ #category : #private }
GtSmaCCRewriteElement >> editorElementFor: anEditor [
	^ BrEditorElement new
		effect: (BlDropShadowEffect color: Color black width: 5 offset: 0 @ 0);
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

{ #category : #'instance creation' }
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

{ #category : #changes }
GtSmaCCRewriteElement >> matchChanged [
]

{ #category : #'match ui' }
GtSmaCCRewriteElement >> matchElement [
	matchElement := BlElement new.
	matchElement
		look: BrLayoutLook linearVertical vFitContent hMatchParent.
	self updateMatch.
	^ matchElement
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
				ifNotNil: [ :cls | cls startingStateNames ]);
		selectedItem: rewrite match startingState;
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

{ #category : #'match ui' }
GtSmaCCRewriteElement >> matchTypeElement [
	| typeLabel patternLabel toggle |
	typeLabel := self labelFor: 'Type'.
	toggle := BrToggle new
		look: BrHydraSwitchWithTrackLook new;
		margin: (BlInsets all: 3);
		activated: (rewrite match isKindOf: SmaCCRewriteTypeMatch);
		yourself.
	patternLabel := self labelFor: 'Pattern'.
	^ BlElement new
		look: BrLayoutLook linearHorizontal vFitContent hMatchParent;
		addChild: typeLabel;
		addChild: toggle;
		addChild: patternLabel;
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

{ #category : #changes }
GtSmaCCRewriteElement >> transformationChanged [
]

{ #category : #'transformation ui' }
GtSmaCCRewriteElement >> transformationElement [
	transformationElement := BlElement new.
	transformationElement
		look: BrLayoutLook linearVertical vFitContent hMatchParent.
	self updateTransformation.
	^ transformationElement
]

{ #category : #'transformation ui' }
GtSmaCCRewriteElement >> transformationTypeElement [
	| codeLabel stringLabel toggle |
	codeLabel := self labelFor: 'Code'.
	toggle := BrToggle new
		look: BrHydraSwitchWithTrackLook new;
		margin: (BlInsets all: 3);
		activated: (rewrite transformation isKindOf: SmaCCRewriteCodeTransformation);
		yourself.
	stringLabel := self labelFor: 'String'.
	^ BlElement new
		look: BrLayoutLook linearHorizontal vFitContent hMatchParent;
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
	matchElement removeChildren.
	matchElement addChild: self matchTypeElement.
	matchEditor styler: matchEditor defaultStyler.
	(rewrite match isKindOf: SmaCCRewriteTreeMatch)
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
	transformationElement addChild: self transformationTypeElement.
	transformationEditor styler: transformationEditor defaultStyler.
	(rewrite transformation isKindOf: SmaCCRewriteCodeTransformation)
		ifTrue: [ self updateCodeTransformation ]
		ifFalse: [ self updateStringTransformation ]
]

{ #category : #'match ui' }
GtSmaCCRewriteElement >> updateTypeMatch [
	matchElement addChild: self matchNodeClassElement.
	matchEditor text: rewrite match code asRopedText.
	matchEditor text attributes: self defaultTextAttributes.
	matchEditor styler: self sourceStyler.
	matchElement addChild: (self editorElementFor: matchEditor)
]
