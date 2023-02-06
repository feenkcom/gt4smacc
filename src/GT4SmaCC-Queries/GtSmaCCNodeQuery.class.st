Class {
	#name : #GtSmaCCNodeQuery,
	#superclass : #GtSmaCCQuery,
	#instVars : [
		'nodes'
	],
	#category : #'GT4SmaCC-Queries'
}

{ #category : #querying }
GtSmaCCNodeQuery >> / aClassOrName [
	| result name |
	result := self class new.
	name := self nameFor: aClassOrName.
	self
		do: [ :node | 
			node
				nodesDo: [ :each | (self does: name match: each class name) ifTrue: [ result addNode: each ] ] ].
	^ result
]

{ #category : #querying }
GtSmaCCNodeQuery >> // aClassOrName [
	| result name |
	result := self class new.
	name := self nameFor: aClassOrName.
	self
		do: [ :node | 
			node
				allNodesDo: [ :each | (self does: name match: each class name) ifTrue: [ result addNode: each ] ] ].
	^ result
]

{ #category : #querying }
GtSmaCCNodeQuery >> //@ aName [
	| result |
	result := self class new.
	self
		do: [ :each | 
			each
				allNodesDo:
					[ :node | self addNodeAttributesNamed: aName from: node into: result ] ].
	^ result
]

{ #category : #querying }
GtSmaCCNodeQuery >> /@ aName [
	| result |
	result := self class new.
	self
		do: [ :each | self addNodeAttributesNamed: aName from: each into: result ].
	^ result
]

{ #category : #querying }
GtSmaCCNodeQuery >> @ anAttribute [
	^ GtSmaCCAttributeQuery new
		query: self;
		attributeName: anAttribute;
		yourself
]

{ #category : #querying }
GtSmaCCNodeQuery >> \ anObject [
	| result name |
	result := self class new.
	name := self nameFor: anObject.
	self
		do: [ :node | 
			name isInteger
				ifTrue: [ | current |
					current := node.
					name timesRepeat: [ current notNil ifTrue: [ current := current parent ] ].
					current notNil ifTrue: [ result addNode: current ] ]
				ifFalse: [ (self does: name match: node parent class name)
						ifTrue: [ result addNode: node parent ] ] ].
	^ result
]

{ #category : #querying }
GtSmaCCNodeQuery >> \\ aName [
	| result name |
	result := self class new.
	name := self nameFor: aName.
	self
		do: [ :node | 
			| current found |
			current := node.
			found := false.
			[ current notNil
				ifTrue: [ found := self does: name match: current class name ].
			found or: [ current isNil ] ] whileFalse: [ current := current parent ].
			found ifTrue: [ result addNode: current ] ].
	^ result
]

{ #category : #adding }
GtSmaCCNodeQuery >> addNode: aNode [
	nodes add: aNode
]

{ #category : #private }
GtSmaCCNodeQuery >> addNodeAttributesNamed: aName from: each into: result [
	each nodeVariables
		do: [ :selector | 
			(self does: aName match: selector)
				ifTrue:
					[ (each perform: selector) ifNotNil: [ :node | result addNode: node ] ] ].
	^ each compositeNodeVariables
		do: [ :selector | 
			(self does: aName match: selector)
				ifTrue: [ (each perform: selector)
						ifNotNil: [ :nodes | nodes do: [ :node | result addNode: node ] ] ] ]
]

{ #category : #testing }
GtSmaCCNodeQuery >> allSatisfy: aBlock [
	^ nodes allSatisfy: aBlock
]

{ #category : #accessing }
GtSmaCCNodeQuery >> anyOne [
	^ nodes anyOne
]

{ #category : #testing }
GtSmaCCNodeQuery >> anySatisfy: aBlock [
	^ nodes anySatisfy: aBlock
]

{ #category : #conversion }
GtSmaCCNodeQuery >> asOrderedCollection [
	| result |
	result := OrderedCollection new.
	self do: [ :each | result add: each ].
	^ result
]

{ #category : #iterating }
GtSmaCCNodeQuery >> collect: aBlock [
	^ nodes collect: aBlock
]

{ #category : #iterating }
GtSmaCCNodeQuery >> detect: aBlock ifNone: noneBlock [
	^ nodes detect: aBlock ifNone: noneBlock
]

{ #category : #iterating }
GtSmaCCNodeQuery >> do: aBlock [
	nodes do: aBlock
]

{ #category : #iterating }
GtSmaCCNodeQuery >> groupedBy: aBlock [
	^ nodes groupedBy: aBlock
]

{ #category : #inspecting }
GtSmaCCNodeQuery >> gtAttributesFor: aView [
	<gtView>
	^ aView columnedList
		priority: 40;
		title: 'Nodes';
		items: [ self asOrderedCollection ];
		column: 'Node' text: [ :each | each ]
]

{ #category : #initialization }
GtSmaCCNodeQuery >> initialize [
	super initialize.
	nodes := IdentitySet new
]

{ #category : #testing }
GtSmaCCNodeQuery >> isEmpty [
	^ nodes isEmpty
]

{ #category : #querying }
GtSmaCCNodeQuery >> nameFor: aClassOrName [
	^ aClassOrName isBehavior
		ifTrue: [ aClassOrName name ]
		ifFalse: [ aClassOrName ]
]

{ #category : #testing }
GtSmaCCNodeQuery >> notEmpty [
	^ nodes notEmpty
]

{ #category : #iterating }
GtSmaCCNodeQuery >> select: aBlock [
	^ nodes select: aBlock
]

{ #category : #accessing }
GtSmaCCNodeQuery >> size [
	^ nodes size
]
