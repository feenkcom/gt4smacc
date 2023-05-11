Class {
	#name : #GtJSONUnionCompleter,
	#superclass : #GtJSONCompleter,
	#instVars : [
		'completers'
	],
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #accessing }
GtJSONUnionCompleter >> addCompleter: aCompleter [
	completers add: aCompleter
]

{ #category : #accessing }
GtJSONUnionCompleter >> complete: aString at: positionInteger [
	| stream |
	stream := #() asAsyncStream.
	completers
		do: [ :each | 
			stream := stream
					merge: (each complete: aString at: positionInteger) asAsyncStream ].
	^ stream withoutDuplicates
]

{ #category : #accessing }
GtJSONUnionCompleter >> completerForFinalNode: aJSONNode [
	| results |
	results := (completers
			collect: [ :each | each completerForFinalNode: aJSONNode ])
			reject: [ :each | each == GtJSONEmptyCompleter instance ].
	^ results isEmpty
		ifTrue: [ GtJSONEmptyCompleter instance ]
		ifFalse: [ self class new completers: results ]
]

{ #category : #accessing }
GtJSONUnionCompleter >> completerForNode: aJSONNode [
	| results |
	results := (completers collect: [ :each | each completerForNode: aJSONNode ])
			reject: [ :each | each == GtJSONEmptyCompleter instance ].
	^ results isEmpty
		ifTrue: [ GtJSONEmptyCompleter instance ]
		ifFalse: [ self class new completers: results ]
]

{ #category : #accessing }
GtJSONUnionCompleter >> completers [
	^ completers
]

{ #category : #accessing }
GtJSONUnionCompleter >> completers: anObject [
	completers := anObject
]

{ #category : #initialization }
GtJSONUnionCompleter >> initialize [
	super initialize.
	completers := OrderedCollection new
]
