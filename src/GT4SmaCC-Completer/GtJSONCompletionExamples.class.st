Class {
	#name : #GtJSONCompletionExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #examples }
GtJSONCompletionExamples >> completeInsideValue [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "anything" : { "na }}' asRopedText.
	position := text size - 3.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"name"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeInsideValueWithError [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "anything" : { "na' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"name"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeKey [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "de  }' asRopedText.
	position := text size - 3.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"deleted"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeKeyInError [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "de' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"deleted"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeKeyInList [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "team": [ {"na } ] } ] }' asRopedText.
	position := text asString lastIndexOf: $a.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"name"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeKeyInListWithError [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "team": [ {"na' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"name"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeKeyInString [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '{ "del" : "true" }' asRopedText.
	position := 6.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"deleted'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeUnionKeyInList [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "team": [ {"info": [ { "ty ] } ] } ] }' asRopedText.
	position := text asString lastIndexOf: $y.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"type"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeUnionKeyWithCheck [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "team": [ {"info": [ { "type":"phone", "nu } ] } ] }' asRopedText.
	position := text asString lastIndexOf: $u.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"number"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeUnionKeyWithCheckInError [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "team": [ {"info": [ { "type":"phone", "nu' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"number"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeUnionValueInList [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "team": [ {"info": [ { "type" : "p ] } ] } ] }' asRopedText.
	position := text asString lastIndexOf: $p.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"phone"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeUnknownKeyWithCheck [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "team": [ {"info": [ { "type":"phone", "ci } ] } ] }' asRopedText.
	position := text asString lastIndexOf: $i.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 0.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeValue [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "deleted" : "t  }' asRopedText.
	position := text size - 3.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"true"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeValueInError [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "deleted" : "t' asRopedText.
	position := text size.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"true"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeValueInString [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '{ "deleted" : "t"}' asRopedText.
	position := text size - 2.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"true'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeWithBlock [
	<gtExample>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "computed" : "asdf  }' asRopedText.
	position := text size - 3.
	result := strategy
			completionResultFor: text
			at: position
			requested: false.
	items := (result stream asyncSimilarCopy take: 2) toArray wait.
	self assert: items size equals: 1.
	self assert: items first label equals: '"asdffdsa"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completer [
	<gtExample>
	| completer person trueFalseCompleter address phone object |
	trueFalseCompleter := GtJSONValueCompleter new
			addValue: '"true"';
			addValue: '"false"';
			yourself.
	object := GtJSONObjectCompleter new
			addKey: 'type'
				withValue: (GtJSONValueCompleter new
						addValue: '"phone"';
						addValue: '"address"';
						yourself);
			yourself.
	phone := GtJSONObjectCompleter new
			addCheck: 'type' withValue: '"phone"';
			addKey: 'number';
			addKey: 'primary' withValue: trueFalseCompleter;
			yourself.
	address := GtJSONObjectCompleter new
			addCheck: 'type' withValue: '"address"';
			addKey: 'city';
			addKey: 'state';
			addKey: 'zip';
			addKey: 'primary';
			yourself.
	phone := GtJSONObjectCompleter new
			addCheck: 'type' withValue: '"phone"';
			addKey: 'number';
			addKey: 'primary' withValue: trueFalseCompleter;
			yourself.
	person := GtJSONObjectCompleter new
			addKey: 'name';
			addKey: 'info'
				withValue: (GtJSONListCompleter new
						itemCompleter: (GtJSONUnionCompleter new
								addCompleter: object;
								addCompleter: phone;
								addCompleter: address;
								yourself);
						yourself);
			addKey: 'deleted' withValue: trueFalseCompleter;
			yourself.
	completer := GtJSONObjectCompleter new.
	completer
		addKey: 'deleted' withValue: trueFalseCompleter;
		addKey: 'computed'
			withValue: (GtJSONBlockCompleter new
					block: [ :string :position | 
						(string size > 1 and: [ string last ~= $" ])
							ifTrue: [ | new |
								new := string , string reversed.
								{GtInsertTextCompletionAction
										labeled: new asRopedText
										completion: (new allButFirst: string size)
										position: position
										from: position - string size + 1} ]
							ifFalse: [ #() ] ]);
		addKey: 'team' withValue: (GtJSONListCompleter new itemCompleter: person);
		valueCompleter: person.
	^ completer
]

{ #category : #examples }
GtJSONCompletionExamples >> completionStrategy [
	<gtExample>
	^ GtJSONCompletionStrategy new
		completer: self completer;
		yourself
]
