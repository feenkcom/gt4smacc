Class {
	#name : #GtSmaCCAmbiguousReduction,
	#superclass : #Object,
	#instVars : [
		'name',
		'stack',
		'index'
	],
	#category : #'GT4SmaCC-Development-UI-Analysis'
}

{ #category : #comparing }
GtSmaCCAmbiguousReduction >> = anObject [
	^ self class = anObject class
		and: [ name = anObject name
				and: [ stack = anObject stack and: [ index = anObject index ] ] ]
]

{ #category : #'as yet unclassified' }
GtSmaCCAmbiguousReduction >> displayText [
	| str |
	str := BlTextStream new.
	str next italic put: name.
	str nextPutAll: ' :'.
	stack
		doWithIndex: [ :each :i | 
			str space.
			(i = index
				ifTrue: [ str next
						attribute: (BlTextHighlightAttribute new paint: BrGlamorousColors textHighlightColor) ]
				ifFalse: [ str ]) print: each ].
	str nextPutAll: ' ;'.
	^ str contents
]

{ #category : #'as yet unclassified' }
GtSmaCCAmbiguousReduction >> gtViewFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Production';
		text: [ self displayText ];
		glamorousCodeFontAndSize
]

{ #category : #comparing }
GtSmaCCAmbiguousReduction >> hash [
	^ ((self class hash hashMultiply bitXor: name hash) hashMultiply
		bitXor: stack hash) hashMultiply bitXor: index hash
]

{ #category : #accessing }
GtSmaCCAmbiguousReduction >> index [
	^ index
]

{ #category : #accessing }
GtSmaCCAmbiguousReduction >> index: anObject [
	index := anObject
]

{ #category : #accessing }
GtSmaCCAmbiguousReduction >> name [
	^ name
]

{ #category : #accessing }
GtSmaCCAmbiguousReduction >> name: anObject [
	name := anObject
]

{ #category : #accessing }
GtSmaCCAmbiguousReduction >> stack [
	^ stack
]

{ #category : #accessing }
GtSmaCCAmbiguousReduction >> stack: anObject [
	stack := anObject
]
