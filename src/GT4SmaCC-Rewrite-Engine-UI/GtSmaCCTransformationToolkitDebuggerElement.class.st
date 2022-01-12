Class {
	#name : #GtSmaCCTransformationToolkitDebuggerElement,
	#superclass : #GtDebuggerElement,
	#classInstVars : [
		'availableAutomatically'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #accessing }
GtSmaCCTransformationToolkitDebuggerElement class >> availableAutomatically [
	^ availableAutomatically ifNil: [ true ]
]

{ #category : #accessing }
GtSmaCCTransformationToolkitDebuggerElement class >> availableAutomatically: aBoolean [
	availableAutomatically := aBoolean
]

{ #category : #accessing }
GtSmaCCTransformationToolkitDebuggerElement class >> defaultTitle [
	^ 'SmaCCTransformations'
]

{ #category : #testing }
GtSmaCCTransformationToolkitDebuggerElement class >> handlesContext: aContext [
	^ SmaCCTransformationToolkitDebugSession handlesContext: aContext
]

{ #category : #'class initialization' }
GtSmaCCTransformationToolkitDebuggerElement class >> initialize [
	self register
]

{ #category : #'tools registry' }
GtSmaCCTransformationToolkitDebuggerElement class >> registerToolsOn: registry [
	registry registerDebugger: self withRank: 1100.
]

{ #category : #accessing }
GtSmaCCTransformationToolkitDebuggerElement class >> sessionClass [
	^ SmaCCTransformationToolkitDebugSession
]

{ #category : #callbacks }
GtSmaCCTransformationToolkitDebuggerElement >> actOnDebugSessionChanged [
	self buildUI
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> buildUI [
	self removeChildren.
	self addChild: self tabGroupElement.
	self updateStack.
	self updateOriginalSource.
	self updateNewSource.
	self updateCode
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> codeObjectForSelection: anArray [
	(anArray first isKindOf: SmaCCRewriteMethodDefinition)
		ifTrue: [ ^ anArray first ].
	^ (self isTransformation: anArray)
		ifTrue: [ anArray first transformation ]
		ifFalse: [ anArray first match ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> detailsElement [
	| element top bottom |
	element := (BrVerticalPane new)
		padding: (BlInsets all: 5);
		matchParent.
	top := (BrHorizontalPane new)
		height: 250;
		hMatchParent;
		aptitude: BrGlamorousWithVerticalResizerAptitude new beBottom.
	top addChild: self stackElement.
	top addChild: self sourceElement as: #code.
	top addChild: self inspectorElement.
	bottom := BrHorizontalPane new matchParent.
	bottom addChild: self originalSourceElement as: #originalSource.
	bottom addChild: self newSourceElement as: #newSource.
	element
		addChild: top;
		addChild: bottom.
	^ element
]

{ #category : #initialization }
GtSmaCCTransformationToolkitDebuggerElement >> initialize [
	super initialize.
	self
		layout: BlLinearLayout vertical;
		constraintsDo: [ :c | 
			c horizontal matchParent.
			c vertical matchParent ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> inspectorElement [
	| list |
	list := (BrColumnedList new)
		margin: (BlInsets all: 5);
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		matchParent.
	^ (BlElement new)
		aptitude: BrGlamorousWithHorizontalResizerAptitude new beLeft;
		margin: (BlInsets all: 5);
		width: 200;
		constraintsDo: [ :c | c vertical matchParent ];
		addChild: list as: #inspector;
		yourself
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> isTransformation: selection [
	^ selection first transformation method == selection last method
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> newSourceElement [
	^ (BrEditor new)
		margin: (BlInsets all: 5);
		matchParent;
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1)
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> originalSourceElement [
	^ (BrEditor new)
		margin: (BlInsets all: 5);
		matchParent;
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1)
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> sourceElement [
	^ (BrEditor new)
		margin: (BlInsets all: 5);
		matchParent;
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1)
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> sourceForSelection: anArray [
	anArray isNil
		ifTrue: [ ^ '' ].
	^ (self codeObjectForSelection: anArray) source
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> stackElement [
	| list |
	list := (BrSimpleList new)
		border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
		matchParent;
		when: BrSelectionChanged do: [ :event | self updateCode ];
		itemStencil:
				[ (BrLabel new)
						vFitContent;
						hMatchParent;
						aptitude: BrGlamorousLabelAptitude + BrGlamorousListItemAptitude;
						padding: (BlInsets all: 3) ];
		itemDataBinder:
				[ :label :each | 
					| isBlock |
					isBlock := each last isBlockContext.
					label
						text: (isBlock ifTrue: [ '[' ] ifFalse: [ '' ]) , each first displayString , (isBlock ifTrue: [ ']' ] ifFalse: [ '' ]) ].
	^ (BlElement new)
		aptitude: BrGlamorousWithHorizontalResizerAptitude new beRight;
		margin: (BlInsets all: 5);
		width: 200;
		constraintsDo: [ :c | c vertical matchParent ];
		addChild: list as: #stack;
		yourself
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> stackSelection [
	self childNamed: #stack ifFound: [ :list | list selectedItemDo: [ :each | ^ each ] ].
	^ nil
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> tabGroupElement [
	| tab tabGroup |
	tab := BrTab new.
	tab
		aptitude: BrGlamorousTabWithoutBarAptitude;
		label: self session name;
		stencil: [ self detailsElement ];
		padding:
				(BlInsets
						top: 15
						right: 0
						bottom: 15
						left: 10);
		toolbarStencil:
				[ | aToolbar |
					aToolbar := BrToolbar new.
					aToolbar aptitude: BrGlamorousToolbarAptitude new.
					self toolbarButtons do: [ :anAction | aToolbar addItem: anAction ].
					aToolbar ].
	tabGroup := BrTabGroup new.
	tabGroup
		aptitude: (BrGlamorousTabGroupAptitude new headerBackground: self theme header defaultBackgroundColor);
		addTab: tab;
		matchParent;
		addChild:
				((BlElement new)
						constraintsDo:
								[ :c | 
									c ignoreByLayout.
									c horizontal matchParent.
									c vertical exact: 5 ];
						background: self theme status errorBackgroundColor;
						yourself).
	^ tabGroup
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> toolbarButtons [
	| buttons |
	buttons := (self actionsForPragmas: #(gtSmaCCTransformationStack))
		collect:
			[ :aDebuggingAction | 
			| actionButton |
			actionButton := (BrButton new)
				aptitude: BrGlamorousButtonWithIconAptitude;
				label: aDebuggingAction label;
				action:
						[ aDebuggingAction execute.
							self halt.
							aDebuggingAction needsUpdate ifTrue: [ self updateContents ] ].
			aDebuggingAction icon ifNotNil: [ :anIcon | actionButton icon: aDebuggingAction icon asElement ].
			actionButton ].
	^ buttons
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> updateCode [
	self childNamed: #code ifFound: [ :editor | editor editor text: (self sourceForSelection: self stackSelection) asRopedText ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> updateNewSource [
	self childNamed: #newSource ifFound: [ :editor | editor editor text: self session newSource asRopedText ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> updateOriginalSource [
	self childNamed: #originalSource ifFound: [ :editor | editor editor text: self session originalSource asRopedText ]
]

{ #category : #ui }
GtSmaCCTransformationToolkitDebuggerElement >> updateStack [
	self
		childNamed: #stack
		ifFound:
			[ :list | 
			| stream |
			stream := ((GtSmaCCTransformationStackStream onContext: debuggingSession context)
				collect:
					[ :each | 
					{debuggingSession rewriteForContext: each.
						each} ]) select: [ :each | each first notNil ].
			list
				itemsProvider:
					((BrListStreamItemsProvider new)
						stream: stream asyncSimilarCopy;
						preloadAmount: 1).
			list selectOne: 1 ]
]
