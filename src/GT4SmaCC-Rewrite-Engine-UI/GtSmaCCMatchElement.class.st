Class {
	#name : #GtSmaCCMatchElement,
	#superclass : #BlElement,
	#instVars : [
		'rewrite',
		'editor'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'instance creation' }
GtSmaCCMatchElement class >> rewrite: aSmaCCRewrite [
	^ self new
		rewrite: aSmaCCRewrite;
		yourself
]

{ #category : #private }
GtSmaCCMatchElement >> defaultTextAttributes [
	^ {BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
	(BlFontSizeAttribute size: 14) beNotOverwritableByStyler}
]

{ #category : #'initialize-release' }
GtSmaCCMatchElement >> initialize [
	super initialize.
	self look: BrLayoutLook linearVertical vFitContent hMatchParent.
	editor := BrTextEditor new.
	editor
		when: BrTextEditorInsertedEvent do: [ :event | self sourceChanged ];
		when: BrTextEditorDeletedEvent do: [ :event | self sourceChanged ]
]

{ #category : #private }
GtSmaCCMatchElement >> labelFor: aString [
	^ BrLabel new
		text: aString;
		look: BrGlamorousLabelLook new;
		padding: (BlInsets all: 5);
		hFitContent;
		yourself
]

{ #category : #accessing }
GtSmaCCMatchElement >> rewrite [
	^ rewrite
]

{ #category : #accessing }
GtSmaCCMatchElement >> rewrite: aSmaCCRewrite [
	rewrite := aSmaCCRewrite.
	self updateContents
]

{ #category : #private }
GtSmaCCMatchElement >> sourceChanged [
]

{ #category : #private }
GtSmaCCMatchElement >> typeElement [
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

{ #category : #updating }
GtSmaCCMatchElement >> updateContents [
	self removeChildren.
	self
		addChild:
			((self labelFor: 'Search')
				hMatchParent;
				background: (Color veryLightGray alpha: 0.2);
				yourself).
	self addChild: self typeElement.
	editor styler: editor defaultStyler.
	(rewrite match isKindOf: SmaCCRewriteTreeMatch)
		ifTrue: [ self updatePatternMatch ]
		ifFalse: [ self updateTypeMatch ]
]

{ #category : #updating }
GtSmaCCMatchElement >> updatePatternMatch [
	| stateLabel |
	stateLabel := self labelFor: 'State:'.
	self addChild: stateLabel.
	editor text: rewrite match source asRopedText.
	editor text attributes: self defaultTextAttributes.
	self
		addChild:
			(BrEditorElement new
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
				editor: editor;
				yourself)
]

{ #category : #updating }
GtSmaCCMatchElement >> updateTypeMatch [
	| classLabel |
	classLabel := self labelFor: 'Class:'.
	self addChild: classLabel.
	editor text: rewrite match code asRopedText.
	editor text attributes: self defaultTextAttributes.
	editor
		styler:
			(BrRBTextStyler new
				classOrMetaClass: SmaCCRewriteMatchContext;
				workspace: GtHighlightingBindingStrategy new;
				yourself).
	self
		addChild:
			(BrEditorElement new
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
				editor: editor;
				yourself)
]
