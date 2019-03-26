Class {
	#name : #GtSmaCCProductionRule,
	#superclass : #GtSmaCCGrammarItem,
	#category : #'GT4SmaCC-Development-UI-Model'
}

{ #category : #testing }
GtSmaCCProductionRule >> isProductionRule [
	^ true
]

{ #category : #private }
GtSmaCCProductionRule >> parserStartingState [
	^ SmaCCDefinitionParser startingStateForProductionRule
]
