Class {
	#name : #GtSmaCCTokenSimulator,
	#superclass : #GtSmaCCSimulator,
	#category : #'GT4SmaCC-Development-UI-Simulation'
}

{ #category : #ui }
GtSmaCCTokenSimulator >> asElement [
	^ GtSmaCCTokenSimulatorElement onSimulator: self
]

{ #category : #private }
GtSmaCCTokenSimulator >> buildSimulator [
	| definitionAST |
	definitionAST := self grammar ast.
	simulator := SmaCCRegexSimulator
		on: definitionAST
		tokenName: self ruleName
]

{ #category : #running }
GtSmaCCTokenSimulator >> simulateOn: aString [
	simulator
		matchesOn: aString
		do: [ :index :nodes | 
			nodes isNil
				ifTrue:
					[ self announce: (GtSmaCCTokenSimulationError input: aString index: index) ]
				ifFalse: [ self
						announce: (GtSmaCCTokenSimulationAccept input: aString index: index nodes: nodes) ] ]
]
