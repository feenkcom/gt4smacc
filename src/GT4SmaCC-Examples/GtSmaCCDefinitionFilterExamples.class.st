Class {
	#name : #GtSmaCCDefinitionFilterExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Examples'
}

{ #category : #examples }
GtSmaCCDefinitionFilterExamples >> implementorsFilter [
	<gtExample>
	| filtered |
	filtered := (GtSmaCCDefinitionImplementorPatternFilter pattern: 'tok')
		applyInScope: (GtSmaCCGrammarCoder onParser: SmaCCDefinitionParser) coders.
	self assert: filtered size > 1.
	^ filtered
]

{ #category : #examples }
GtSmaCCDefinitionFilterExamples >> referencesFilter [
	<gtExample>
	| filtered |
	filtered := (GtSmaCCDefinitionReferencesFilter name: 'TokenList')
		applyInScope: (GtSmaCCGrammarCoder onParser: SmaCCDefinitionParser) coders.
	self assert: filtered size > 1.
	^ filtered
]

{ #category : #examples }
GtSmaCCDefinitionFilterExamples >> tokenReferencesFilter [
	<gtExample>
	| filtered |
	filtered := (GtSmaCCDefinitionReferencesFilter name: '<name>')
		applyInScope: (GtSmaCCGrammarCoder onParser: SmaCCDefinitionParser) coders.
	self assert: filtered size > 1.
	^ filtered
]
