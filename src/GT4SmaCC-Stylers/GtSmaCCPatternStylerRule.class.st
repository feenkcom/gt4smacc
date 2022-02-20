Class {
	#name : #GtSmaCCPatternStylerRule,
	#superclass : #GtSmaCCStylerRule,
	#instVars : [
		'patternAST'
	],
	#category : 'GT4SmaCC-Stylers'
}

{ #category : #'instance creation' }
GtSmaCCPatternStylerRule class >> pattern: anAST styleBlock: aBlock [
	^ (self styleBlock: aBlock)
		patternAST: anAST;
		yourself
]

{ #category : #accessing }
GtSmaCCPatternStylerRule >> patternAST [
	^ patternAST
]

{ #category : #accessing }
GtSmaCCPatternStylerRule >> patternAST: anAST [
	patternAST := anAST
]

{ #category : #testing }
GtSmaCCPatternStylerRule >> shouldApplyToNode: aSmaCCParseNode [
	^ patternAST match: aSmaCCParseNode inContext: Dictionary new
]
