Class {
	#name : #GtSmaCCTokenQuery,
	#superclass : #GtSmaCCASTQuery,
	#instVars : [
		'propertyName',
		'search',
		'caseSensitive'
	],
	#category : #'GT4SmaCC-Inspector'
}

{ #category : #applying }
GtSmaCCTokenQuery >> applyOn: aNode [
	self
		tokensOf: aNode
		do: [ :token | 
			(search isEmpty
				or: [ (token value
						findString: search
						startingAt: 1
						caseSensitive: self caseSensitive) > 0 ])
				ifTrue: [ ^ aNode ] ].
	^ nil
]

{ #category : #accessing }
GtSmaCCTokenQuery >> caseSensitive [
	^ caseSensitive
]

{ #category : #accessing }
GtSmaCCTokenQuery >> caseSensitive: aBoolean [
	caseSensitive := aBoolean
]

{ #category : #accessing }
GtSmaCCTokenQuery >> propertyName [
	^ propertyName
]

{ #category : #accessing }
GtSmaCCTokenQuery >> propertyName: aString [
	propertyName := aString
]

{ #category : #accessing }
GtSmaCCTokenQuery >> search [
	^ search
]

{ #category : #accessing }
GtSmaCCTokenQuery >> search: aString [
	search := aString
]

{ #category : #private }
GtSmaCCTokenQuery >> tokensOf: aNode do: aBlock [
	propertyName isEmpty
		ifTrue: [ ^ aNode nodesDo: [ :e |  ] andTokensDo: aBlock ].
	aNode tokenVariables
		do: [ :each | 
			(each
				findString: propertyName
				startingAt: 1
				caseSensitive: self caseSensitive) > 0
				ifTrue: [ (aNode perform: each) ifNotNil: aBlock ] ].
	aNode compositeTokenVariables
		do: [ :each | 
			(each
				findString: propertyName
				startingAt: 1
				caseSensitive: self caseSensitive) > 0
				ifTrue: [ (aNode perform: each) ifNotNil: [ :col | col do: aBlock ] ] ]
]
