Class {
	#name : 'GtSmaCCCommentStylerRule',
	#superclass : 'GtSmaCCStylerRule',
	#category : 'GT4SmaCC-Stylers'
}

{ #category : 'applying' }
GtSmaCCCommentStylerRule >> applyTo: aSmaCCParseNode on: aText [
	aSmaCCParseNode comments do: [ :each | (aText from: each first to: each last) stylerDo: styleBlock ]
]

{ #category : 'asserting' }
GtSmaCCCommentStylerRule >> shouldApplyToNode: aSmaCCParseNode [
	^ aSmaCCParseNode comments notNil
]
