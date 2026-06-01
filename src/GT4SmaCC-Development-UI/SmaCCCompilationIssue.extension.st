Extension { #name : #SmaCCCompilationIssue }

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCCompilationIssue >> displayText [
	^ self displayString asRopedText
]

{ #category : #'*GT4SmaCC-Development-UI' }
SmaCCCompilationIssue >> gtDisplayStringFor: aView [
	<gtView>
	^ aView textEditor
		title: 'Display';
		text: [ self displayText ]
]
