Class {
	#name : #GtSmaCCRewriteElement,
	#superclass : #GtSmaCCAbstractRewriteElement,
	#instVars : [
		'matchCode',
		'matchPattern',
		'transformationCode',
		'transformationPattern',
		'transformationCodeElement',
		'matchCodeElement',
		'transformationPatternElement',
		'matchPatternElement'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #building }
GtSmaCCRewriteElement >> build [
	| matchLabel matchTabGroup transformationLabel transformationTabGroup |
	super build.
	matchLabel := (BrLabel new)
		fitContent;
		aptitude: BrGlamorousLabelAptitude new;
		text: 'Match:'.
	self addChild: matchLabel.
	matchTabGroup := (BrTabGroup new)
		matchParent;
		margin: (BlInsets bottom: 5);
		aptitude: BrGlamorousTabGroupAptitude + BrShadowAptitude + BrGlamorousWithVerticalResizerAptitude new beBottom;
		background: Color white.
	matchTabGroup
		addTab:
			((BrTab new)
				aptitude: BrGlamorousTabAptitude new;
				label: 'Code';
				stencil: [ self matchCodeElement ]).
	matchTabGroup
		addTab:
			((BrTab new)
				aptitude: BrGlamorousTabAptitude new;
				label: 'Pattern';
				stencil: [ self matchPatternElement ]).
	self addChild: matchTabGroup as: #matchTabGroup.
	transformationLabel := (BrLabel new)
		fitContent;
		aptitude: BrGlamorousLabelAptitude new;
		text: 'Transformation:'.
	self addChild: transformationLabel.
	transformationTabGroup := (BrTabGroup new)
		matchParent;
		margin: (BlInsets top: 5);
		aptitude: BrGlamorousTabGroupAptitude + BrShadowAptitude;
		background: Color white.
	transformationTabGroup
		addTab:
			((BrTab new)
				aptitude: BrGlamorousTabAptitude new;
				label: 'Code';
				stencil: [ self transformationCodeElement ]).
	transformationTabGroup
		addTab:
			((BrTab new)
				aptitude: BrGlamorousTabAptitude new;
				label: 'Pattern';
				stencil: [ self transformationPatternElement ]).
	self addChild: transformationTabGroup as: #transformationTabGroup.
	self updateMatch.
	self updateTransformation.
	matchTabGroup when: BrTabSelectedEvent do: [ :event | self matchTabSwitched ].
	transformationTabGroup when: BrTabSelectedEvent do: [ :event | self transformationTabSwitched ]
]

{ #category : #private }
GtSmaCCRewriteElement >> connectModel [
	super connectModel.
	rewrite ifNil: [ ^ self ].
	rewrite announcer weak
		when: #match
			send: #updateMatch
			to: self;
		when: #transformation
			send: #updateTransformation
			to: self
]

{ #category : #initialization }
GtSmaCCRewriteElement >> initialize [
	super initialize.
	matchCode := SmaCCRewriteTypeMatch new.
	matchPattern := SmaCCRewriteTreeMatch new.
	transformationCode := SmaCCRewriteCodeTransformation new.
	transformationPattern := SmaCCRewriteStringTransformation new
]

{ #category : #building }
GtSmaCCRewriteElement >> matchCodeElement [
	^ matchCodeElement ifNil: [ matchCodeElement := GtSmaCCMatchCodeElement new ]
]

{ #category : #building }
GtSmaCCRewriteElement >> matchPatternElement [
	^ matchPatternElement
		ifNil: [ matchPatternElement := GtSmaCCPatternMatchElement new ]
]

{ #category : #building }
GtSmaCCRewriteElement >> matchTabSwitched [
	self
		childNamed: #matchTabGroup
		ifFound:
			[ :tg | 
			tg viewModel selectedTab == tg tabs first
				ifTrue:
					[ rewrite match class type = #Pattern
						ifTrue:
							[ matchPattern := rewrite match copy.
							rewrite match: matchCode ] ]
				ifFalse:
					[ rewrite match class type ~= #Pattern
						ifTrue:
							[ matchCode := rewrite match copy.
							rewrite match: matchPattern ] ] ]
]

{ #category : #accessing }
GtSmaCCRewriteElement >> rewrite: aRewrite [
	super rewrite: aRewrite.
	rewrite notNil
		ifTrue:
			[ rewrite match class type = #Pattern ifTrue: [ matchPattern := rewrite match ] ifFalse: [ matchCode := rewrite match ].
			rewrite transformation class type = #String
				ifTrue: [ transformationPattern := rewrite transformation ]
				ifFalse: [ transformationCode := rewrite transformation ] ]
]

{ #category : #building }
GtSmaCCRewriteElement >> transformationCodeElement [
	^ transformationCodeElement
		ifNil: [ transformationCodeElement := GtSmaCCCodeElement new ]
]

{ #category : #building }
GtSmaCCRewriteElement >> transformationPatternElement [
	^ transformationPatternElement
		ifNil: [ transformationPatternElement := GtSmaCCPatternElement new ]
]

{ #category : #building }
GtSmaCCRewriteElement >> transformationTabSwitched [
	self
		childNamed: #transformationTabGroup
		ifFound:
			[ :tg | 
			tg viewModel selectedTab == tg tabs first
				ifTrue:
					[ rewrite transformation class type = #String
						ifTrue:
							[ transformationPattern := rewrite transformation copy.
							rewrite transformation: transformationCode ] ]
				ifFalse:
					[ rewrite transformation class type ~= #String
						ifTrue:
							[ transformationCode := rewrite transformation copy.
							rewrite transformation: transformationPattern ] ] ]
]

{ #category : #updating }
GtSmaCCRewriteElement >> updateMatch [
	self
		childNamed: #matchTabGroup
		ifFound:
			[ :tg | 
			tg viewModel selectedTab == tg tabs first
				ifTrue: [ rewrite match class type = #Pattern ifTrue: [ tg viewModel selectTab: tg tabs last ] ]
				ifFalse: [ rewrite match class type ~= #Pattern ifTrue: [ tg viewModel selectTab: tg tabs first ] ].
			self updateMatchContents ]
]

{ #category : #updating }
GtSmaCCRewriteElement >> updateMatchContents [
	rewrite match class type = #Pattern
		ifTrue: [ self matchPatternElement model: rewrite match ]
		ifFalse: [ self matchCodeElement model: rewrite match ]
]

{ #category : #updating }
GtSmaCCRewriteElement >> updateTransformation [
	self
		childNamed: #transformationTabGroup
		ifFound:
			[ :tg | 
			tg viewModel selectedTab == tg tabs first
				ifTrue: [ rewrite transformation class type = #String ifTrue: [ tg viewModel selectTab: tg tabs last ] ]
				ifFalse: [ rewrite transformation class type ~= #String ifTrue: [ tg viewModel selectTab: tg tabs first ] ].
			self updateTransformationContents ]
]

{ #category : #updating }
GtSmaCCRewriteElement >> updateTransformationContents [
	rewrite transformation class type = #String
		ifTrue: [ self transformationPatternElement model: rewrite transformation ]
		ifFalse: [ self transformationCodeElement model: rewrite transformation ]
]
