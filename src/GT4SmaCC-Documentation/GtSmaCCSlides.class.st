Class {
	#name : 'GtSmaCCSlides',
	#superclass : 'Object',
	#category : 'GT4SmaCC-Documentation'
}

{ #category : 'private' }
GtSmaCCSlides >> createParserCoderOn: aClass [
	<gtExample>
	
	| coderElement |
	coderElement := BlUseAsyncFeatures
		disableDuring: [ (GtPager createWrappedOn: (GtClassCoderLiveSlide new class: aClass)) maximized ].
	^ (BlElement new)
		constraintsDo:
				[ :c | 
					c vertical matchParent.
					c horizontal matchParent ];
		aptitude: BrShadowAptitude;
		background: Color white;
		margin: (BlInsets all: 5);
		addChild: coderElement
]

{ #category : 'number token slide' }
GtSmaCCSlides >> createTokenSimulatorFor: ruleName from: aGrammar [
	| value |
	value := SmaCCGrammar maximumCharacterValue.
	SmaCCGrammar maximumCharacterValue: 255.
	^ [ SmaCCRegexSimulator on: aGrammar ast tokenName: ruleName ] ensure: [ SmaCCGrammar maximumCharacterValue: value ]
]

{ #category : 'private' }
GtSmaCCSlides >> findItem: aString in: coderElement [
	^ coderElement
		allChildrenBreadthFirstDetect:
			[ :each | 
			(each isKindOf: GtSmaCCCoderElement)
				and: [ (each coder isTokenRule or: [ each coder isProductionRule ]) and: [ each coder name = aString ] ] ]
		ifFound: [ :each | each ]
]

{ #category : 'private' }
GtSmaCCSlides >> grammarFrom: anElement [
	anElement allChildrenDepthFirstDo: [ :each | (each isKindOf: GtSmaCCListCoderElement) ifTrue: [ ^ each coder grammar ] ].
	^ nil
]

{ #category : 'private' }
GtSmaCCSlides >> setSource: aString in: anElement [
	anElement
		allChildrenDepthFirstDo: [ :each | (each isKindOf: GtSmaCCListCoderElement) ifTrue: [ each showDefinition: aString ] ]
]

{ #category : 'private' }
GtSmaCCSlides >> yellowExplanationTargetCircleFor: aModel [
	^ (BrButton new)
		constraintsDo: [ :c | c ignoreByLayout ];
		size: 0 @ 0;
		elevation: (BlRelativeElevation elevation: 10);
		geometry: BlCircle new;
		aptitude: (GtExplainerTargetAptitude new explanationModel: aModel)
]
