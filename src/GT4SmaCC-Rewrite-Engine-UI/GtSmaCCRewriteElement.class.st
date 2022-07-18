Class {
	#name : #GtSmaCCRewriteElement,
	#superclass : #GtSmaCCAbstractRewriteElement,
	#instVars : [
		'matchCode',
		'matchPattern',
		'transformationCode',
		'transformationPattern'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #building }
GtSmaCCRewriteElement >> build [
	| matchLabel matchTabGroup transformationLabel transformationTabGroup |
	super build.
	matchLabel := BrLabel new
			fitContent;
			text: 'Match:'.
	self addChild: matchLabel.
	matchTabGroup := BrTabGroup new
			matchParent;
			margin: (BlInsets bottom: 5);
			aptitude: BrGlamorousTabGroupAptitude + BrShadowAptitude
					+ BrGlamorousWithVerticalResizerAptitude new beBottom;
			background: Color white.
	matchTabGroup
		addTab: (BrTab new
				aptitude: BrGlamorousTabAptitude new;
				label: 'Code';
				stencil: [ self matchCodeElement ]).
	matchTabGroup
		addTab: (BrTab new
				aptitude: BrGlamorousTabAptitude new;
				label: 'Pattern';
				stencil: [ self matchPatternElement ]).
	self addChild: matchTabGroup as: #matchTabGroup.
	transformationLabel := BrLabel new
			fitContent;
			text: 'Transformation:'.
	self addChild: transformationLabel.
	transformationTabGroup := BrTabGroup new
			matchParent;
			margin: (BlInsets top: 5);
			aptitude: BrGlamorousTabGroupAptitude + BrShadowAptitude;
			background: Color white.
	transformationTabGroup
		addTab: (BrTab new
				aptitude: BrGlamorousTabAptitude new;
				label: 'Code';
				stencil: [ self transformationCodeElement ]).
	transformationTabGroup
		addTab: (BrTab new
				aptitude: BrGlamorousTabAptitude new;
				label: 'Pattern';
				stencil: [ self transformationPatternElement ]).
	self addChild: transformationTabGroup as: #transformationTabGroup.
	self updateMatch.
	self updateTransformation.
	matchTabGroup when: BrTabSelectedEvent do: [ :event | self matchTabSwitched ].
	transformationTabGroup
		when: BrTabSelectedEvent
		do: [ :event | self transformationTabSwitched ]
]

{ #category : #private }
GtSmaCCRewriteElement >> format: aString [
	| ast |
	ast := RBParser parseExpression: aString onError: [ :e :p | ^ aString ].
	^ ast formattedCode
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
	| label nodeList editor |
	label := BrLabel new
			margin: (BlInsets top: 5 right: 5);
			fitContent;
			text: 'Match nodes of type:'.
	nodeList := GtSmaCCDropDownList new
			margin: (BlInsets top: 3);
			items: self nodeClasses;
			when: BrSelectionChanged
				do: [ :event | rewrite match nodeClass: event target selectedItem ];
			yourself.
	editor := BrEditor new.
	editor
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		matchParent;
		aptitude: BrGlamorousCodeEditorAptitude new;
		beEditable;
		padding: (BlInsets
				top: 5
				left: 10
				bottom: 5
				right: 10);
		matchParent.
	editor editor
		when: BrTextEditorModifiedEvent
		do: [ :event | rewrite match code: editor editor text asString ].
	editor
		addShortcut: (BlShortcutWithAction new
				combination: BlKeyCombination primaryShiftF;
				action: [ | source |
					source := self format: editor editor text asString.
					rewrite match code: source.
					editor editor text: source asRopedText ]).
	^ BrVerticalPane new
		padding: (BlInsets all: 5);
		matchParent;
		addChild: (BrHorizontalPane new
				margin: (BlInsets bottom: 5);
				vFitContent;
				hMatchParent;
				addChild: label;
				addChild: nodeList as: #nodeList);
		addChild: editor as: #matchCode
]

{ #category : #building }
GtSmaCCRewriteElement >> matchPatternElement [
	| label stateList editor |
	label := BrLabel new
			margin: (BlInsets top: 5 right: 5);
			fitContent;
			text: 'Starting state for parser:'.
	stateList := GtSmaCCDropDownList new
			margin: (BlInsets top: 3);
			items: (rewrite parserClass
					ifNil: [ #() ]
					ifNotNil: [ :cls | #(nil) , cls startingStateNames ]);
			when: BrSelectionChanged
				do: [ :event | rewrite match startingState: event target selectedItem ];
			yourself.
	editor := BrEditor new.
	editor
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		matchParent;
		aptitude: BrGlamorousCodeEditorAptitude new;
		beEditable;
		padding: (BlInsets
				top: 5
				left: 10
				bottom: 5
				right: 10);
		matchParent.
	editor editor
		when: BrTextEditorModifiedEvent
		do: [ :event | rewrite match source: editor editor text asString ].
	^ BrVerticalPane new
		padding: (BlInsets all: 5);
		matchParent;
		addChild: (BrHorizontalPane new
				margin: (BlInsets bottom: 5);
				vFitContent;
				hMatchParent;
				addChild: label;
				addChild: stateList as: #stateList);
		addChild: editor as: #matchPattern
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

{ #category : #building }
GtSmaCCRewriteElement >> nodeClasses [
	| classes parserNodeClasses |
	classes := SmaCCParseNode allSubclasses.
	parserNodeClasses := self parserNodeClasses.
	^ classes
		asSortedCollection:
			[ :a :b | 
			| aSortAtTop |
			(aSortAtTop := parserNodeClasses includes: a) = (parserNodeClasses includes: b)
				ifTrue: [ a name < b name ]
				ifFalse: [ aSortAtTop ] ]
]

{ #category : #building }
GtSmaCCRewriteElement >> parserNodeClasses [
	rewrite parserClass
		ifNotNil:
			[ :pc | 
			pc symbolTypes
				do:
					[ :each | 
					| cls supers |
					(each ~= #SmaCCParseNode and: [ (cls := Smalltalk at: each) includesBehavior: SmaCCParseNode ])
						ifTrue:
							[ supers := cls withAllSuperclasses.
							^ (supers at: supers size - SmaCCParseNode withAllSuperclasses size) withAllSubclasses asSet ] ] ].
	^ #()
]

{ #category : #building }
GtSmaCCRewriteElement >> patternStyler [
	| styler |
	(rewrite parserClass notNil and: [ (styler := rewrite parserClass gtStyler) notNil ]) ifFalse: [ ^ BlTextNullStyler new ].
	styler startingState: rewrite match startingStateIndex.
	styler
		addStylerRule:
			((GtSmaCCNodeStylerRule new)
				nodeClassName: #SmaCCPatternNode;
				styleBlock:
						[ :s | 
							s
								foreground: BrGlamorousColors linkColor;
								bold ]).
	^ styler
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
GtSmaCCRewriteElement >> sourceStyler [
	^ (GtCompositeSmaCCASTStyler forParser: GtPharoParser)
		startingState: GtPharoParser startingStateForMethodSequence;
		stylers:
				{GtSmaCCPharoStyler new.
						GtPharoDynamicHighlightStyler new};
		yourself
]

{ #category : #building }
GtSmaCCRewriteElement >> transformationCodeElement [
	| editor |
	editor := BrEditor new.
	editor
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		matchParent;
		aptitude: BrGlamorousCodeEditorAptitude new;
		beEditable;
		padding:
				(BlInsets
						top: 5
						left: 10
						bottom: 5
						right: 10);
		matchParent.
	editor editor styler: self sourceStyler.
	editor editor when: BrTextEditorModifiedEvent do: [ :event | rewrite transformation code: editor editor text asString ].
	editor
		addShortcut:
			((BlShortcutWithAction new)
				combination: BlKeyCombination primaryShiftF;
				action:
						[ | source |
							source := self format: editor editor text asString.
							rewrite transformation code: source.
							editor editor text: source asRopedText ]).
	^ (BrVerticalPane new)
		padding: (BlInsets all: 5);
		matchParent;
		addChild: editor as: #transformationCode
]

{ #category : #building }
GtSmaCCRewriteElement >> transformationPatternElement [
	| editor |
	editor := BrEditor new.
	editor
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		matchParent;
		aptitude: BrGlamorousCodeEditorAptitude new;
		beEditable;
		padding:
				(BlInsets
						top: 5
						left: 10
						bottom: 5
						right: 10);
		matchParent.
	editor editor when: BrTextEditorModifiedEvent do: [ :event | rewrite transformation string: editor editor text asString ].
	^ (BrVerticalPane new)
		padding: (BlInsets all: 5);
		matchParent;
		addChild: editor as: #transformationPattern
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
GtSmaCCRewriteElement >> update: aSymbol [
	aSymbol = #match ifTrue: [ self updateMatch ].
	aSymbol = #transformation ifTrue: [ self updateTransformation ].
	^ super update: aSymbol
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
		ifTrue:
			[ self childNamed: #stateList ifFound: [ :dropdown | dropdown selectedItem: rewrite match startingState ].
			self
				childNamed: #matchPattern
				ifFound:
					[ :editor | 
					editor editor styler: self patternStyler.
					editor text: rewrite match source asRopedText ] ]
		ifFalse:
			[ self childNamed: #nodeList ifFound: [ :dropdown | dropdown selectedItem: rewrite match nodeClass ].
			self
				childNamed: #matchCode
				ifFound:
					[ :editor | 
					editor editor styler: self sourceStyler.
					editor text: rewrite match code asRopedText ] ]
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
		ifTrue:
			[ self childNamed: #transformationPattern ifFound: [ :editor | editor text: rewrite transformation string asRopedText ] ]
		ifFalse:
			[ self childNamed: #transformationCode ifFound: [ :editor | editor text: rewrite transformation code asRopedText ] ]
]
