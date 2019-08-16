Class {
	#name : #GtSmaCCGrammarVariableCoderElement,
	#superclass : #GtSmaCCListCoderElement,
	#category : #'GT4SmaCC-Development-UI-UI'
}

{ #category : #ui }
GtSmaCCGrammarVariableCoderElement >> coderListElementClass [
	^ GtSmaCCVariableListElement
]

{ #category : #accessing }
GtSmaCCGrammarVariableCoderElement >> group [
	^ grammarCoder variableGroup
]
