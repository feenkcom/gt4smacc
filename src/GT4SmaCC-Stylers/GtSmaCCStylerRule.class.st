Class {
	#name : #GtSmaCCStylerRule,
	#superclass : #Object,
	#instVars : [
		'styleBlock'
	],
	#category : #'GT4SmaCC-Stylers'
}

{ #category : #'instance creation' }
GtSmaCCStylerRule class >> styleBlock: aBlock [
	^ self new
		styleBlock: aBlock;
		yourself
]

{ #category : #applying }
GtSmaCCStylerRule >> applyTo: anObject on: aText [
	self style: anObject on: aText
]

{ #category : #'initialize-release' }
GtSmaCCStylerRule >> initializeForParser: parserClass [
]

{ #category : #testing }
GtSmaCCStylerRule >> shouldApplyToNode: aSmaCCParseNode [
	^ false
]

{ #category : #testing }
GtSmaCCStylerRule >> shouldApplyToToken: aSmaCCToken [
	^ false
]

{ #category : #applying }
GtSmaCCStylerRule >> style: anObject on: aText [
	[ (anObject isKindOf: Collection)
		ifTrue: [ anObject do: [ :each | self style: each on: aText ] ]
		ifFalse: [ ((anObject isKindOf: SmaCCToken) or: [ anObject isKindOf: SmaCCParseNode ])
				ifTrue: [ | from to |
					from := anObject startPosition.
					to := anObject stopPosition.
					(from <= to and: [ from > 0 and: [ to <= aText size ] ])
						ifTrue: [ (aText from: from to: to)
								stylerDo: [ :styler | 
									styleBlock
										cull: styler
										cull: anObject
										cull: aText ] ] ] ] ] on: Error do: [ :ex | ex return ]
]

{ #category : #accessing }
GtSmaCCStylerRule >> styleBlock [
	^ styleBlock
]

{ #category : #accessing }
GtSmaCCStylerRule >> styleBlock: aBlock [
	styleBlock := aBlock
]
