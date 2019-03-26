Class {
	#name : #GtSmaCCDirective,
	#superclass : #GtSmaCCGrammarItem,
	#category : #'GT4SmaCC-Development-UI-Model'
}

{ #category : #testing }
GtSmaCCDirective >> isDirective [
	^ true
]

{ #category : #accessing }
GtSmaCCDirective >> name [
	^ nil
]

{ #category : #private }
GtSmaCCDirective >> parserStartingState [
	^ SmaCCDefinitionParser startingStateForDirectiveLine
]
