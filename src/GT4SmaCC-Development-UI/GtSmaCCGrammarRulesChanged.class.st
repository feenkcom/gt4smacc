Class {
	#name : 'GtSmaCCGrammarRulesChanged',
	#superclass : 'GtSmaCCGrammarAnnouncement',
	#instVars : [
		'grammar'
	],
	#category : 'GT4SmaCC-Development-UI-Model'
}

{ #category : 'instance creation' }
GtSmaCCGrammarRulesChanged class >> forGrammar: aGrammar [
	^ self new
		grammar: aGrammar;
		yourself
]

{ #category : 'accessing' }
GtSmaCCGrammarRulesChanged >> grammar [
	^ grammar
]

{ #category : 'accessing' }
GtSmaCCGrammarRulesChanged >> grammar: aGrammar [
	grammar := aGrammar
]
