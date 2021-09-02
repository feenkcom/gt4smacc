Class {
	#name : 'GtSmaCCSlides',
	#superclass : 'Object',
	#category : 'GT4SmaCC-Documentation'
}

{ #category : 'coder explanation slide' }
GtSmaCCSlides >> addCommonExplanationTargetsFor: coderElement [
	| tabgroup actionBar toolbar |
	coderElement
		allChildrenBreadthFirstDetect: [ :each | each isKindOf: GtPharoBehaviorCoderElement ]
		ifFound:
			[ :each | 
			tabgroup := each allChildrenBreadthFirstDetect: [ :child | child isKindOf: BrTabGroup ] ifFound: [ :child | child ].
			toolbar := tabgroup childNamed: #toolbar.
			actionBar := each childNamed: #actionBar ].
	tabgroup
		allChildrenDepthFirstDo:
			[ :each | 
			(each isKindOf: BrTab)
				ifTrue:
					[ each addChild: ((self yellowExplanationTargetCircleFor: (each label asString , 'Tab') asSymbol) relocate: 8 @ 22) ] ].
	toolbar addChild: ((self yellowExplanationTargetCircleFor: #addButton) relocate: 4 @ 10).
	actionBar children first addChild: ((self yellowExplanationTargetCircleFor: #saveButton) relocate: 4 @ 10)
]

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
	^ [ [ SmaCCRegexSimulator on: aGrammar ast tokenName: ruleName ] on: Error do: [ :ex | ex return: nil ] ]
		ensure: [ SmaCCGrammar maximumCharacterValue: value ]
]

{ #category : 'private' }
GtSmaCCSlides >> directivesIn: coderElement [
	| elements |
	elements := OrderedCollection new.
	coderElement
		allChildrenBreadthFirstDo:
			[ :each | ((each isKindOf: GtSmaCCCoderElement) and: [ each coder isDirective ]) ifTrue: [ elements add: each ] ].
	^ elements
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
