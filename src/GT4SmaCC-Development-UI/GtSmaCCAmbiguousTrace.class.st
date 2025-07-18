Class {
	#name : #GtSmaCCAmbiguousTrace,
	#superclass : #Object,
	#instVars : [
		'stack',
		'duplicatedState'
	],
	#category : #'GT4SmaCC-Development-UI-Analysis'
}

{ #category : #accessing }
GtSmaCCAmbiguousTrace class >> performAction: anInteger forStack: aStateStack duplicatedState: aDuplicatedState traces: traces [
	| action reduction |
	action := anInteger bitAnd: 2r11.
	action ~= 2r10
		ifTrue: [ ^ traces
				add: (GtSmaCCAmbiguousTrace new
						duplicatedState: aDuplicatedState;
						stack: (aStateStack copyWith: anInteger >> 2);
						yourself) ].
	reduction := aDuplicatedState parserClass reduceTable at: anInteger >> 2.
	reduction second timesRepeat: [ aStateStack removeLast ].
	aStateStack
		addLast: (((aDuplicatedState parserClass new stateStack: aStateStack)
				actionFor: reduction first) bitShift: -2).
	self
		trace: aStateStack
		duplicatedState: aDuplicatedState
		traces: traces
]

{ #category : #accessing }
GtSmaCCAmbiguousTrace class >> trace: aStateStack duplicatedState: aDuplicatedState traces: traces [
	| parser actions |
	parser := aDuplicatedState parserClass new stateStack: aStateStack.
	parser
		currentToken: (SmaCCToken
				value: ''
				start: 1
				ids: aDuplicatedState tokenIds).
	actions := SmaCCGLRParser >> #actionsForCurrentToken
			valueWithReceiver: parser
			arguments: #().
	actions isEmpty ifTrue: [ ^ self ].
	actions size > 1
		ifTrue: [ 2
				to: actions size
				do: [ :i | 
					self
						performAction: (actions at: i)
						forStack: aStateStack copy
						duplicatedState: aDuplicatedState
						traces: traces ] ].
	self
		performAction: actions first
		forStack: aStateStack
		duplicatedState: aDuplicatedState
		traces: traces
]

{ #category : #accessing }
GtSmaCCAmbiguousTrace class >> tracesFor: aDuplicatedState [
	| traces |
	traces := OrderedCollection new.
	self
		trace: (OrderedCollection withAll: aDuplicatedState stateStack)
		duplicatedState: aDuplicatedState
		traces: traces.
	^ traces
]

{ #category : #accessing }
GtSmaCCAmbiguousTrace >> duplicatedState [
	^ duplicatedState
]

{ #category : #accessing }
GtSmaCCAmbiguousTrace >> duplicatedState: anObject [
	duplicatedState := anObject
]

{ #category : #'as yet unclassified' }
GtSmaCCAmbiguousTrace >> gtGraphViewFor: aView [
	<gtView>
	^ aView forward
		title: 'Graph';
		object: [ self parserClass new
				stateStack: stack;
				yourself ];
		view: #gtGraphViewIn:
]

{ #category : #'as yet unclassified' }
GtSmaCCAmbiguousTrace >> parserClass [
	^ duplicatedState parserClass
]

{ #category : #'as yet unclassified' }
GtSmaCCAmbiguousTrace >> reductions [
	| reductions returnTable parser |
	parser := self parserClass new stateStack: stack copy.
	reductions := OrderedCollection new.
	returnTable := parser maxReturnSizeTable.
	self
		saveReductionsFrom: parser
		returnTable: returnTable
		position: stack size - 1
		into: reductions.
	^ reductions
]

{ #category : #'as yet unclassified' }
GtSmaCCAmbiguousTrace >> saveReductionsFrom: parser returnTable: returnTable position: anInteger into: reductions [
	| actions groupedActions reduceActions size |
	size := parser stateStack size - anInteger.
	actions := OrderedCollection new.
	parser actionsDo: [ :each | actions add: each ].
	groupedActions := actions groupedBy: [ :each | each bitAnd: 2r11 ].
	(groupedActions includesKey: 0) ifTrue: [ ^ self ].
	reduceActions := (((groupedActions at: 2r10 ifAbsent: [ #() ])
			collect: [ :each | parser reduceTable at: each >> 2 ])
			reject: [ :each | each second < size ])
			asSortedCollection: [ :a :b | a second > b second ].
	reduceActions notEmpty
		ifTrue: [ | reduction reductionStack state nextState entry |
			reduction := GtSmaCCAmbiguousReduction new.
			reductionStack := OrderedCollection new.
			entry := reduceActions first.
			entry second
				timesRepeat: [ state := parser stateStack removeLast.
					reductionStack
						addFirst: (parser symbolForTransitionFrom: parser stateStack last to: state) ].
			nextState := (parser actionForState: parser stateStack last and: entry first)
					>> 2.
			reduction index: anInteger - parser stateStack size + 1.
			reduction
				name: (parser symbolForTransitionFrom: parser stateStack last to: nextState).
			parser stateStack add: nextState.
			reduction stack: reductionStack.
			reductions addFirst: reduction.
			^ self
				saveReductionsFrom: parser
				returnTable: returnTable
				position: (parser stateStack size - 1 min: anInteger)
				into: reductions ].
	((groupedActions at: 2r01 ifAbsent: [ #() ])
		asSortedCollection: [ :a :b | (returnTable at: a >> 2) > (returnTable at: b >> 2) ])
		do: [ :each | 
			((returnTable at: each >> 2) > size or: [ parser isAcceptState: each >> 2 ])
				ifTrue: [ parser stateStack add: each >> 2.
					^ self
						saveReductionsFrom: parser
						returnTable: returnTable
						position: anInteger
						into: reductions ] ]
]

{ #category : #accessing }
GtSmaCCAmbiguousTrace >> stack [
	^ stack
]

{ #category : #accessing }
GtSmaCCAmbiguousTrace >> stack: anObject [
	stack := anObject
]
