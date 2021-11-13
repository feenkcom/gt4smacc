Class {
	#name : #GtSmaCCTokenSimulatorElement,
	#superclass : #GtSmaCCSimulatorElement,
	#category : 'GT4SmaCC-Development-UI-UI'
}

{ #category : #private }
GtSmaCCTokenSimulatorElement >> add: aTokenRule to: aGroup [
	(aGroup includes: aTokenRule)
		ifTrue: [ ^ self ].
	aGroup add: aTokenRule.
	aTokenRule ast
		allNodesOfType: SmaCCTokenRegexNode
		do: [ :node | 
			(grammarCoder ruleNamed: node name source)
				ifNotNil: [ :rule | self add: rule to: aGroup ] ]
]

{ #category : #ui }
GtSmaCCTokenSimulatorElement >> buildResultsElement [
	| element group |
	group := GtSmaCCDefinitionGroupResult onCoder: grammarCoder.
	self add: simulator rule to: group.
	element := group asElement.
	element group coders do: [ :each | each expanded: true ].
	(element childNamed: #filter) removeFromParent.
	self addChild: element as: #list
]

{ #category : #'event handling' }
GtSmaCCTokenSimulatorElement >> cursorMoved [
	self simulateInput
]

{ #category : #'initialize-release' }
GtSmaCCTokenSimulatorElement >> setupSimulator [
	simulator weak
		when: GtSmaCCTokenSimulationError send: #styleError: to: self;
		when: GtSmaCCTokenSimulationAccept send: #styleAccept: to: self.
	grammarCoder := GtSmaCCGrammarCoder onGrammar: simulator grammar.
	self buildElement
]

{ #category : #private }
GtSmaCCTokenSimulatorElement >> styleAccept: acceptAnnouncement [
	| group |
	self clearAttributesIn: self testEditor.
	self inputCursorPosition < acceptAnnouncement index
		ifTrue: [ ^ self ].
	group := (self childNamed: #list) group.
	group coders
		do: [ :each | self clearAttributesIn: each sourceEditor ].
	acceptAnnouncement nodes isEmpty
		ifTrue: [ ^ self ].
	acceptAnnouncement nodes
		do: [ :each | 
			| tokenRule start name coder text |
			tokenRule := each nodeOfType: SmaCCTokenRuleNode.
			start := tokenRule startPosition - 1.
			name := tokenRule name source.
			coder := group coderFor: (grammarCoder ruleNamed: name).
			coder notNil
				ifTrue: [ text := coder sourceEditor text.
					self inputCursorPosition = acceptAnnouncement index
						ifTrue: [ each
								testTokensDo: [ :token | 
									(text from: token startPosition - start to: token stopPosition - start)
										attributes: AcceptAttributes ] ] ] ]
]

{ #category : #private }
GtSmaCCTokenSimulatorElement >> styleError: errorAnnouncement [
	| editor text |
	editor := self testEditor.
	self clearAttributesIn: editor.
	text := editor text.
	text size >= errorAnnouncement index
		ifTrue: [ (text from: errorAnnouncement index to: text size)
				attributes: ErrorAttributes ]
]
