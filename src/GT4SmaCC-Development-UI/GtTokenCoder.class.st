Class {
	#name : #GtTokenCoder,
	#superclass : #GtSmaCCCoder,
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #accessing }
GtTokenCoder >> definitionName [
	^ ast isNil
		ifTrue: [ '' ]
		ifFalse: [ ast name source ]
]

{ #category : #ui }
GtTokenCoder >> styledName [
	| text |
	text := super styledName.
	GtSmaCCStyler formatTokenDefinition: text.
	^ text
]
