Class {
	#name : #GtSmaCCCoderStylingVisitor,
	#superclass : #GtSmaCCStylingVisitor,
	#category : #'GT4SmaCC-Development-UI-Styler'
}

{ #category : #private }
GtSmaCCCoderStylingVisitor >> formatTokenMethod: aToken [
	| name class stStyler |
	name := (aToken source copyFrom: 2 to: aToken source size - 1)
		asSymbol.
	class := styler scannerClass whichClassIncludesSelector: name.
	class isNil
		ifTrue: [ ^ self ].
	(class includesBehavior: SmaCCScanner)
		ifFalse: [ ^ self ].
	stStyler := BrRBTextStyler new.
	stStyler classOrMetaClass: class.
	text
		attributes:
			{(BrTextExpandButtonAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ (GtMethodCoder forMethod: (class lookupSelector: name)) asElement ] ])}
		from: aToken stopPosition
		to: aToken stopPosition
]
