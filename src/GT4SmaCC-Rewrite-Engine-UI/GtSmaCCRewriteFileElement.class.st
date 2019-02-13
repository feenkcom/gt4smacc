Class {
	#name : #GtSmaCCRewriteFileElement,
	#superclass : #BrAccordion,
	#instVars : [
		'file'
	],
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #'instance creation' }
GtSmaCCRewriteFileElement class >> file: aRewriteFile [
	^ self new
		file: aRewriteFile;
		yourself
]

{ #category : #accessing }
GtSmaCCRewriteFileElement >> file [
	^ file
]

{ #category : #accessing }
GtSmaCCRewriteFileElement >> file: aSmaCCRewriteFile [
	file := aSmaCCRewriteFile.
	self updateContent
]

{ #category : #initialization }
GtSmaCCRewriteFileElement >> initialize [
	super initialize.
	self look: BrGlamorousAccordionWithBorderLook new
]

{ #category : #initialization }
GtSmaCCRewriteFileElement >> updateContent [
	self
		content: [ BrSimpleList new
				border: (BlBorder paint: BrGlamorousColors editorBorderColor width: 1);
				constraintsDo: [ :c | 
					c horizontal matchParent.
					c vertical fitContent ];
				height: 400;
				stencil: [ :each :index | 
					each element
						margin: (BlInsets top: 2 left: 5 bottom: 5 right: 5);
						yourself ];
				items: file rewrites;
				yourself ].
	self
		header: [ BrButton new
				look: BrGlamorousAccordionHeaderLook new;
				label: file displayString;
				action: [ self toggle ];
				yourself ]
]
