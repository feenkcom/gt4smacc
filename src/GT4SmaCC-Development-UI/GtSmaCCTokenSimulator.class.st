Class {
	#name : #GtSmaCCTokenSimulator,
	#superclass : #Object,
	#traits : 'TGtAnnouncer',
	#classTraits : 'TGtAnnouncer classTrait',
	#instVars : [
		'announcer',
		'tokenRule',
		'simulator'
	],
	#category : #'GT4SmaCC-Development-UI-Simulation'
}

{ #category : #'instance creation' }
GtSmaCCTokenSimulator class >> on: aTokenRule [
	^ self new
		tokenRule: aTokenRule;
		yourself
]

{ #category : #accessing }
GtSmaCCTokenSimulator >> announcer [
	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #private }
GtSmaCCTokenSimulator >> buildSimulator [
	| definitionAST |
	definitionAST := self grammar ast.
	simulator := SmaCCRegexSimulator
		on: definitionAST
		tokenName: self tokenName
]

{ #category : #accessing }
GtSmaCCTokenSimulator >> grammar [
	^ tokenRule grammar
]

{ #category : #running }
GtSmaCCTokenSimulator >> simulateOn: aString [
	simulator
		matchesOn: aString
		do: [ :index :nodes | 
			nodes isNil
				ifTrue:
					[ self announce: (GtSmaCCSimulationError input: aString index: index) ]
				ifFalse: [ self
						announce: (GtSmaCCSimulationAccept input: aString index: index nodes: nodes) ] ]
]

{ #category : #accessing }
GtSmaCCTokenSimulator >> tokenName [
	^ tokenRule name
]

{ #category : #accessing }
GtSmaCCTokenSimulator >> tokenRule [
	^ tokenRule
]

{ #category : #'initialize-release' }
GtSmaCCTokenSimulator >> tokenRule: aTokenRule [
	tokenRule := aTokenRule.
	self buildSimulator
]
