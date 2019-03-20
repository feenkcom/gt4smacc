Class {
	#name : #GtSmaCCDefinitionGroupResult,
	#superclass : #GtSearchTypedGroupResult,
	#category : #'GT4SmaCC-Development-UI-Filters'
}

{ #category : #elements }
GtSmaCCDefinitionGroupResult >> asElement [
	^ GtSmaCCDefinitionListElement new
		coders: self;
		yourself
]

{ #category : #ui }
GtSmaCCDefinitionGroupResult >> gtLiveFor: aView [
	<gtView>
	^ aView explicit 
		title: 'Live';
		priority: 0;
		stencil: [ self ]
]

{ #category : #enumerating }
GtSmaCCDefinitionGroupResult >> itemsDo: aBlock [
	self do: aBlock
]
