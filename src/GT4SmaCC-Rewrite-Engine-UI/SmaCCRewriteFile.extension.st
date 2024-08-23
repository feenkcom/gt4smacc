Extension { #name : #SmaCCRewriteFile }

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCRewriteFile >> asElement [
	^ GtSmaCCRewriteFileElement rewrite: self
]

{ #category : #'*GT4SmaCC-Rewrite-Engine-UI' }
SmaCCRewriteFile >> gtRulesByClassFor: aView [
	<gtView>
	| rewritesForClasses |
	^ aView tree
		title: 'Rules by class';
		priority: 40;
		items: [ | items |
			rewritesForClasses := Dictionary new.
			SmaCCParseNode
				withAllSubclassesDo: [ :each | rewritesForClasses at: each put: (self listForClass: each) ].
			items := rewritesForClasses associations
					reject: [ :each | 
						each value isNil
							or: [ each value = (rewritesForClasses at: each key superclass ifAbsent: [  ]) ] ].
			(items collect: #key) asSortedCollection: [ :a :b | a name < b name ] ];
		children: [ :each | 
			each isBehavior
				ifTrue: [ (rewritesForClasses at: each) allRewrites ]
				ifFalse: [ #() ] ];
		itemText: [ :each | each displayString ]
]
