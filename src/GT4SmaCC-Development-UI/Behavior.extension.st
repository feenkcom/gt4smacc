Extension { #name : #Behavior }

{ #category : #'*GT4SmaCC-Development-UI' }
Behavior >> gtAddParserTab: look [
	<gtCreateComponentTab: 100>
	^ BrTab new
		aptitude: BrGlamorousTabAptitude new;
		label: 'SmaCC';
		stencil: [ | element navigationModel |
			element := GtSmaCCCreateParserElement new.
			navigationModel := look phlow firstParentWithView navigationModel.
			element
				behaviorBlock: [ :cls | 
					look fireEvent: BrDropdownHideWish new.
					navigationModel selectClass: cls ].
			navigationModel selectedPackageDo: [ :package | element forPackage: package ].
			navigationModel selectedTagDo: [ :tag | element forPackageTag: tag ].
			element ]
]
