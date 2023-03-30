Class {
	#name : #BaselineOfGToolkit4SmaCC,
	#superclass : #BaselineOf,
	#category : #BaselineOfGToolkit4SmaCC
}

{ #category : #baseline }
BaselineOfGToolkit4SmaCC >> baseline: spec [
	<baseline>
	spec
		for: #common
		do: [ spec
				baseline: 'SmaCCRuntime'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'SmaCCDevelopment'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'SmaCCRewriteEngine'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'SmaCCSampleParsers'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'Antlr4Parser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'ClojureParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'CPPParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'CSharpParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'CSVParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'DelphiParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'DOTParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'GraphQLParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'JavaParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'JSONParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'JSParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'PythonParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'RubyParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'RustParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'TeradataParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'VBNetParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ];
				baseline: 'YAMLParser'
					with: [ spec repository: 'github://j-brant/SmaCC:master/src' ].

			spec
				package: 'GT4SmaCC-Inspector'
					with: [ spec requires: #('SmaCCDevelopment') ];
				package: 'GT4SmaCC-Development-UI'
					with: [ spec requires: #('SmaCCDevelopment') ];
				package: 'GT4SmaCC-Debugger'
					with: [ spec requires: #('GT4SmaCC-Development-UI') ];
				package: 'GT4SmaCC-Stylers'
					with: [ spec
							requires: #('Antlr4Parser' 'ClojureParser' 'CPPParser' 'CSharpParser' 'CSVParser' 'DelphiParser' 'DOTParser' 'GraphQLParser' 'JavaParser' 'JSONParser' 'JSParser' 'PythonParser' 'RubyParser' 'RustParser' 'TeradataParser' 'VBNetParser' 'YAMLParser') ];
				package: 'GT4SmaCC-Queries' with: [ spec requires: #('SmaCCRuntime') ];
				package: 'GT4SmaCC-Examples'
					with: [ spec
							requires: #('SmaCCRuntime' 'SmaCCDevelopment' 'SmaCCRewriteEngine' 'SmaCCSampleParsers' 'Antlr4Parser' 'ClojureParser' 'CPPParser' 'CSharpParser' 'CSVParser' 'DelphiParser' 'DOTParser' 'GraphQLParser' 'JavaParser' 'JSONParser' 'JSParser' 'PythonParser' 'RubyParser' 'RustParser' 'TeradataParser' 'VBNetParser' 'YAMLParser') ];
				package: 'GT4SmaCC-Documentation'
					with: [ spec requires: #('GT4SmaCC-Development-UI') ];
				package: 'GT4SmaCC-Rewrite-Engine-UI'
					with: [ spec requires: #('SmaCCRewriteEngine') ] ]
]
