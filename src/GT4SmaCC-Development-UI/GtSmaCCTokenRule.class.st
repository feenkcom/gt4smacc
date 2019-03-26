Class {
	#name : #GtSmaCCTokenRule,
	#superclass : #GtSmaCCGrammarItem,
	#category : #'GT4SmaCC-Development-UI-Model'
}

{ #category : #testing }
GtSmaCCTokenRule >> isTokenRule [
	^ true
]

{ #category : #private }
GtSmaCCTokenRule >> parserStartingState [
	^ SmaCCDefinitionParser startingStateForRegexRule
]
