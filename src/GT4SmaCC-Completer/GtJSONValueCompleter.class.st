Class {
	#name : #GtJSONValueCompleter,
	#superclass : #GtJSONCompleter,
	#instVars : [
		'values'
	],
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #accessing }
GtJSONValueCompleter >> addValue: aString [
	values add: aString
]

{ #category : #accessing }
GtJSONValueCompleter >> addValues: aCollection [
	values addAll: aCollection
]

{ #category : #accessing }
GtJSONValueCompleter >> complete: aString at: positionInteger hasQuote: aBoolean [
	^ (values select: [ :each | aString isEmpty or: [ each beginsWith: aString ] ])
		collect: [ :each | 
			| name |
			name := each.
			(aBoolean and: [ name notEmpty and: [ name last = $" ] ])
				ifTrue: [ name := name allButLast ].
			GtInsertTextCompletionAction
				labeled: (self labelFor: name withSearch: aString)
				completion: (name allButFirst: aString size)
				position: positionInteger
				from: positionInteger - aString size + 1 ]
]

{ #category : #accessing }
GtJSONValueCompleter >> initialize [
	super initialize.
	values := OrderedCollection new
]
