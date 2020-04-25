Class {
	#name : #GtSmaCCASTQuery,
	#superclass : #Object,
	#category : #'GT4SmaCC-Inspector'
}

{ #category : #'instance creation' }
GtSmaCCASTQuery class >> parse: aString caseSensitive: aBoolean [
	| parts tokenQuery search propertyName index |
	aString trim isEmpty
		ifTrue: [ ^ GtSmaCCNullQuery new ].
	(aString includes: $ )
		ifTrue: [ ^ GtSmaCCAndQuery new
				queries:
					((aString substrings: ' ')
						collect: [ :each | self parse: each caseSensitive: aBoolean ]) ].
	parts := aString substrings: '/'.
	aString trim last = $/
		ifTrue: [ parts := parts copyWith: '' ].
	tokenQuery := parts last.
	index := tokenQuery indexOf: $:.
	index > 0
		ifTrue: [ search := tokenQuery allButFirst: index.
			propertyName := tokenQuery first: index - 1 ]
		ifFalse: [ search := tokenQuery.
			propertyName := '' ].
	^ parts allButLast reversed
		inject:
			(GtSmaCCTokenQuery new
				caseSensitive: aBoolean;
				propertyName: propertyName;
				search: search)
		into: [ :sum :each | 
			GtSmaCCParentQuery new
				parentType: each;
				query: sum;
				caseSensitive: aBoolean ]
]

{ #category : #applying }
GtSmaCCASTQuery >> applyOn: aNode [
	^ nil
]
