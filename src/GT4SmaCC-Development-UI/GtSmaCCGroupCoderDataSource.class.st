Class {
	#name : 'GtSmaCCGroupCoderDataSource',
	#superclass : 'BlInfiniteDataSource',
	#instVars : [
		'group',
		'elementsByCoder',
		'lookBlock'
	],
	#category : 'GT4SmaCC-Development-UI-Coders'
}

{ #category : 'ui' }
GtSmaCCGroupCoderDataSource >> buildElementForCoder: aCoder [
	| element |
	element := aCoder asElement.
	lookBlock notNil
		ifTrue: [ element addAptitude: lookBlock value ].
	^ element
]

{ #category : 'initialize-release' }
GtSmaCCGroupCoderDataSource >> group: aSmaCCDefinitionGroup [
	group := aSmaCCDefinitionGroup.
	self notifyChanged
]

{ #category : 'initialize-release' }
GtSmaCCGroupCoderDataSource >> initialize [
	super initialize.
	elementsByCoder := Dictionary new
]

{ #category : 'accessing' }
GtSmaCCGroupCoderDataSource >> itemCount [
	^ group coders size
]

{ #category : 'accessing' }
GtSmaCCGroupCoderDataSource >> lookBlock: aBlock [
	lookBlock := aBlock
]

{ #category : 'instance creation' }
GtSmaCCGroupCoderDataSource >> onBindHolder: anElementHolder at: aPosition [
	| currentCoder |
	currentCoder := group coders at: aPosition.
	anElementHolder
		coderElement:
			(elementsByCoder
				at: currentCoder
				ifAbsentPut: [ self buildElementForCoder: currentCoder ])
]

{ #category : 'instance creation' }
GtSmaCCGroupCoderDataSource >> onCreateHolder: anInfiniteElement type: anItemType [
	^ GtSmaCCCoderElementHolder new
]

{ #category : 'updating' }
GtSmaCCGroupCoderDataSource >> updateCoders [
	| cachedCodersToRemove |
	cachedCodersToRemove := elementsByCoder keys
		select: [ :aCoder | (group coders includes: aCoder) not ].
	cachedCodersToRemove
		do: [ :aCoder | elementsByCoder removeKey: aCoder ifAbsent: [  ] ].
	self notifyChanged
]
