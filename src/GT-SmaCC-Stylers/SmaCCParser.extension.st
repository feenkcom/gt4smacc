Extension { #name : #SmaCCParser }

{ #category : #'*GT-SmaCC-Stylers' }
SmaCCParser class >> gtStyler [
	| stylers |
	stylers := self gtStylers.
	^ stylers isEmpty
		ifTrue: [ nil ]
		ifFalse: [ stylers first ]
]

{ #category : #'*GT-SmaCC-Stylers' }
SmaCCParser class >> gtStylers [
	| pragmas |
	pragmas := OrderedCollection new.
	Smalltalk
		allClassesAndTraitsDo: [ :each | 
			(Pragma allNamed: #smaccStyler:priority: in: each classSide)
				do: [ :pragma | 
					pragma arguments first = self name
						ifTrue: [ pragmas add: pragma ] ] ].
	^ (pragmas
		asSortedCollection: [ :a :b | a arguments last < b arguments last ])
		collect:
			[ :each | each method methodClass instanceSide perform: each method selector ]
]
