Class {
	#name : #GtSmaCCQuery,
	#superclass : #Object,
	#category : #'GT4SmaCC-Queries'
}

{ #category : #querying }
GtSmaCCQuery >> does: aName match: aString [
	^ aName isSymbol
		ifTrue: [ aName sameContentAs: aString ]
		ifFalse: [ aName isEmpty
				or: [ (aString
						findString: aName
						startingAt: 1
						caseSensitive: false) > 0 ] ]
]
