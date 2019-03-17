Class {
	#name : #GtProductionCoder,
	#superclass : #GtSmaCCCoder,
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #accessing }
GtProductionCoder >> definitionName [
	^ ast isNil
		ifTrue: [ '' ]
		ifFalse: [ ast name source ]
]

{ #category : #private }
GtProductionCoder >> parserStartingState [
	^ SmaCCDefinitionParser startingStateForProductionRule
]

{ #category : #ui }
GtProductionCoder >> styledName [
	| text |
	text := super styledName.
	GtSmaCCStyler formatProductionDefinition: text.
	^ text
]
