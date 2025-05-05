Class {
	#name : #GtJSONCompletionExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Completer-JSON'
}

{ #category : #examples }
GtJSONCompletionExamples >> completeEmptyRequested [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '{  }' asRopedText.
	position := 2.
	result := strategy
			completionResultFor: text
			at: position
			requested: true.
	items := (result stream asyncSimilarCopy take: 5) toArray wait.
	self assert: items size equals: 3.
	self assert: items first label equals: '"computed"'.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeEmptyValueBeforeNumber [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "deleted" :
3}' asRopedText.
	position := text asString indexOf: $:.
	result := strategy
			completionResultFor: text
			at: position
			requested: true.
	items := (result stream asyncSimilarCopy take: 5) toArray wait.
	self assert: items size equals: 0.
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeEmptyValueBeforePairRequested [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "deleted" :
"team" :  []}' asRopedText.
	position := text asString indexOf: $:.
	result := strategy
			completionResultFor: text
			at: position
			requested: true.
	items := (result stream asyncSimilarCopy take: 5) toArray wait.
	self assert: items size equals: 2.
	self assert: (items collect: #label) sort equals: #('"false"' '"true"').
	^ result
]

{ #category : #examples }
GtJSONCompletionExamples >> completeInsideValue [
	<gtExample>
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
GtJSONCompletionExamples >> completeKeyBeforePair [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "de  
"team" :  []}' asRopedText.
	position := text asString indexOf: $e.
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
GtJSONCompletionExamples >> completeValueBeforePair [
	<gtExample>
	<return: #GtStreamedCompletionResult>
	| strategy result items text position |
	strategy := self completionStrategy.
	text := '
{ "computed"  : "",
 "deleted": "tr
"team" :  []}' asRopedText.
	position := text asString indexOf: $r.
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtStreamedCompletionResult>
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
	<return: #GtJSONObjectCompleter>
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
	<return: #GtJSONCompletionStrategy>
	^ GtJSONCompletionStrategy new
		completer: self completer;
		yourself
]
