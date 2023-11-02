Class {
	#name : #GtJSONValueCompleter,
	#superclass : #GtJSONCompleter,
	#instVars : [
		'values',
		'useWeightedValues'
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
	^ (useWeightedValues
		ifTrue: [ values asyncWeightedStreamStartingWith: aString ]
		ifFalse: [ values asyncStreamStartingWith: aString ])
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
	values := GtPrefixTree new.
	self useWeightedValues: false
]

{ #category : #accessing }
GtJSONValueCompleter >> useWeightedValues [
	^ useWeightedValues
]

{ #category : #accessing }
GtJSONValueCompleter >> useWeightedValues: aBoolean [
	useWeightedValues := aBoolean
]

{ #category : #accessing }
GtJSONValueCompleter >> values [
	^ values
]

{ #category : #accessing }
GtJSONValueCompleter >> values: aGtPrefixTree [
	values := aGtPrefixTree
]
