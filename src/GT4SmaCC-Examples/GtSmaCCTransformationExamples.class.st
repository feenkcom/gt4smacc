Class {
	#name : #GtSmaCCTransformationExamples,
	#superclass : #Object,
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> addTemporaries [
	^ SmaCCRewrite
		comment: 'add vars to file'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleFileNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: '(self processTemporariesAround: [self continue]) 
		ifNotNil: [:str | self insert: str, String cr before: match ]')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> addVariables [
	^ SmaCCRewrite
		comment: 'variable'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleVariableNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self temporaryVariables add: match name source.
self continue')
]

{ #category : #private }
GtSmaCCTransformationExamples >> checkRewrite: source equals: rewrittenSource whenRewrittenUsing: script [
	| tree rewriteResult rewriter |
	tree := GtSmaCCTransformationExampleParser parse: source.
	rewriter := SmaCCRewriteEngine new.
	rewriter source: (SmaCCAnnotatedString on: tree completeSource asString).
	rewriter rewriteRule: script.
	rewriteResult := rewriter rewrite: tree.
	self
		assert: rewriteResult asString withInternalLineEndings
		equals: rewrittenSource withInternalLineEndings.
	^ rewriteResult
]

{ #category : #private }
GtSmaCCTransformationExamples >> completeSource [
	^ 'function newline()
begin
	print ''''.
end

function output(a)
begin
	print a.
end

function pow(a;b)
begin
	return a ^ b.
end

x := 1 + 2 * 3 / 4 ^ 5.
if x < 1.005 then
	print ''Wrong''.
else if (x >= 1.006) then
	print ''Wrong''.
else
	output(''Close enough'').

newline().
input y.
i := 1.
while i <= 4 do begin
	print '''' , y, ''^'', i , '' = '',  pow(y;i).
	i := i + 1.
end
'
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> computeFunctionNames [
	^ SmaCCRewrite
		comment: 'initialize function names'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleFileNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self functions: Set new.
match withAllNodesOfType: GtSmaCCTransformationExampleFunctionNode do: [:each | self functions add: each name source].
self continue')
]

{ #category : #'examples - rewriting' }
GtSmaCCTransformationExamples >> convertBeginEnd [
	<gtExample>
	| script source rewrittenSource |
	script := self exampleScript.
	script addTransformation: self jsBeginEndTransformation.
	source := self factorialSource.
	rewrittenSource := '// Factorial
function factorial(a)
{
	result := 1.
	if (a < 1) then return result.
	while a > 0 do
	{
		result := result * a.
		a := a - 1.
	}
	RETURN result.
}


print ''Enter a number''.
input x.
print ''Factorial = '' , factorial(x).'.
	^ self
		checkRewrite: source
		equals: rewrittenSource
		whenRewrittenUsing: script
]

{ #category : #'examples - rewriting' }
GtSmaCCTransformationExamples >> convertCompleteJS [
	<gtExample>
	| script source rewrittenSource |
	script := self jsScript.
	source := self completeSource.
	rewrittenSource := 'var i,x,y;
function newline()
{
	console.log('''');
}

function output(a)
{
	console.log(a);
}

function pow(a,b)
{
	return Math.pow(a, b);
}

x = 1 + 2 * 3 / Math.pow(4, 5);
if (x < 1.005)
	console.log(''Wrong'');
else if (x >= 1.006)
	console.log(''Wrong'');
else
	output(''Close enough'');

newline();
y = prompt();
i = 1;
while (i <= 4) {
	console.log('''' + y+ ''^''+ i + '' = ''+  pow(y,i));
	i++;
}
'.
	^ self
		checkRewrite: source
		equals: rewrittenSource
		whenRewrittenUsing: script
]

{ #category : #'examples - rewriting' }
GtSmaCCTransformationExamples >> convertCopyingBeginEnd [
	<gtExample>
	| script source rewrittenSource |
	script := self exampleScript.
	script addTransformation: self jsCopyingBeginEndTransformation.
	source := self factorialSource.
	rewrittenSource := '// Factorial
function factorial(a)
{
	result := 1.
	if (a < 1) then return result.
	while a > 0 do
	{
		result := result * a.
		a := a - 1.
	}
	RETURN result.
}


print ''Enter a number''.
input x.
print ''Factorial = '' , factorial(x).'.
	^ self
		checkRewrite: source
		equals: rewrittenSource
		whenRewrittenUsing: script
]

{ #category : #'examples - rewriting' }
GtSmaCCTransformationExamples >> convertJS [
	<gtExample>
	| script source rewrittenSource |
	script := self jsScript.
	source := self factorialSource.
	rewrittenSource := 'var x;
// Factorial
function factorial(a)
{
	var result;
	result = 1;
	if (a < 1) return result;
	while (a > 0)
	{
		result = result * a;
		a = a - 1;
	}
	return result;
}


console.log(''Enter a number'');
x = prompt();
console.log(''Factorial = '' + factorial(x));'.
	^ self
		checkRewrite: source
		equals: rewrittenSource
		whenRewrittenUsing: script
]

{ #category : #'examples - rewriting' }
GtSmaCCTransformationExamples >> convertST [
	<gtExample>
	| script source rewrittenSource |
	script := self stScript.
	source := self factorialSource.
	rewrittenSource := '| x |
"Factorial"
factorial := [:_a |
| result a |
	a := _a.
	result := 1.
	(a < 1) ifTrue: [thisContext return: result.].
	[ a > 0 ] whileTrue:
	[
		result := result * a.
		a := a - 1.
	].
	result.
].


Transcript print:  ''Enter a number''; cr; flush.
x := self uiManager request: '''' initialAnswer: ''''.
Transcript print:  ''Factorial = '' , (factorial value: x); cr; flush.'.
	^ self
		checkRewrite: source
		equals: rewrittenSource
		whenRewrittenUsing: script
]

{ #category : #'examples - scripts' }
GtSmaCCTransformationExamples >> exampleScript [
	| script filename |
	filename := FileSystem memory / 'rewrites.rw'.
	script := SmaCCRewriteFile new.
	script parserClass: GtSmaCCTransformationExampleParser.
	script filename: filename.
	^ script
]

{ #category : #private }
GtSmaCCTransformationExamples >> factorialSource [
	<gtExample>
	^ '// Factorial
function factorial(a)
begin
	result := 1.
	if (a < 1) then return result.
	while a > 0 do
	begin
		result := result * a.
		a := a - 1.
	end
	RETURN result.
end


print ''Enter a number''.
input x.
print ''Factorial = '' , factorial(x).'
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsBeginEndTransformation [
	<gtExample>
	^ SmaCCRewrite
		comment: 'Convert begin/end to {}'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleBlockNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self replace: match beginToken with: ''{''.
self replace: match endToken with: ''}''.
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsCallExpression [
	^ SmaCCRewrite
		comment: 'function calls'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleCallExpressionNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self replaceAll: match semicolons with: '',''.
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsConvertAssignmentStatement [
	^ SmaCCRewrite
		comment: 'assignment'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleAssignmentNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self replace: match assignmentToken with: ''=''.
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsConvertBinaryExpression [
	^ SmaCCRewrite
		comment: 'binary expressions'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleBinaryExpressionNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'match operator source = '','' ifTrue: [self replace: match operator with: ''+''].
match operator source = ''^'' ifTrue: [self insert: ''Math.pow('' before: match.
	self insert: '')'' after: match.
	self deleteWhitespaceBefore: match operator.
	self replace: match operator with: '',''].
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsConvertFunctionStatement [
	^ SmaCCRewrite
		comment: 'function'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleFunctionNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: '| vars |
self replaceAll: match semicolons with: '',''.
vars := self temporaryVariables.
self temporaryVariables: vars copy.
match parameters do: [:each | self temporaryVariables add: each name source].
(self processTemporariesAround: [self continue]) 
		ifNotNil: [:str | self insert: String cr, (self startOfLineWhitespaceBefore: match body) asString , ''	'',  str after: match body beginToken ].
self temporaryVariables: vars')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsConvertIfStatement [
	^ SmaCCRewrite
		comment: 'if'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleIfNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self replace: match ifToken with: ''if''.
self deleteWithWhitespaceBefore: match thenToken.
match elseToken ifNotNil: [ self replace: match elseToken with: ''else'' ].
match condition leftParens isEmpty ifTrue: [ self insert: #(''('' '')'') around: match condition ].
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsConvertInputStatement [
	^ SmaCCRewrite
		comment: 'input'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleInputNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self deleteWithWhitespaceAfter: match inputToken.
self insert: '' = prompt()'' after: match variable.
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsConvertPeriodsToSemicolons [
	<gtExample>
	^ SmaCCRewrite
		comment: 'periods'
		match: ((SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleStatementNode)
				code: 'match period notNil "errors are handled as not matching"';
				yourself)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self replace: match period with: '';''.
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsConvertPlusOne [
	<gtExample>
	^ SmaCCRewrite
		comment: 'convert "var := var + 1." into "var++;"'
		match: (SmaCCRewriteTreeMatch new
				source: '`var` := `var` + 1.';
				startingState: 'Statement';
				yourself)
		transformation: (SmaCCRewriteStringTransformation on: '`var`++;')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsConvertPrintStatement [
	^ SmaCCRewrite
		comment: 'print'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExamplePrintNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self deleteWhitespaceAfter: match printToken.
self replace: match printToken with: ''console.log(''.
self continue.
self insert: '')'' after: match value')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsConvertReturnStatement [
	^ SmaCCRewrite
		comment: 'return'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleReturnNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self replace: match returnToken with: ''return''.
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsConvertWhileStatement [
	^ SmaCCRewrite
		comment: 'while'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleWhileNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self replace: match whileToken with: ''while''.
self deleteWithWhitespaceBefore: match doToken.
match condition leftParens isEmpty ifTrue: [ self insert: #(''('' '')'') around: match condition ].
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsCopyingBeginEndTransformation [
	<gtExample>
	^ SmaCCRewrite
		comment: 'Convert begin/end to {}'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleBlockNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: '| ws |
self continue.
ws := self startOfLineWhitespaceBefore: match.
self 
	replace: match 
	with: (String 
		streamContents: 
			[:stream | 
			stream nextPut: ${.
			match statements do: [:each | stream cr; nextPutAll: ws; nextPut: Character tab; nextPutAll: (self sourceFor: each)].
			stream cr; nextPutAll: ws; nextPut: $}])')
]

{ #category : #'examples - scripts' }
GtSmaCCTransformationExamples >> jsScript [
	<gtExample>
	| script |
	script := self exampleScript.
	script addTransformation: self properties.
	script addTransformation: self jsTemporariesMethod.
	script addTransformation: self computeFunctionNames.
	script addTransformation: self addTemporaries.
	script addTransformation: self jsConvertPeriodsToSemicolons.
	script addTransformation: self jsConvertFunctionStatement.
	script addTransformation: self jsConvertIfStatement.
	script addTransformation: self jsConvertWhileStatement.
	script addTransformation: self jsConvertReturnStatement.
	script addTransformation: self jsConvertPlusOne.
	script addTransformation: self jsConvertAssignmentStatement.
	script addTransformation: self jsBeginEndTransformation.
	script addTransformation: self jsConvertPrintStatement.
	script addTransformation: self jsConvertInputStatement.
	script addTransformation: self jsConvertBinaryExpression.
	script addTransformation: self jsCallExpression.
	script addTransformation: self addVariables.
	^ script
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> jsTemporariesMethod [
	<gtExample>
	^ SmaCCRewriteMethodDefinition
		source: 'processTemporariesAround: aBlock
	| vars newVars |
	vars := self temporaryVariables ifNil: [Set new].
	self temporaryVariables: (newVars := Set new).
	aBlock value.
	self temporaryVariables: vars.
	self functions do: [:each | newVars remove: each ifAbsent: []].
	vars do: [:each | newVars remove: each ifAbsent: []].
	^ newVars notEmpty ifTrue: [ ''var '' , ('','' join: newVars asSortedCollection) , '';''  ]'
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> properties [
	<gtExample>
	^ SmaCCRewritePropertyDefinition
		comment: nil
		locals: #('temporaryVariables' 'functions')
		globals: #()
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stAssignmentStatement [
	^ SmaCCRewrite
		comment: 'assignment'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleAssignmentNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self assignedVariables add: match variable name source.
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stBeginEndTransformation [
	^ SmaCCRewrite
		comment: 'Convert begin/end to []'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleBlockNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'match parent class = match class 
	ifTrue: 
		[self deleteWithWhitespaceAfter: match beginToken.
		self deleteWithWhitespaceBefore: match endToken]
	ifFalse: 
		[self replace: match beginToken with: ''[''.
		self replace: match endToken with: '']''].
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stCallExpression [
	^ SmaCCRewrite
		comment: nil
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleCallExpressionNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'match args isEmpty 
	ifTrue: 
		[self replace: match left with: '' ''.
		self replace: match right with: ''value'']
	ifFalse: 
		[self deleteAllWithWhitespaceAfter: match semicolons.
		self insert: '' value: '' beforeAll: match args].
self delete: match left.
self delete: match right.
(match parent isKindOf: GtSmaCCTransformationExampleExpressionNode) ifTrue: [self insert: #(''('' '')'') around: match].
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stConvertBinaryExpression [
	^ SmaCCRewrite
		comment: nil
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleBinaryExpressionNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'match operator source = ''^'' ifTrue: [self replace: match operator with: ''**''].
(match leftParens isEmpty and: [match parent class = match class and: [match parent right == match]]) ifTrue: [self insert: #(''('' '')'') around: match].
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stConvertComments [
	^ SmaCCRewrite
		comment: 'convert comments'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleFileNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'match comments do: [:each | self replaceFrom: each first to: each first + 1 with: ''"''.
				self deleteWhitespaceAfter: each first + 1.
				self insert: ''"'' after: each last].
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stConvertFunctionStatement [
	^ SmaCCRewrite
		comment: 'function'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleFunctionNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: '| vars assignedParms temps |
self deleteWithWhitespaceAfter: match functionToken.
self replace: match left with: ''[''.
self deleteAllWithWhitespaceAfter: match semicolons.
self insert: '':'' beforeAll: match parameters.
self insert: '' := '' after: match name.
self deleteWithWhitespaceBefore: match right.
match parameters isEmpty 
	ifTrue: [self deleteWithWhitespaceBefore: match right] 
	ifFalse: [self replace: match right with: '' |''].
vars := self temporaryVariables.
self temporaryVariables: vars copy.
match parameters do: [:each | self temporaryVariables add: each name source].
self replace: match body endToken with: '']''.
(self processTemporariesAround: [self processChildren: match body statements]) 
		ifNil: [temps := '''']
		ifNotNil: [:str | temps := str ].
assignedParms := match parameters select: [:each | self assignedVariables includes: each name source].
assignedParms notEmpty ifTrue: [
	assignedParms reverseDo: [:each | 
		self insert: ''_'' before: each name.
		self insert: each name source , '' := _'' , each name source , ''.'', String cr, (self startOfLineWhitespaceBefore: match body statements first) before: match body statements first].
	temps isEmpty 
		ifTrue: [temps := ''| '' , ('' '' join: (assignedParms collect: #source)) , '' |'']
		ifFalse: [temps := temps allButLast , ('' '' join: (assignedParms collect: #source)) , '' |'']
].
temps isEmpty 
	ifTrue: [self deleteWithWhitespaceBefore: match body beginToken]
	ifFalse: [self replace: match body beginToken with: temps].
self insert: ''.'' after: match.
self temporaryVariables: vars')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stConvertIfStatement [
	^ SmaCCRewrite
		comment: 'if'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleIfNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self deleteWithWhitespaceAfter: match ifToken.
self replace: match thenToken with: ''ifTrue:''.
(match then isKindOf: GtSmaCCTransformationExampleBlockNode) ifFalse: [self insert: #(''['' '']'') around: match then].
match elseToken ifNotNil: [ self replace: match elseToken with: ''ifFalse:'' ].
(match else isKindOf: GtSmaCCTransformationExampleBlockNode) ifFalse: [self insert: #(''['' '']'') around: match else].
self insert: ''.'' after: match.
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stConvertInputStatement [
	^ SmaCCRewrite
		comment: 'input'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleInputNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self deleteWithWhitespaceAfter: match inputToken.
self insert: '' := self uiManager request: '''''''' initialAnswer: '''''''''' after: match variable.
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stConvertPrintStatement [
	^ SmaCCRewrite
		comment: 'print'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExamplePrintNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self replace: match printToken with: ''Transcript print: ''.
self continue.
self insert: ''; cr; flush'' after: match value')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stConvertReturnStatement [
	^ SmaCCRewrite
		comment: 'return'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleReturnNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: '(match parent isKindOf: GtSmaCCTransformationExampleFileNode) ifTrue: [self replace: match returnToken with: ''^''] ifFalse: [
((match parent isKindOf: GtSmaCCTransformationExampleBlockNode) and: [(match parent parent isKindOf: GtSmaCCTransformationExampleFunctionNode) and: [match parent statements last == match]])  ifTrue: [self deleteWithWhitespaceAfter: match returnToken] ifFalse: [self replace: match returnToken with: ''thisContext return:'']].
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stConvertWhileStatement [
	^ SmaCCRewrite
		comment: 'while'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleWhileNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self replace: match whileToken with: ''[''.
self replace: match doToken with: ''] whileTrue:''.
(match statement isKindOf: GtSmaCCTransformationExampleBlockNode) ifFalse: [self insert: #(''['' '']'') around: match statement].
self insert: ''.'' after: match.
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stInitializeAssignedVariables [
	^ SmaCCRewrite
		comment: 'initialize assignedVariables'
		match: (SmaCCRewriteTypeMatch on: GtSmaCCTransformationExampleFileNode)
		transformation: (SmaCCRewriteCodeTransformation
				on: 'self assignedVariables: Set new.
self continue')
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stProperties [
	^ SmaCCRewritePropertyDefinition
		comment: nil
		locals: #('assignedVariables')
		globals: #()
]

{ #category : #'examples - scripts' }
GtSmaCCTransformationExamples >> stScript [
	<gtExample>
	| script |
	script := self exampleScript.
	script addTransformation: self properties.
	script addTransformation: self stProperties.
	script addTransformation: self stInitializeAssignedVariables.
	script addTransformation: self stTemporariesMethod.
	script addTransformation: self stConvertComments.
	script addTransformation: self computeFunctionNames.
	script addTransformation: self addTemporaries.
	script addTransformation: self stConvertFunctionStatement.
	script addTransformation: self stConvertIfStatement.
	script addTransformation: self stConvertWhileStatement.
	script addTransformation: self stConvertReturnStatement.
	script addTransformation: self stBeginEndTransformation.
	script addTransformation: self stConvertPrintStatement.
	script addTransformation: self stConvertInputStatement.
	script addTransformation: self stConvertBinaryExpression.
	script addTransformation: self stCallExpression.
	script addTransformation: self addVariables.
	script addTransformation: self stAssignmentStatement.
	^ script
]

{ #category : #'private - transformations' }
GtSmaCCTransformationExamples >> stTemporariesMethod [
	^ SmaCCRewriteMethodDefinition
		source: 'processTemporariesAround: aBlock
	| vars newVars |
	vars := self temporaryVariables ifNil: [Set new].
	self temporaryVariables: (newVars := Set new).
	aBlock value.
	self temporaryVariables: vars.
	self functions do: [:each | newVars remove: each ifAbsent: []].
	vars do: [:each | newVars remove: each ifAbsent: []].
	^ newVars notEmpty ifTrue: [ ''| '' , ('','' join: newVars asSortedCollection) , '' |''  ]'
]
