Class {
	#name : #GtSmaCCCoderExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Examples'
}

{ #category : #filtering }
GtSmaCCCoderExamples >> astFilter [
	<gtExample>
	| filter scope filtered |
	filter := GtSmaCCSelectorFilter selector: #hasASTExpression.
	scope := self filterScope.
	filtered := filter applyInScope: scope.
	self assert: filtered size > 1.
	^ filtered
]

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
GtSmaCCCoderExamples >> codeExpressionFilter [
	<gtExample>
	| filter scope filtered |
	filter := GtSmaCCSelectorFilter selector: #hasCodeExpression.
	scope := self filterScope.
	filtered := filter applyInScope: scope.
	self assert: filtered size > 1.
	^ filtered
]

{ #category : #model }
GtSmaCCCoderExamples >> csGrammar [
	<gtExample>
	| grammar class |
	class := Smalltalk at: #CSharpParser ifAbsent: [ ^ nil ].
	grammar := GtSmaCCGrammar onParser: class.
	self assert: grammar rules notEmpty.
	^ grammar
]

{ #category : #'parser simulation' }
GtSmaCCCoderExamples >> csIfSimulateError [
	<gtExample>
	^ self csIfSimulator
		ifNotNil: [ :simulator | 
			| result |
			simulator
				subscribe: GtSmaCCParserSimulationError
				do: [ :ann | 
					self assert: ann stack size = 5.
					self assert: ann index = 11.
					result := ann stack ].
			simulator simulateOn: 'if (a == 3;'.
			self assert: result notNil.
			^ result ]
]

{ #category : #'parser simulation' }
GtSmaCCCoderExamples >> csIfSimulateIncomplete [
	<gtExample>
	^ self csIfSimulator
		ifNotNil: [ :simulator | 
			| result |
			simulator
				subscribe: GtSmaCCParserSimulationIncompleteInput
				do: [ :ann | 
					self assert: ann stack size = 4.
					result := ann stack ].
			simulator simulateOn: 'if (a == 3)'.
			self assert: result notNil.
			^ result ]
]

{ #category : #'parser simulation' }
GtSmaCCCoderExamples >> csIfSimulateResult [
	<gtExample>
	^ self csIfSimulator
		ifNotNil: [ :simulator | 
			| result |
			simulator
				subscribe: GtSmaCCParserSimulationAccept
				do: [ :ann | 
					self assert: ann results size = 1.
					result := ann results first ].
			simulator simulateOn: 'if (a == 3) return 4;'.
			self assert: result notNil.
			^ result ]
]

{ #category : #'parser simulation' }
GtSmaCCCoderExamples >> csIfSimulator [
	<gtExample>
	| identifier |
	identifier := self csIfStatement.
	identifier isNil
		ifTrue: [ ^ nil ].
	^ GtSmaCCParserSimulator on: identifier
]

{ #category : #ui }
GtSmaCCCoderExamples >> csIfSimulatorUI [
	<gtExample>
	| simulator |
	simulator := self csIfSimulator.
	simulator isNil
		ifTrue: [ ^ nil ].
	^ GtSmaCCParserSimulatorElement onSimulator: simulator
]

{ #category : #model }
GtSmaCCCoderExamples >> csIfStatement [
	<gtExample>
	| grammar |
	grammar := self csGrammar.
	grammar isNil
		ifTrue: [ ^ nil ].
	^ grammar ruleNamed: 'if_statement'
]

{ #category : #filtering }
GtSmaCCCoderExamples >> defaultExpressionFilter [
	<gtExample>
	| filter scope filtered |
	filter := GtSmaCCSelectorFilter selector: #hasDefaultExpression.
	scope := self filterScope.
	filtered := filter applyInScope: scope.
	self assert: filtered size > 1.
	^ filtered
]

{ #category : #model }
GtSmaCCCoderExamples >> exampleDelete [
	<gtExample>
	| grammar |
	grammar := self exampleGrammar.
	(grammar ruleNamed: 'NotReferenced') delete.
	self
		assert: (grammar source indexOfSubCollection: 'NotReferenced') = 0.
	(grammar ruleNamed: '<notReferenced>') delete.
	self
		assert: (grammar source indexOfSubCollection: '<notReferenced>') = 0.
	^ grammar
]

{ #category : #model }
GtSmaCCCoderExamples >> exampleGrammar [
	<gtExample>
	| grammar |
	grammar := GtSmaCCGrammar
		forDefinition:
			'<whitespace> : \s+; 
			<notReferenced> : a+; 
			<a> : a+; 
			Start : A;
			A : <a>;
			NotReferenced : A;'.
	self assert: (grammar ruleNamed: '<whitespace>') isReferenced.
	self assert: (grammar ruleNamed: '<notReferenced>') isReferenced not.
	self assert: (grammar ruleNamed: 'NotReferenced') isReferenced not.
	self assert: (grammar ruleNamed: '<a>') isReferenced.
	self assert: (grammar ruleNamed: 'A') isReferenced.
	self assert: grammar startingProductions size = 1.
	self assert: grammar startingProductions first name = 'Start'.
	^ grammar
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
	coder updateCompletionsNow.
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

{ #category : #'token simulation' }
GtSmaCCCoderExamples >> jsIdentifierSimulator [
	<gtExample>
	| identifier simulator |
	identifier := self jsIdentifier.
	identifier isNil
		ifTrue: [ ^ nil ].
	simulator := GtSmaCCTokenSimulator on: identifier.
	simulator
		subscribe: GtSmaCCTokenSimulationAccept
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
	grammarCoder updateCompletionsNow.
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
	grammarCoder updateCompletionsNow.
	rule := grammarCoder ruleNamed: self semicolonName.
	coder := GtSmaCCCoder on: rule in: grammarCoder.
	self assert: coder sourceEditor text asString = rule source.
	self assert: coder collapsedEditor text asString = self semicolonName.
	^ coder
]

{ #category : #'token simulation' }
GtSmaCCCoderExamples >> simulateHex [
	<gtExample>
	| grammar rule simulator nodes |
	grammar := GtSmaCCGrammar forDefinition: '<a> : <hex>; <hex> : [0-9a-fA-F];'.
	rule := grammar ruleNamed: '<a>'.
	simulator := GtSmaCCTokenSimulator on: rule.
	nodes := IdentitySet new.
	simulator
		subscribe: GtSmaCCTokenSimulationAccept
		do: [ :ann | 
			ann nodes
				do: [ :each | nodes add: (each nodeOfType: SmaCCTokenRuleNode) ] ].
	simulator simulateOn: 'a'.
	self assert: nodes size = 2.
	^ simulator
]

{ #category : #'token simulation' }
GtSmaCCCoderExamples >> simulateRight [
	<gtExample>
	| grammar rule simulator errorCount acceptCount input |
	grammar := self smaccDefinitionGrammar.
	rule := grammar ruleNamed: '<right>'.
	simulator := GtSmaCCTokenSimulator on: rule.
	input := 'rihht'.
	errorCount := 0.
	simulator
		subscribe: GtSmaCCTokenSimulationError
		do: [ :ann | 
			ann input = input
				ifTrue: [ errorCount := errorCount + 1.
					self assert: ann index = 3 ] ].
	acceptCount := 0.
	simulator
		subscribe: GtSmaCCTokenSimulationAccept
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

{ #category : #model }
GtSmaCCCoderExamples >> smaccDefinitionGrammarStartingProductions [
	<gtExample>
	| grammar startingProductions names |
	grammar := self smaccDefinitionGrammar.
	startingProductions := grammar startingProductions.
	self assert: startingProductions first name = 'File'.
	names := startingProductions collect: #name.
	self assert: (names includes: 'ProductionRule').
	self assert: (names includes: 'RegexRule').
	self assert: (names includes: 'DirectiveLine').
	self
		assert: (startingProductions allSatisfy: [ :each | each isReferenced ]).
	^ startingProductions
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
