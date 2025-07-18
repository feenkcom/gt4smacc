Class {
	#name : #GtSmaCCAmbiguousAnalysis,
	#superclass : #Object,
	#instVars : [
		'parserClass',
		'duplicatedStates'
	],
	#category : #'GT4SmaCC-Development-UI-Analysis'
}

{ #category : #views }
GtSmaCCAmbiguousAnalysis >> actionNameFor: anInteger id: tokenId [
	| action reduceEntry |
	action := anInteger bitAnd: 2r11.
	action = 2r01 ifTrue: [ ^ 'Shift ' , (self symbolNameFor: tokenId) ].
	action = 2r10
		ifTrue: [ reduceEntry := self parserClass reduceTable at: anInteger >> 2.
			^ 'Reduce ' , (self symbolNameFor: reduceEntry first) , '('
				, reduceEntry second printString , ')' ].
	^ 'other'
]

{ #category : #'as yet unclassified' }
GtSmaCCAmbiguousAnalysis >> addDuplicatesFrom: aParser [
	self duplicatedStates
		add: ((GtSmaCCDuplicatedState on: aParser)
				analysis: self;
				yourself)
]

{ #category : #accessing }
GtSmaCCAmbiguousAnalysis >> duplicatedStates [
	^ duplicatedStates ifNil: [ duplicatedStates := Bag new ]
]

{ #category : #accessing }
GtSmaCCAmbiguousAnalysis >> duplicatedStates: aCollection [
	duplicatedStates := aCollection
]

{ #category : #views }
GtSmaCCAmbiguousAnalysis >> gtActionViewFor: aView [
	<gtView>
	| actions |
	actions := Dictionary new.
	duplicatedStates
		do: [ :each | 
			each actions
				do: [ :action | (actions at: action actionName ifAbsentPut: [ Bag new ]) add: each ] ].
	^ aView columnedList
		title: 'By action';
		items: [ actions associations
				asSortedCollection: [ :a :b | a value size > b value size ] ];
		column: 'Action' text: [ :each | each key ];
		column: 'Count' text: [ :each | each value size ];
		send: [ :each | 
			self copy
				duplicatedStates: each value;
				yourself ]
]

{ #category : #views }
GtSmaCCAmbiguousAnalysis >> gtActionsViewFor: aView [
	<gtView>
	| actions |
	actions := duplicatedStates groupedBy: #actions.
	^ aView columnedList
		title: 'By actions';
		items: [ actions associations
				asSortedCollection: [ :a :b | a value size > b value size ] ];
		column: 'Actions'
			text: [ :each | 
				String
					streamContents: [ :str | each key do: [ :a | a gtDisplayOn: str ] separatedBy: [ str << ', ' ] ] ];
		column: 'Count' text: [ :each | each value size ];
		send: [ :each | 
			self copy
				duplicatedStates: each value;
				yourself ]
]

{ #category : #views }
GtSmaCCAmbiguousAnalysis >> gtStatesAndTokensViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'By stack & token';
		items: [ (duplicatedStates
				groupedBy: [ :e | 
					{e minimizedStack.
						e tokenIds first} ]) associations
				asSortedCollection: [ :a :b | a value size > b value size ] ];
		column: 'Token' text: [ :each | self symbolNameFor: each key second ];
		column: 'State' text: [ :each | each key first last ];
		column: 'Stack size' text: [ :each | each key first size ];
		column: 'Count' text: [ :each | each value size ];
		send: [ :each | each value any ]
]

{ #category : #views }
GtSmaCCAmbiguousAnalysis >> gtTokensViewFor: aView [
	<gtView>
	^ aView columnedList
		title: 'By token';
		items: [ (duplicatedStates groupedBy: [ :e | e tokenIds first ]) associations
				asSortedCollection: [ :a :b | a value size > b value size ] ];
		column: 'Token' text: [ :each | self symbolNameFor: each key ];
		column: 'Count' text: [ :each | each value size ];
		send: [ :each | 
			self copy
				duplicatedStates: each value;
				yourself ]
]

{ #category : #views }
GtSmaCCAmbiguousAnalysis >> gtViewFor: aView [
	<gtView>
	| any |
	any := duplicatedStates any.
	duplicatedStates
		detect: [ :each | (any isSimilarTo: each) not ]
		ifFound: [ :each | ^ aView empty ].
	^ aView forward
		priority: 1;
		title: 'Traces';
		object: [ duplicatedStates any ];
		view: #gtTracesFor:
]

{ #category : #accessing }
GtSmaCCAmbiguousAnalysis >> parserClass [
	^ parserClass
]

{ #category : #accessing }
GtSmaCCAmbiguousAnalysis >> parserClass: anObject [
	parserClass := anObject
]

{ #category : #views }
GtSmaCCAmbiguousAnalysis >> symbolNameFor: id [
	^ self parserClass symbolNames at: id
]
