Extension { #name : #SmaCCParser }

{ #category : #'*GT4SmaCC-Stylers' }
SmaCCParser class >> gtStyler [
	| stylers |
	stylers := self gtStylers.
	^ stylers isEmpty
		ifTrue: [ nil ]
		ifFalse: [ stylers first ]
]

{ #category : #'*GT4SmaCC-Stylers' }
SmaCCParser class >> gtStylers [
	| pragmas |
	pragmas := OrderedCollection new.
	(Pragma pragmaCache at: #smaccStyler:priority:)
		do: [ :each | 
			(each method methodClass isClassSide
				and: [ each method isInstalled
						and: [ (self
								includesBehavior: (Smalltalk at: each arguments first ifAbsent: [ Array ]))
								and: [ each method numArgs = 1 ] ] ]) ifTrue: [ pragmas add: each ] ].
	^ (pragmas asSortedCollection: [ :a :b | a arguments last < b arguments last ])
		collect: [ :each | each method methodClass instanceSide perform: each method selector with: self ]
]
