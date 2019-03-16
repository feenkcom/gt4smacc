Class {
	#name : #GtSmaCCCoderStylingVisitor,
	#superclass : #GtSmaCCStylingVisitor,
	#category : #'GT4SmaCC-Development-UI-Styler'
}

{ #category : #private }
GtSmaCCCoderStylingVisitor >> formatInlineDefinition: aNode [
	| coder |
	coder := styler grammarCoder coderNamed: aNode name source.
	coder isNil
		ifTrue: [ ^ false ].
	text
		attributes:
			{(BrTextExpandButtonAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ | element |
							element := coder asElement.
							element expand.
							element ] ])}
		from: aNode name stopPosition
		to: aNode name stopPosition.
	^ true
]
