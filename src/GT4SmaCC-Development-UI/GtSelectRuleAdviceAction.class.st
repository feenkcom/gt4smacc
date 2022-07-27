Class {
	#name : #GtSelectRuleAdviceAction,
	#superclass : #GtAdviceAction,
	#instVars : [
		'ruleName',
		'parser'
	],
	#category : #'GT4SmaCC-Development-UI-Advice'
}

{ #category : #'instace creation' }
GtSelectRuleAdviceAction class >> forParser: aClass ruleName: aString [
	^ self new
		parser: aClass;
		ruleName: aString;
		yourself
]

{ #category : #accessing }
GtSelectRuleAdviceAction >> defaultTitle [
	^ ('Open ' , ruleName) asRopedText
]

{ #category : #executing }
GtSelectRuleAdviceAction >> executeOn: anElement [
	anElement
		allParentsDetect: [ :each | each isKindOf: GtPharoBehaviorCoderElement ]
		ifFound: [ :coder | 
			coder
				allChildrenBreadthFirstDetect: [ :each | each isKindOf: GtSmaCCCoderListElement ]
				ifFound: [ :list | (list scrollAndOpenItem: ruleName) ifTrue: [ ^ self ] ] ]
		ifNone: [  ].
	^ self spawnGrammarFrom: anElement
]

{ #category : #initialization }
GtSelectRuleAdviceAction >> parser: aClass [
	parser := aClass
]

{ #category : #initialization }
GtSelectRuleAdviceAction >> ruleName: aString [
	ruleName := aString
]

{ #category : #executing }
GtSelectRuleAdviceAction >> spawnGrammarFrom: anElement [
	| coder element |
	coder := GtSmaCCGrammarCoder onParser: parser.
	element := coder asElement.
	anElement phlow spawnObject: element.
	element
		enqueueTask: (BlTaskAction new
				action: [ element
						childNamed: #list
						ifFound: [ :list | list scrollAndOpenItem: ruleName ] ])
]
