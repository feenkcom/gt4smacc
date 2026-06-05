Class {
	#name : #GtSmaCCAmbiguousFilter,
	#superclass : #GtSmaCCDefinitionsFilter,
	#instVars : [
		'lookaheads',
		'shiftNames',
		'reductionNames',
		'path',
		'count'
	],
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #'instance creation' }
GtSmaCCAmbiguousFilter class >> from: ambiguousActionIssue [
	| shiftNames reductionNames lookaheads |
	shiftNames := Dictionary new.
	reductionNames := Dictionary new.
	ambiguousActionIssue action actions
		do: [ :each | 
			| names |
			names := each isShift ifTrue: [ shiftNames ] ifFalse: [ reductionNames ].
			each symbol isExplicitlyDefined
				ifTrue: [ names at: each symbol name put: each symbol name ]
				ifFalse: [ (each symbol usedBy collect: #name)
						do: [ :symbol | names at: symbol put: each symbol name ] ] ].
	lookaheads := ambiguousActionIssue lookaheadTokens collect: #name.
	^ self new
		shiftNames: shiftNames;
		reductionNames: reductionNames;
		path: (ambiguousActionIssue action actions anyOne lr1Item path collect: #name);
		lookaheads: lookaheads;
		yourself
]

{ #category : #'instance creation' }
GtSmaCCAmbiguousFilter class >> merged: aCollection [
	^ self new
		shiftNames: aCollection anyOne shiftNames;
		reductionNames: aCollection anyOne reductionNames;
		path: aCollection anyOne path;
		count: (aCollection inject: 0 into: [ :sum :each | sum + each count ]);
		lookaheads: (aCollection
				inject: Set new
				into: [ :sum :each | 
					sum
						addAll: each lookaheads;
						yourself ]);
		yourself
]

{ #category : #testing }
GtSmaCCAmbiguousFilter >> canBeMergedWith: otherFilter [
	self shiftNames size = otherFilter shiftNames size ifFalse: [ ^ false ].
	self reductionNames size = otherFilter reductionNames size ifFalse: [ ^ false ].
	self path = otherFilter path ifFalse: [ ^ false ].
	otherFilter shiftNames
		keysAndValuesDo: [ :key :value | (self shiftNames at: key ifAbsent: [ ^ false ]) = value ifFalse: [ ^ false ] ].
	otherFilter reductionNames
		keysAndValuesDo: [ :key :value | (self reductionNames at: key ifAbsent: [ ^ false ]) = value ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #accessing }
GtSmaCCAmbiguousFilter >> count [
	^ count ifNil: [ 1 ]
]

{ #category : #accessing }
GtSmaCCAmbiguousFilter >> count: anObject [
	count := anObject
]

{ #category : #accessing }
GtSmaCCAmbiguousFilter >> lookaheads [
	^ lookaheads
]

{ #category : #accessing }
GtSmaCCAmbiguousFilter >> lookaheads: anObject [
	lookaheads := anObject
]

{ #category : #testing }
GtSmaCCAmbiguousFilter >> matches: anObject [
	(anObject isKindOf: GtSmaCCGrammarItem) ifFalse: [ ^ false ].
	^ (self reductionNames includesKey: anObject name)
		or: [ self shiftNames includesKey: anObject name ]
]

{ #category : #accessing }
GtSmaCCAmbiguousFilter >> path [
	^ path
]

{ #category : #accessing }
GtSmaCCAmbiguousFilter >> path: anObject [
	path := anObject
]

{ #category : #accessing }
GtSmaCCAmbiguousFilter >> reductionNames [
	^ reductionNames
]

{ #category : #accessing }
GtSmaCCAmbiguousFilter >> reductionNames: anObject [
	reductionNames := anObject
]

{ #category : #accessing }
GtSmaCCAmbiguousFilter >> shiftNames [
	^ shiftNames
]

{ #category : #accessing }
GtSmaCCAmbiguousFilter >> shiftNames: anObject [
	shiftNames := anObject
]
