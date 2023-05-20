Class {
	#name : #GtJSONObjectCompleter,
	#superclass : #GtJSONCompleter,
	#instVars : [
		'items',
		'checks',
		'valueCompleter'
	],
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #accessing }
GtJSONObjectCompleter >> addCheck: aString withValue: valueString [
	checks at: aString put: valueString
]

{ #category : #accessing }
GtJSONObjectCompleter >> addKey: aString [
	self addKey: aString withValue: GtJSONEmptyCompleter instance
]

{ #category : #accessing }
GtJSONObjectCompleter >> addKey: aString withValue: aCompleter [
	items at: aString put: aCompleter
]

{ #category : #accessing }
GtJSONObjectCompleter >> addKeys: aStringCollection [
	aStringCollection do: [ :each | self addKey: each ]
]

{ #category : #accessing }
GtJSONObjectCompleter >> checkRequiredInErrorNode: anErrorNode from: startInteger to: stopInteger [
	checks
		keysAndValuesDo: [ :key :value | 
			((startInteger to: stopInteger)
				anySatisfy: [ :i | 
					| found |
					found := false.
					anErrorNode
						nodesAndTokensIn: (anErrorNode stackContents at: i)
						do: [ :member | 
							found := found
									or: [ (member isKindOf: JSONMemberNode)
											and: [ self
													member: member
													equalsKey: key
													andValue: value ] ] ].
					found ]) ifFalse: [ ^ false ] ].
	^ true
]

{ #category : #accessing }
GtJSONObjectCompleter >> complete: aString at: positionInteger hasQuote: aBoolean [
	^ (items keys select: [ :each | '"' , each beginsWith: aString ])
		collect: [ :each | 
			| text |
			text := '"' , each , (aBoolean ifTrue: [ '' ] ifFalse: [ '"' ]).
			GtInsertTextCompletionAction
				labeled: (self labelFor: text withSearch: aString)
				completion: (text allButFirst: aString size)
				position: positionInteger
				from: positionInteger - aString size + 1 ]
]

{ #category : #accessing }
GtJSONObjectCompleter >> completerForErrorNode: anErrorNode stackPointer: anInteger isLast: aBoolean [
	| objectIndex arrayIndex nextIndex token |
	objectIndex := anInteger < anErrorNode stackContents size
			ifTrue: [ anErrorNode stackContents
					indexOf: (SmaCCToken value: '{')
					startingAt: anInteger + 1 ]
			ifFalse: [ 0 ].
	(aBoolean
		and: [ objectIndex = 0
				and: [ (anInteger > anErrorNode stackContents size
						or: [ (anErrorNode stackContents at: anInteger) ~= (SmaCCToken value: '{') ])
						and: [ anErrorNode parent isKindOf: JSONMemberNode ] ] ])
		ifTrue: [ ^ GtJSONEmptyCompleter instance ].
	arrayIndex := anErrorNode stackContents
			indexOf: (SmaCCToken value: '[')
			startingAt: anInteger.
	(objectIndex > 0 and: [ arrayIndex > 0 ])
		ifTrue: [ nextIndex := objectIndex min: arrayIndex ]
		ifFalse: [ nextIndex := objectIndex > 0
					ifTrue: [ objectIndex ]
					ifFalse: [ arrayIndex > 0
							ifTrue: [ arrayIndex ]
							ifFalse: [ anErrorNode stackContents size + 1 ] ] ].
	((aBoolean and: [ anErrorNode stackContents isEmpty ])
		or: [ self
				checkRequiredInErrorNode: anErrorNode
				from: anInteger
				to: nextIndex - 1 ]) ifFalse: [ ^ GtJSONEmptyCompleter instance ].
	(nextIndex > anErrorNode stackContents size or: [ nextIndex < (anInteger + 2) ])
		ifTrue: [ (aBoolean and: [ anInteger + 2 <= anErrorNode stackContents size ])
				ifTrue: [ anErrorNode stackContents last = (SmaCCToken value: ':')
						ifTrue: [ token := anErrorNode stackContents at: anErrorNode stackContents size - 1.
							((token isKindOf: SmaCCToken) and: [ token value beginsWith: '"' ])
								ifTrue: [ items
										at: token value allButFirst allButLast
										ifPresent: [ :completer | ^ completer ].
									^ valueCompleter ].
							^ GtJSONEmptyCompleter instance ] ].
			^ self ].
	(anErrorNode stackContents at: nextIndex - 1) = (SmaCCToken value: ':')
		ifFalse: [ ^ self ].
	token := anErrorNode stackContents at: nextIndex - 2.
	((token isKindOf: SmaCCToken) and: [ token value beginsWith: '"' ])
		ifTrue: [ items
				at: token value allButFirst allButLast
				ifPresent: [ :completer | 
					^ completer
						completerForErrorNode: anErrorNode
						stackPointer: nextIndex
						isLast: aBoolean ]
				ifAbsentPut: [ ^ valueCompleter ] ].
	^ self
]

{ #category : #accessing }
GtJSONObjectCompleter >> completerForJSONNode: aJSONNode [
	(aJSONNode isKindOf: JSONObjectNode)
		ifTrue: [ checks
				keysAndValuesDo: [ :key :value | 
					(aJSONNode members
						anySatisfy: [ :member | 
							member isErrorNode not
								and: [ self
										member: member
										equalsKey: key
										andValue: value ] ]) ifFalse: [ ^ GtJSONEmptyCompleter instance ] ].
			^ self ].
	(aJSONNode isKindOf: JSONMemberNode)
		ifTrue: [ items
				at: (aJSONNode name value copyFrom: 2 to: aJSONNode name value size - 1)
				ifPresent: [ :completer | ^ completer ].
			^ valueCompleter ].
	^ GtJSONEmptyCompleter instance
]

{ #category : #initialization }
GtJSONObjectCompleter >> initialize [
	super initialize.
	items := Dictionary new.
	checks := Dictionary new.
	valueCompleter := GtJSONEmptyCompleter instance
]

{ #category : #accessing }
GtJSONObjectCompleter >> member: member equalsKey: key andValue: value [
	^ member name value = ('"' , key , '"')
		and: [ value isNil
				or: [ (member value isKindOf: JSONLiteralNode)
						and: [ member value value value = value ] ] ]
]

{ #category : #accessing }
GtJSONObjectCompleter >> valueCompleter [
	^ valueCompleter
]

{ #category : #accessing }
GtJSONObjectCompleter >> valueCompleter: anObject [
	valueCompleter := anObject
]
