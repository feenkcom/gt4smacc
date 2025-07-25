Class {
	#name : #GtSmaCCDuplicatedState,
	#superclass : #Object,
	#instVars : [
		'stateStack',
		'actions',
		'tokenIds',
		'analysis',
		'minimizedStack'
	],
	#category : #'GT4SmaCC-Development-UI-Analysis'
}

{ #category : #'instance creation' }
GtSmaCCDuplicatedState class >> on: aParser [
	^ self new
		stateStack: (Array withAll: aParser stateStack);
		tokenIds: aParser currentToken ids;
		actions: ((SmaCCGLRParser >> #actionsForCurrentToken
				valueWithReceiver: aParser
				arguments: #())
				collect: [ :each | GtSmaCCAmbiguousAction fromAction: each in: aParser ]);
		yourself
]

{ #category : #comparing }
GtSmaCCDuplicatedState >> = anObject [
	^ self class = anObject class
		and: [ self actions = anObject actions
				and: [ self stateStack = anObject stateStack
						and: [ self tokenIds = anObject tokenIds ] ] ]
]

{ #category : #accessing }
GtSmaCCDuplicatedState >> actions [
	^ actions
]

{ #category : #accessing }
GtSmaCCDuplicatedState >> actions: anObject [
	actions := anObject
]

{ #category : #accessing }
GtSmaCCDuplicatedState >> analysis [
	^ analysis
]

{ #category : #accessing }
GtSmaCCDuplicatedState >> analysis: anObject [
	analysis := anObject
]

{ #category : #views }
GtSmaCCDuplicatedState >> gtActionsFor: aView [
	<gtView>
	^ aView forward
		title: 'Actions';
		object: [ actions ];
		view: #gtItemsFor:
]

{ #category : #views }
GtSmaCCDuplicatedState >> gtGraphViewFor: aView [
	<gtView>
	^ aView forward
		title: 'Graph';
		object: [ self parserClass new
				stateStack: self stateStack;
				yourself ];
		view: #gtGraphViewIn:
]

{ #category : #views }
GtSmaCCDuplicatedState >> gtTracesFor: aView context: aDictionary [
	<gtView>
	| index coder |
	self parserClass
		ifNotNil: [ :parserClass | 
			parserClass parserDefinitionString isEmpty
				ifFalse: [ coder := aDictionary
							at: #coder
							ifAbsentPut: [ GtSmaCCGrammarCoder onParser: parserClass ] ] ].
	index := SmallInteger maxVal.
	^ aView tree
		title: 'Traces';
		priority: 10;
		items: [ | traces reductions |
			traces := GtSmaCCAmbiguousTrace tracesFor: self.
			reductions := traces collect: #reductions.
			index := reductions
					inject: index
					into: [ :sum :each | 
						((1 to: (sum min: each size))
							detect: [ :i | (reductions first at: i) ~= (each at: i) ]
							ifNone: [ (sum min: each size) + 1 ]) - 1 ].
			reductions collect: [ :each | each reversed ] ];
		children: [ :each | each size > 1 ifTrue: [ {each allButFirst} ] ifFalse: [ #() ] ];
		itemStencil: [ :each | 
			| editor |
			editor := BrEditor new.
			editor hMatchParent.
			editor vFitContentLimited.
			editor aptitude: BrGlamorousCodeEditorAptitude.
			editor beReadOnlyWithoutSelection.
			editor
				removeEventHandlersSuchThat: [ :handler | 
					(handler isKindOf: BlEventHandler)
						and: [ handler eventClass = BlMouseUpEvent or: [ handler eventClass = BlClickEvent ] ] ].
			editor ];
		itemDataBinder: [ :editor :each :i | 
			| text |
			text := each first displayText.
			each size <= index
				ifTrue: [ text foreground: BrGlamorousColors disabledHeaderTextColor ].
			editor editor text: text ];
		send: [ :each | 
			| item |
			item := coder
					ifNotNil: [ each detect: [ :e | (coder ruleNamed: e name) notNil ] ifNone: [  ] ].
			item
				ifNotNil: [ (GtSmaCCGrammarFilter on: coder)
						& (GtSmaCCDefinitionImplementorFilter pattern: item name) ] ]
]

{ #category : #comparing }
GtSmaCCDuplicatedState >> hash [
	^ ((self class hash hashMultiply bitXor: self actions hash) hashMultiply
		bitXor: self stateStack hash) hashMultiply bitXor: self tokenIds hash
]

{ #category : #comparing }
GtSmaCCDuplicatedState >> isSimilarTo: anObject [
	^ self actions = anObject actions
		and: [ self tokenIds = anObject tokenIds
				and: [ self minimizedStack = anObject minimizedStack ] ]
]

{ #category : #views }
GtSmaCCDuplicatedState >> minimizeStack: aStack from: anIndex [
	| lastIndex newStack |
	anIndex > aStack size ifTrue: [ ^ aStack ].
	lastIndex := aStack lastIndexOf: (aStack at: anIndex).
	newStack := lastIndex ~= anIndex
			ifTrue: [ (aStack first: anIndex) , (aStack allButFirst: lastIndex) ]
			ifFalse: [ aStack ].
	^ self minimizeStack: newStack from: anIndex + 1
]

{ #category : #views }
GtSmaCCDuplicatedState >> minimizedStack [
	^ minimizedStack
		ifNil: [ minimizedStack := self minimizeStack: stateStack from: 1 ]
]

{ #category : #accessing }
GtSmaCCDuplicatedState >> parserClass [
	^ analysis parserClass
]

{ #category : #accessing }
GtSmaCCDuplicatedState >> stateStack [
	^ stateStack
]

{ #category : #accessing }
GtSmaCCDuplicatedState >> stateStack: anObject [
	stateStack := anObject
]

{ #category : #accessing }
GtSmaCCDuplicatedState >> tokenIds [
	^ tokenIds
]

{ #category : #accessing }
GtSmaCCDuplicatedState >> tokenIds: anObject [
	tokenIds := anObject
]
