Class {
	#name : #GtJSONBlockCompleter,
	#superclass : #GtJSONCompleter,
	#instVars : [
		'block'
	],
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #accessing }
GtJSONBlockCompleter >> block [
	^ block
]

{ #category : #accessing }
GtJSONBlockCompleter >> block: aBlock [
	block := aBlock
]

{ #category : #accessing }
GtJSONBlockCompleter >> complete: aString at: positionInteger hasQuote: aBoolean [
	^ block cull: aString cull: positionInteger cull: aBoolean
]
