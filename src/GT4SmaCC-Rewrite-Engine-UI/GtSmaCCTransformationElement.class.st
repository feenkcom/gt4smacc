Class {
	#name : #GtSmaCCTransformationElement,
	#superclass : #BlElement,
	#instVars : [
		'rewrite',
		'editor'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'instance creation' }
GtSmaCCTransformationElement class >> rewrite: aSmaCCRewrite [
	^ self new
		rewrite: aSmaCCRewrite;
		yourself
]

{ #category : #private }
GtSmaCCTransformationElement >> defaultTextAttributes [
	^ {BlFontGenericFamilyAttribute monospace beNotOverwritableByStyler.
	(BlFontSizeAttribute size: 14) beNotOverwritableByStyler}
]

{ #category : #'initialize-release' }
GtSmaCCTransformationElement >> initialize [
	super initialize.
	self look: BrLayoutLook linearVertical vFitContent hMatchParent.
	editor := BrTextEditor new.
	editor
		when: BrTextEditorInsertedEvent do: [ :event | self sourceChanged ];
		when: BrTextEditorDeletedEvent do: [ :event | self sourceChanged ]
]

{ #category : #private }
GtSmaCCTransformationElement >> labelFor: aString [
	^ BrLabel new
		text: aString;
		look: BrGlamorousLabelLook new;
		padding: (BlInsets all: 5);
		hFitContent;
		yourself
]

{ #category : #accessing }
GtSmaCCTransformationElement >> rewrite [
	^ rewrite
]

{ #category : #accessing }
GtSmaCCTransformationElement >> rewrite: aSmaCCRewrite [
	rewrite := aSmaCCRewrite.
	self updateContents
]

{ #category : #private }
GtSmaCCTransformationElement >> sourceChanged [
]

{ #category : #private }
GtSmaCCTransformationElement >> typeElement [
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

{ #category : #updating }
GtSmaCCTransformationElement >> updateCodeTransformation [
	editor text: rewrite transformation code asRopedText.
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

{ #category : #updating }
GtSmaCCTransformationElement >> updateContents [
	self removeChildren.
	self
		addChild:
			((self labelFor: 'Replace')
				hMatchParent;
				background: (Color veryLightGray alpha: 0.2);
				yourself).
	self addChild: self typeElement.
	editor styler: editor defaultStyler.
	(rewrite transformation isKindOf: SmaCCRewriteCodeTransformation)
		ifTrue: [ self updateCodeTransformation ]
		ifFalse: [ self updateStringTransformation ]
]

{ #category : #updating }
GtSmaCCTransformationElement >> updateStringTransformation [
	editor text: rewrite transformation string asRopedText.
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
