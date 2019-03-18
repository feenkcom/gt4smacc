Class {
	#name : #GtProductionCoder,
	#superclass : #GtSmaCCCoder,
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #accessing }
GtProductionCoder >> completionStrategy [
	^ owner productionCompletionStrategy
]

{ #category : #accessing }
GtProductionCoder >> definitionName [
	^ originalAST isNil
		ifTrue: [ '' ]
		ifFalse: [ originalAST name source ]
]

{ #category : #testing }
GtProductionCoder >> isProductionRuleCoder [
	^ true
]

{ #category : #private }
GtProductionCoder >> parserStartingState [
	^ SmaCCDefinitionParser startingStateForProductionRule
]

{ #category : #'event handling' }
GtProductionCoder >> sourceChanged [
	super sourceChanged.
	owner updateProductionCompletions
]

{ #category : #ui }
GtProductionCoder >> styledName [
	| text |
	text := super styledName.
	GtSmaCCStyler formatProductionDefinition: text.
	^ text
]
