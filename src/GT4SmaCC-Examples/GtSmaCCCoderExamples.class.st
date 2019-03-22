Class {
	#name : #GtSmaCCCoderExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Examples'
}

{ #category : #filtering }
GtSmaCCCoderExamples >> astNodeReferencesFilter [
	<gtExample>
	| filter scope filtered |
	filter := GtSmaCCNodeReferencesFilter
		name: 'ClassProductionExpression'.
	scope := self filterScope.
	filtered := filter applyInScope: scope.
	self assert: filtered isEmpty not.
	^ filtered
]

{ #category : #filtering }
GtSmaCCCoderExamples >> filterScope [
	<gtExample>
	| grammar scope |
	grammar := self smaccDefinitionGrammar.
	scope := GtSmaCCDefinitionGroupResult new.
	grammar rules do: [ :each | scope add: each ].
	self assert: scope size = grammar rules size.
	^ scope
]

{ #category : #model }
GtSmaCCCoderExamples >> glrDirective [
	<gtExample>
	| grammar directive |
	grammar := self smaccDefinitionGrammar.
	directive := grammar rules
		detect: [ :each | each source beginsWith: '%glr' ].
	self assert: directive source last = $;.
	self assert: directive isDirective.
	^ directive
]

{ #category : #coders }
GtSmaCCCoderExamples >> grammarCoder [
	<gtExample>
	| coder grammar |
	grammar := self smaccDefinitionGrammar.
	coder := GtSmaCCGrammarCoder onGrammar: grammar.
	self assert: coder source = self smaccGrammarClass definitionString.
	self assert: coder group size = grammar rules size.
	self
		assert: (coder productionCompletionStrategy hasCompletionEntryFor: 'Pro').
	self
		assert: (coder productionCompletionStrategy hasCompletionEntryFor: '<se').
	self
		assert: (coder tokenCompletionStrategy hasCompletionEntryFor: 'Pro') not.
	self
		assert: (coder tokenCompletionStrategy hasCompletionEntryFor: '<se').
	self assert: (coder ruleNamed: self productionRuleName) notNil.
	self assert: (coder ruleNamed: self semicolonName) notNil.
	^ coder
]

{ #category : #ui }
GtSmaCCCoderExamples >> grammarElement [
	<gtExample>
	^ self grammarCoder asElement
]

{ #category : #filtering }
GtSmaCCCoderExamples >> implementorsFilter [
	<gtExample>
	| filter scope filtered |
	filter := GtSmaCCDefinitionImplementorPatternFilter pattern: 'tok'.
	scope := self filterScope.
	filtered := filter applyInScope: scope.
	self assert: filtered size > 1.
	^ filtered
]

{ #category : #model }
GtSmaCCCoderExamples >> jsGrammar [
	<gtExample>
	| grammar class |
	class := Smalltalk at: #JSParser ifAbsent: [ ^ nil ].
	grammar := GtSmaCCGrammar onParser: class.
	self assert: grammar rules notEmpty.
	^ grammar
]

{ #category : #model }
GtSmaCCCoderExamples >> jsIdentifier [
	<gtExample>
	| grammar |
	grammar := self jsGrammar.
	grammar isNil
		ifTrue: [ ^ nil ].
	^ grammar ruleNamed: '<identifier>'
]

{ #category : #simulation }
GtSmaCCCoderExamples >> jsIdentifierSimulator [
	<gtExample>
	| identifier simulator |
	identifier := self jsIdentifier.
	identifier isNil
		ifTrue: [ ^ nil ].
	simulator := GtSmaCCTokenSimulator on: identifier.
	simulator
		subscribe: GtSmaCCSimulationAccept
		do:
			[ :ann | self assert: (ann index = 0 or: [ ann nodes notEmpty ]) ].
	simulator simulateOn: '\u'.
	^ simulator
]

{ #category : #ui }
GtSmaCCCoderExamples >> jsIdentifierSimulatorUI [
	<gtExample>
	| identifier simulator |
	identifier := self jsIdentifier.
	identifier isNil
		ifTrue: [ ^ nil ].
	simulator := GtSmaCCTokenSimulator on: identifier.
	^ GtSmaCCTokenSimulatorElement onSimulator: simulator
]

{ #category : #model }
GtSmaCCCoderExamples >> productionRule [
	<gtExample>
	| grammar rule |
	grammar := self smaccDefinitionGrammar.
	rule := grammar ruleNamed: self productionRuleName.
	self assert: (rule source beginsWith: self productionRuleName).
	self assert: rule source last = $;.
	self assert: rule isProductionRule.
	^ rule
]

{ #category : #coders }
GtSmaCCCoderExamples >> productionRuleCoder [
	<gtExample>
	| coder rule grammarCoder |
	grammarCoder := self grammarCoder.
	rule := grammarCoder ruleNamed: self productionRuleName.
	coder := GtSmaCCCoder on: rule in: grammarCoder.
	self assert: coder sourceEditor text asString = rule source.
	self
		assert: coder collapsedEditor text asString = self productionRuleName.
	^ coder
]

{ #category : #ui }
GtSmaCCCoderExamples >> productionRuleElement [
	<gtExample>
	^ self productionRuleCoder asElement
]

{ #category : #private }
GtSmaCCCoderExamples >> productionRuleName [
	^ 'ProductionRule'
]

{ #category : #filtering }
GtSmaCCCoderExamples >> referencesFilter [
	<gtExample>
	| filter scope filtered |
	filter := GtSmaCCDefinitionReferencesFilter
		name: self productionRuleName.
	scope := self filterScope.
	filtered := filter applyInScope: scope.
	self assert: filtered isEmpty not.
	^ filtered
]

{ #category : #ui }
GtSmaCCCoderExamples >> semicolonCoderElement [
	<gtExample>
	^ self semicolonTokenCoder asElement
]

{ #category : #private }
GtSmaCCCoderExamples >> semicolonName [
	^ '<semicolon>'
]

{ #category : #model }
GtSmaCCCoderExamples >> semicolonToken [
	<gtExample>
	| grammar rule |
	grammar := self smaccDefinitionGrammar.
	rule := grammar ruleNamed: self semicolonName.
	self assert: (rule source beginsWith: self semicolonName).
	self assert: rule source last = $;.
	self assert: rule isTokenRule.
	^ rule
]

{ #category : #coders }
GtSmaCCCoderExamples >> semicolonTokenCoder [
	<gtExample>
	| coder rule grammarCoder |
	grammarCoder := self grammarCoder.
	rule := grammarCoder ruleNamed: self semicolonName.
	coder := GtSmaCCCoder on: rule in: grammarCoder.
	self assert: coder sourceEditor text asString = rule source.
	self assert: coder collapsedEditor text asString = self semicolonName.
	^ coder
]

{ #category : #simulation }
GtSmaCCCoderExamples >> simulateHex [
	<gtExample>
	| grammar rule simulator nodes |
	grammar := GtSmaCCGrammar forDefinition: '<a> : <hex>; <hex> : [0-9a-fA-F];'.
	rule := grammar ruleNamed: '<a>'.
	simulator := GtSmaCCTokenSimulator on: rule.
	nodes := IdentitySet new.
	simulator
		subscribe: GtSmaCCSimulationAccept
		do: [ :ann | 
			ann nodes
				do: [ :each | nodes add: (each nodeOfType: SmaCCTokenRuleNode) ] ].
	simulator simulateOn: 'a'.
	self assert: nodes size = 2.
	^ simulator
]

{ #category : #simulation }
GtSmaCCCoderExamples >> simulateRight [
	<gtExample>
	| grammar rule simulator errorCount acceptCount input |
	grammar := self smaccDefinitionGrammar.
	rule := grammar ruleNamed: '<right>'.
	simulator := GtSmaCCTokenSimulator on: rule.
	input := 'rihht'.
	errorCount := 0.
	simulator
		subscribe: GtSmaCCSimulationError
		do: [ :ann | 
			ann input = input
				ifTrue: [ errorCount := errorCount + 1.
					self assert: ann index = 3 ] ].
	acceptCount := 0.
	simulator
		subscribe: GtSmaCCSimulationAccept
		do: [ :ann | 
			acceptCount := acceptCount + 1.
			self assert: ann index < 3.
			(ann input = input and: [ ann index > 0 ])
				ifTrue: [ self assert: ann nodes size = 1.
					self
						assert: ann nodes anyOne source first = (input at: ann index) ] ].
	simulator simulateOn: input.
	self assert: acceptCount = 3.
	^ simulator
]

{ #category : #ui }
GtSmaCCCoderExamples >> simulateRightUI [
	<gtExample>
	| grammar rule simulator |
	grammar := self smaccDefinitionGrammar.
	rule := grammar ruleNamed: '<right>'.
	simulator := GtSmaCCTokenSimulator on: rule.
	^ GtSmaCCTokenSimulatorElement onSimulator: simulator
]

{ #category : #model }
GtSmaCCCoderExamples >> smaccDefinitionGrammar [
	<gtExample>
	| grammar |
	grammar := GtSmaCCGrammar onParser: self smaccGrammarClass.
	self assert: grammar rules notEmpty.
	^ grammar
]

{ #category : #private }
GtSmaCCCoderExamples >> smaccGrammarClass [
	^ SmaCCDefinitionParser
]

{ #category : #filtering }
GtSmaCCCoderExamples >> tokenReferencesFilter [
	<gtExample>
	| filter scope filtered |
	filter := GtSmaCCDefinitionReferencesFilter name: self semicolonName.
	scope := self filterScope.
	filtered := filter applyInScope: scope.
	self assert: filtered size > 1.
	^ filtered
]

{ #category : #filtering }
GtSmaCCCoderExamples >> variableReferencesFilter [
	<gtExample>
	| filter scope filtered |
	filter := GtSmaCCVariableReferencesFilter name: '''rule'''.
	scope := self filterScope.
	filtered := filter applyInScope: scope.
	self assert: filtered isEmpty not.
	^ filtered
]
