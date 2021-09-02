Class {
	#name : 'GtSmaCCCoderStylingVisitor',
	#superclass : 'GtSmaCCSyntaxStylingVisitor',
	#category : 'GT4SmaCC-Development-UI-Styler'
}

{ #category : 'private' }
GtSmaCCCoderStylingVisitor >> createDefinitionButtonFor: aToken [
	self text
		attributes:
			{(GtButtonAttribute new
				beAppend;
				stencil: [ BrButton new
						background: Color white;
						aptitude: BrIconAptitude + BrGlamorousFocusableShadowAptitude new;
						geometry: BlEllipseGeometry new;
						icon: BrGlamorousVectorIcons add;
						layout: BlLinearLayout horizontal alignCenter;
						size: 16 @ 16;
						when: BlMouseEnterEvent
							do:
								[ :anEvent | anEvent currentTarget background: Color veryVeryLightGray lighter ];
						when: BlMouseLeaveEvent
							do: [ :anEvent | anEvent currentTarget background: Color white ];
						action:
								[ :element | styler grammarCoder createRuleNamed: aToken value from: styler coder ];
						yourself ])}
		from: aToken stopPosition
		to: aToken stopPosition
]

{ #category : 'private' }
GtSmaCCCoderStylingVisitor >> formatInlineDefinition: aNode token: aToken [
	| item |
	item := styler grammarCoder ruleNamed: aToken source.
	item isNil
		ifTrue: [ self style: aToken with: #formatMissing:.
			^ self createDefinitionButtonFor: aToken ].
	(GtSmaCCCoder hasCoderFor: item)
		ifFalse: [ ^ self ].
	self text
		attributes:
			{(BrGlamorousTrangleExpanderTextAttribute new
				attributesCreatingBlock: [ BrTextAdornmentDynamicAttribute new
						beAppend;
						stencil: [ | element coder |
							coder := GtSmaCCCoder on: item in: styler grammarCoder.
							element := coder asElement.
							element expand.
							element ] ])}
		from: aToken stopPosition
		to: aToken stopPosition
]
