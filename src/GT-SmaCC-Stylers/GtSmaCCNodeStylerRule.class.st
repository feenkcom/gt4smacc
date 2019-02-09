Class {
	#name : #GtSmaCCNodeStylerRule,
	#superclass : #GtSmaCCStylerRule,
	#instVars : [
		'nodeClassName',
		'nodeClass'
	],
	#category : #'GT-SmaCC-Stylers'
}

{ #category : #'instance creation' }
GtSmaCCNodeStylerRule class >> nodeClassName: aSymbol styleBlock: aBlock [
	^ (self styleBlock: aBlock)
		nodeClassName: aSymbol;
		yourself
]

{ #category : #accessing }
GtSmaCCNodeStylerRule >> nodeClass [
	^ nodeClass ifNil: [ nodeClass := Smalltalk at: nodeClassName ifAbsent: [ self class ] ]
]

{ #category : #accessing }
GtSmaCCNodeStylerRule >> nodeClassName [
	^ nodeClassName
]

{ #category : #accessing }
GtSmaCCNodeStylerRule >> nodeClassName: aSymbol [
	nodeClassName := aSymbol
]

{ #category : #asserting }
GtSmaCCNodeStylerRule >> shouldApplyToNode: aSmaCCParseNode [
	^ aSmaCCParseNode isKindOf: self nodeClass
]
