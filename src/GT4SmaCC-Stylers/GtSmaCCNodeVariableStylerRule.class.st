Class {
	#name : #GtSmaCCNodeVariableStylerRule,
	#superclass : #GtSmaCCNodeStylerRule,
	#instVars : [
		'variableNames'
	],
	#category : #'GT4SmaCC-Stylers'
}

{ #category : #'instance creation' }
GtSmaCCNodeVariableStylerRule class >> nodeClassName: aSymbol variableNames: aCollection styleBlock: aBlock [
	^ (self nodeClassName: aSymbol styleBlock: aBlock)
		variableNames: aCollection;
		yourself
]

{ #category : #applying }
GtSmaCCNodeVariableStylerRule >> applyTo: anObject on: aText [
	variableNames do: [ :each | (anObject perform: each asSymbol) ifNotNil: [ :item | self style: item on: aText ] ]
]

{ #category : #accessing }
GtSmaCCNodeVariableStylerRule >> variableNames [
	^ variableNames
]

{ #category : #accessing }
GtSmaCCNodeVariableStylerRule >> variableNames: aCollection [
	variableNames := aCollection
]
