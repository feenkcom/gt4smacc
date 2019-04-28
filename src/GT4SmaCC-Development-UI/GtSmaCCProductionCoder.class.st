Class {
	#name : #GtSmaCCProductionCoder,
	#superclass : #GtSmaCCCoder,
	#category : #'GT4SmaCC-Development-UI-Coders'
}

{ #category : #actions }
GtSmaCCProductionCoder >> actions [
	^ {(GtCoderAction new
		title: 'Simulate' translated;
		icon: BrGlamorousIcons debug;
		action: [ :button | self viewParserSimulator: button ];
		yourself)}
]

{ #category : #accessing }
GtSmaCCProductionCoder >> badgeTypes [
	^ super badgeTypes
		,
			#(#('AST' hasASTExpression) #('Code' hasCodeExpression) #('Default' hasDefaultExpression))
]

{ #category : #'private-actions' }
GtSmaCCProductionCoder >> inlineAllReferencesTo: aProductionRuleNode [
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
			{(BlShortcut new
				combination:
					(BlKeyCombination builder
						meta;
						key: BlKeyboardKey i;
						build);
				action: [ :editorElement | self inlineSource ])}
]

{ #category : #actions }
GtSmaCCProductionCoder >> viewParserSimulator: anElement [
	| simulator |
	simulator := GtSmaCCParserSimulator on: grammarItem.
	anElement phlow spawnObject: simulator
]
