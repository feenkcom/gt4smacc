Class {
	#name : #GtSmaCCRewriteElement,
	#superclass : #GtSmaCCRewriteAccordion,
	#category : #'GT4SmaCC-Rewrite-Engine-UI'
}

{ #category : #updating }
GtSmaCCRewriteElement >> contentElement [
	| matchElement transformationElement |
	matchElement := GtSmaCCMatchElement rewrite: rewrite.
	transformationElement := GtSmaCCTransformationElement rewrite: rewrite.
	^ BlElement new
		look: BrLayoutLook linearVertical vFitContent hMatchParent;
		addChild: matchElement;
		addChild: transformationElement;
		yourself
]
