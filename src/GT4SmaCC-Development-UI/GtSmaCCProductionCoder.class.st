Class {
	#name : #GtSmaCCProductionCoder,
	#superclass : #GtSmaCCCoder,
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #actions }
GtSmaCCProductionCoder >> actions [
	^ {(GtCoderAction new
		title: 'Simulate' translated;
		icon: BrGlamorousVectorIcons debug;
		action: [ :button | self viewParserSimulator: button ];
		yourself)}
]

{ #category : #accessing }
GtSmaCCProductionCoder >> badgeTypes [
	^ super badgeTypes
		,
			#(#('AST' hasASTExpression) #('Code' hasCodeExpression) #('Default' hasDefaultExpression))
]

{ #category : #accessing }
GtSmaCCProductionCoder >> collapsedText [
	| text |
	text := self name asRopedText.
	GtSmaCCStyler formatProductionDefinition: text.
	^ text
]

{ #category : #actions }
GtSmaCCProductionCoder >> extractSource: anElement [
	| nodes newSource extractedSource extractedLocation newItem renameMap |
	nodes := self nodesForSelection.
	nodes isEmpty
		ifTrue: [ ^ self ].
	extractedLocation := nodes first startPosition.
	newSource := (self source first: extractedLocation - 1) , ' '
		, (self source allButFirst: nodes last stopPosition).
	extractedSource := String
		streamContents: [ :stream | 
			stream
				nextPut: $ ;
				cr;
				tab;
				nextPutAll: ': ';
				nextPutAll:
					(self ast completeSource
						copyFrom: nodes first startPosition
						to: nodes last stopPosition) asString;
				cr;
				tab;
				nextPut: $; ].
	newItem := owner createRuleNamed: ' ' from: self.
	newItem source: extractedSource.
	grammarItem source: newSource.
	self sourceEditor selecter
		overwrite;
		from: extractedLocation - 1 to: extractedLocation;
		select.
	self sourceEditor moveCursorTo: extractedLocation.
	renameMap := Dictionary new.
	renameMap
		at: self
		put: (OrderedCollection with: (extractedLocation to: extractedLocation)).
	renameMap
		at: (owner group coderFor: newItem)
		put: (OrderedCollection with: (1 to: 1)).
	self installRenameActionOn: anElement forCoders: renameMap
]

{ #category : #actions }
GtSmaCCProductionCoder >> inlineSource [
	| node interval |
	node := self nodeAtCursor.
	node isNil
		ifTrue: [ ^ self ].
	(node isKindOf: SmaCCProductionSymbolNode)
		ifTrue: [ ^ self
				executeTransformation: (GtSmaCCInlineRefactoring inline: node in: grammarItem) ].
	((node isKindOf: SmaCCProductionRuleNode)
		and: [ (interval := self selectedSourceInterval) notNil
				and: [ interval first >= node name startPosition
						and: [ interval last <= node name stopPosition ] ] ])
		ifTrue: [ ^ self
				executeTransformation: (GtSmaCCInlineAllRefactoring inlineAll: grammarItem) ]
]

{ #category : #private }
GtSmaCCProductionCoder >> shortcuts [
	^ super shortcuts
		,
			{(BlShortcutWithAction new
				combination:
					(BlKeyCombination builder
						meta;
						key: BlKeyboardKey i;
						build);
				repeatable: false;
				action: [ self inlineSource ]).
			(BlShortcutWithAction new
				combination:
					(BlKeyCombination builder
						meta;
						key: BlKeyboardKey e;
						build);
				repeatable: false;
				action: [ :element | self extractSource: element ])}
]

{ #category : #actions }
GtSmaCCProductionCoder >> viewParserSimulator: anElement [
	| simulator |
	simulator := GtSmaCCParserSimulator on: grammarItem.
	anElement phlow spawnObject: simulator
]
