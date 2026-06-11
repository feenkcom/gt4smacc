Class {
	#name : #GtSmaCCTransformationExampleParser,
	#superclass : #SmaCCGLRParser,
	#category : #'GT4SmaCC-Examples-Transformations'
}

{ #category : #'generated-accessing' }
GtSmaCCTransformationExampleParser class >> cacheId [
	^'2026-06-11T05:38:41.447538-05:00'
]

{ #category : #generated }
GtSmaCCTransformationExampleParser class >> definitionComment [
"%ignorecase;

%glr;


%root Program;
%prefix GtSmaCCTransformationExample;
%suffix Node;
%hierarchy Statement (Assignment Print Input If While Function Block Return Call);
%hierarchy Expression (Variable BinaryExpression CallExpression Literal);
%hierarchy Literal (Number String);
%right ""else"";
%nonassoc ""<>"" ""=="" ""<"" ""<="" "">"" "">="";
%left "","" ""+"" ""-"";
%left ""*"" ""/"";
%right ""^"";
%left ""("";
%start File Statement Expression;
<variable>
	: [a-z_][a-z0-9_]*
	;
<comment>
	: \/\/ [^\r\n]*
	;
<whitespace>
	: \s+
	;
<number>
	: \d+ (\. \d+)?
	;
<string>
	: (\' [^\']* \')+
	;
<patternToken>
	: (\`  [^\`]* \`)+
	;File 
	: Statement 'statement'* {{}}
	;
Statement
	: Assignment
	| Print
	| Input
	| If
	| While
	| Function
	| Block
	| Return
	| Call
	;
Call
	: CallExpression 'call' ""."" 'period' {{}}
	;
Return
	: ""return"" 'returnToken' Expression 'value' ""."" 'period' {{}}
	;
Block
	: ""begin"" 'beginToken' Statement 'statement'* ""end"" 'endToken' {{}}
	;
Function
	: ""function"" 'functionToken' <variable> 'name' ""("" 'left' Parms "")"" 'right' Block 'body' {{}}
	;
Parms
	:
	| (Variable 'parameter' "";"" 'semicolon')* Variable 'parameter'
	;
While
	: ""while"" 'whileToken' Expression 'condition' ""do"" 'doToken' Statement 'statement' {{}}
	;
If
	: ""if"" 'ifToken' Expression 'condition' ""then"" 'thenToken' Statement 'then' (""else"" 'elseToken' Statement 'else')? {{}}
	;
Input
	: ""input"" 'inputToken' Variable 'variable' ""."" 'period' {{}}
	;
Print
	: ""print"" 'printToken' Expression 'value' ""."" 'period' {{}}
	;
Assignment
	: Variable 'variable' "":="" 'assignmentToken' Expression 'value' ""."" 'period' {{}}
	;
Expression
	: Variable
	| Literal
	| ""("" 'leftParen' Expression "")"" 'rightParen' {{}}
	| Expression 'left' ("","" 'operator' | ""+"" 'operator' | ""-"" 'operator' | ""*"" 'operator' | ""/"" 'operator' | ""^"" 'operator') Expression 'right' {{BinaryExpression}}
	| Expression 'left' (""<>"" 'operator' | ""=="" 'operator' | ""<"" 'operator' | ""<="" 'operator' | "">"" 'operator' | "">="" 'operator') Expression 'right' {{BinaryExpression}}
	| CallExpression
	;
CallExpression
	: Expression 'function' ""("" 'left' Args "")"" 'right' {{}}
	;
Literal
	: Number
	| String
	;
String
	: <string> 'value' {{String}}
	;
Number
	: <number> 'value' {{Number}}
	;
Args
	:
	| (Expression 'arg' "";"" 'semicolon')* Expression 'arg'
	;
Variable
	: <variable> 'name' {{}}
	;"
]

{ #category : #generated }
GtSmaCCTransformationExampleParser class >> reduceTable [
^#(
	#(37 0 #reduceActionForStatement__statement__1: 635905 false) 
	#(36 1 #reduceActionForFile1: 626689 false) 
	#(59 1 #reduceActionForVariable1: 2347009 false) 
	#(55 1 #reduceActionForNumber1: 2236417 false) 
	#(54 1 #reduceActionForString1: 2194433 false) 
	#(38 1 #liftFirstValue: 667657 false) 
	#(38 1 #liftFirstValue: 667656 false) 
	#(38 1 #liftFirstValue: 667655 false) 
	#(38 1 #liftFirstValue: 667654 false) 
	#(38 1 #liftFirstValue: 667653 false) 
	#(38 1 #liftFirstValue: 667652 false) 
	#(38 1 #liftFirstValue: 667651 false) 
	#(38 1 #liftFirstValue: 667650 false) 
	#(38 1 #liftFirstValue: 667649 false) 
	#(51 1 #liftFirstValue: 1637392 false) 
	#(51 1 #liftFirstValue: 1637378 false) 
	#(53 1 #liftFirstValue: 2162690 false) 
	#(53 1 #liftFirstValue: 2162689 false) 
	#(51 1 #liftFirstValue: 1637377 false) 
	#(37 2 #reduceActionForStatement__statement__2: 635906 false) 
	#(58 0 #reduceActionFor_Expression__arg_______semicolon___1: 2289665 false) 
	#(56 0 #reduceActionFor_Expression__arg_______semicolon___1: 2278401 false) 
	#(39 2 #reduceActionForCall1: 769025 false) 
	#(51 3 #reduceActionForExpression3: 1637379 false) 
	#(41 3 #reduceActionForBlock1: 896001 false) 
	#(43 0 #reduceActionFor_Expression__arg_______semicolon___1: 1085441 false) 
	#(45 0 #reduceActionFor_Expression__arg_______semicolon___1: 1097729 false) 
	#(48 3 #reduceActionForInput1: 1393665 false) 
	#(49 3 #reduceActionForPrint1: 1466369 false) 
	#(40 3 #reduceActionForReturn1: 821249 false) 
	#(51 3 #reduceActionForExpression7: 1637383 false) 
	#(51 3 #reduceActionForExpression7: 1637381 false) 
	#(51 3 #reduceActionForExpression7: 1637380 false) 
	#(51 3 #reduceActionForExpression7: 1637382 false) 
	#(51 3 #reduceActionForExpression7: 1637384 false) 
	#(51 3 #reduceActionForExpression7: 1637388 false) 
	#(51 3 #reduceActionForExpression7: 1637389 false) 
	#(51 3 #reduceActionForExpression7: 1637386 false) 
	#(51 3 #reduceActionForExpression7: 1637387 false) 
	#(51 3 #reduceActionForExpression7: 1637390 false) 
	#(51 3 #reduceActionForExpression7: 1637391 false) 
	#(51 3 #reduceActionForExpression7: 1637385 false) 
	#(47 4 #reduceActionForIf1: 1263617 false) 
	#(46 4 #reduceActionForWhile1: 1163265 false) 
	#(52 4 #reduceActionForCallExpression1: 2084865 false) 
	#(56 2 #reduceActionForArgs2: 2278402 false) 
	#(58 2 #reduceActionFor_Expression__arg_______semicolon___2: 2289666 false) 
	#(50 4 #reduceActionForAssignment1: 1538049 false) 
	#(45 2 #reduceActionFor_Expression__arg_______semicolon___2: 1097730 false) 
	#(43 2 #reduceActionForArgs2: 1085442 false) 
	#(57 2 #reduceActionFor_Expression__arg_______semicolon__1: 2289665 false) 
	#(42 6 #reduceActionForFunction1: 975873 false) 
	#(44 2 #reduceActionFor_Expression__arg_______semicolon__1: 1097729 false) 
	#(47 6 #reduceActionForIf2: 1263618 false)
	).
]

{ #category : #generated }
GtSmaCCTransformationExampleParser class >> scannerClass [
	^GtSmaCCTransformationExampleScanner
]

{ #category : #generated }
GtSmaCCTransformationExampleParser class >> startingStateForExpression [
	^ 3
]

{ #category : #generated }
GtSmaCCTransformationExampleParser class >> startingStateForFile [
	^ 1
]

{ #category : #generated }
GtSmaCCTransformationExampleParser class >> startingStateForStatement [
	^ 2
]

{ #category : #generated }
GtSmaCCTransformationExampleParser class >> symbolNames [
	^ #('"("' '")"' '"*"' '"+"' '","' '"-"' '"."' '"/"' '":="' '";"' '"<"' '"<="' '"<>"' '"=="' '">"' '">="' '"^"' '"begin"' '"do"' '"else"' '"end"' '"function"' '"if"' '"input"' '"print"' '"return"' '"then"' '"while"' '<variable>' '<comment>' '<whitespace>' '<number>' '<string>' '<patternToken>' 'B e g i n' 'File' 'Statement ''statement''*' 'Statement' 'Call' 'Return' 'Block' 'Function' 'Parms' '(Variable ''parameter'' ";" ''semicolon'')' '(Variable ''parameter'' ";" ''semicolon'')*' 'While' 'If' 'Input' 'Print' 'Assignment' 'Expression' 'CallExpression' 'Literal' 'String' 'Number' 'Args' '(Expression ''arg'' ";" ''semicolon'')' '(Expression ''arg'' ";" ''semicolon'')*' 'Variable' 'E O F' 'error')
]

{ #category : #generated }
GtSmaCCTransformationExampleParser class >> symbolTypes [
	^ #(#SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #SmaCCToken #GtSmaCCTransformationExampleFileNode #GtSmaCCTransformationExampleFileNode #OrderedCollection #GtSmaCCTransformationExampleStatementNode #GtSmaCCTransformationExampleCallNode #GtSmaCCTransformationExampleReturnNode #GtSmaCCTransformationExampleBlockNode #GtSmaCCTransformationExampleFunctionNode #OrderedCollection #OrderedCollection #OrderedCollection #GtSmaCCTransformationExampleWhileNode #GtSmaCCTransformationExampleIfNode #GtSmaCCTransformationExampleInputNode #GtSmaCCTransformationExamplePrintNode #GtSmaCCTransformationExampleAssignmentNode #GtSmaCCTransformationExampleExpressionNode #GtSmaCCTransformationExampleCallExpressionNode #GtSmaCCTransformationExampleLiteralNode #GtSmaCCTransformationExampleStringNode #GtSmaCCTransformationExampleNumberNode #OrderedCollection #OrderedCollection #OrderedCollection #GtSmaCCTransformationExampleVariableNode #SmaCCToken #SmaCCErrorNode)
]

{ #category : #generated }
GtSmaCCTransformationExampleParser class >> transitionTable [
^#(
#[1 0 6 0 1 0 6 0 18 0 6 0 22 0 6 0 23 0 6 0 24 0 6 0 25 0 6 0 26 0 6 0 28 0 6 0 29 0 6 0 32 0 6 0 33 0 17 0 36 0 21 0 37 0 6 0 60] 
#[1 0 25 0 1 0 29 0 18 0 33 0 22 0 37 0 23 0 41 0 24 0 45 0 25 0 49 0 26 0 53 0 28 0 57 0 29 0 61 0 32 0 65 0 33 0 69 0 38 0 69 0 39 0 69 0 40 0 69 0 41 0 69 0 42 0 69 0 46 0 69 0 47 0 69 0 48 0 69 0 49 0 69 0 50 0 109 0 51 0 113 0 52 0 109 0 53 0 109 0 54 0 109 0 55 0 129 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 0 133 0 51 0 133 0 52 0 133 0 53 0 133 0 54 0 133 0 55 0 133 0 59] 
#[0 0 0 0 60] 
#[1 0 25 0 1 0 29 0 18 0 33 0 22 0 37 0 23 0 41 0 24 0 45 0 25 0 49 0 26 0 53 0 28 0 57 0 29 0 61 0 32 0 65 0 33 0 145 0 38 0 145 0 39 0 145 0 40 0 145 0 41 0 145 0 42 0 145 0 46 0 145 0 47 0 145 0 48 0 145 0 49 0 145 0 50 0 109 0 51 0 113 0 52 0 109 0 53 0 109 0 54 0 109 0 55 0 129 0 59 0 10 0 60] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 0 149 0 51 0 149 0 52 0 149 0 53 0 149 0 54 0 149 0 55 0 149 0 59] 
#[1 0 6 0 1 0 6 0 18 0 6 0 21 0 6 0 22 0 6 0 23 0 6 0 24 0 6 0 25 0 6 0 26 0 6 0 28 0 6 0 29 0 6 0 32 0 6 0 33 0 153 0 37] 
#[0 0 157 0 29] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 0 161 0 51 0 161 0 52 0 161 0 53 0 161 0 54 0 161 0 55 0 161 0 59] 
#[1 0 57 0 29 0 165 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 0 169 0 51 0 169 0 52 0 169 0 53 0 169 0 54 0 169 0 55 0 169 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 0 173 0 51 0 173 0 52 0 173 0 53 0 173 0 54 0 173 0 55 0 173 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 0 177 0 51 0 177 0 52 0 177 0 53 0 177 0 54 0 177 0 55 0 177 0 59] 
#[0 0 14 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 9 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 19 0 27 0 60] 
#[0 0 18 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 19 0 27 0 60] 
#[0 0 22 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 19 0 27 0 60] 
#[0 0 0 0 60] 
#[0 0 26 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[0 0 30 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[0 0 34 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[0 0 38 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[0 0 42 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[0 0 46 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[0 0 50 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[0 0 54 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[0 0 58 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[1 0 181 0 1 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 0 201 0 8 0 205 0 11 0 209 0 12 0 213 0 13 0 217 0 14 0 221 0 15 0 225 0 16 0 229 0 17] 
#[1 0 62 0 1 0 62 0 3 0 62 0 4 0 62 0 5 0 62 0 6 0 233 0 7 0 62 0 8 0 62 0 11 0 62 0 12 0 62 0 13 0 62 0 14 0 62 0 15 0 62 0 16 0 62 0 17] 
#[0 0 66 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 19 0 27 0 60] 
#[0 0 70 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 19 0 27 0 60] 
#[0 0 74 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 19 0 27 0 60] 
#[1 0 78 0 1 0 78 0 3 0 78 0 4 0 78 0 5 0 78 0 6 0 78 0 8 0 237 0 9 0 78 0 11 0 78 0 12 0 78 0 13 0 78 0 14 0 78 0 15 0 78 0 16 0 78 0 17] 
#[1 0 181 0 1 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 0 201 0 8 0 205 0 11 0 209 0 12 0 213 0 13 0 217 0 14 0 221 0 15 0 225 0 16 0 229 0 17 0 0 0 60] 
#[0 0 62 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 19 0 27 0 60] 
#[0 0 78 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 19 0 27 0 60] 
#[0 0 82 0 1 0 18 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[1 0 181 0 1 0 241 0 2 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 0 201 0 8 0 205 0 11 0 209 0 12 0 213 0 13 0 217 0 14 0 221 0 15 0 225 0 16 0 229 0 17] 
#[1 0 25 0 1 0 29 0 18 0 245 0 21 0 33 0 22 0 37 0 23 0 41 0 24 0 45 0 25 0 49 0 26 0 53 0 28 0 57 0 29 0 61 0 32 0 65 0 33 0 145 0 38 0 145 0 39 0 145 0 40 0 145 0 41 0 145 0 42 0 145 0 46 0 145 0 47 0 145 0 48 0 145 0 49 0 145 0 50 0 109 0 51 0 113 0 52 0 109 0 53 0 109 0 54 0 109 0 55 0 129 0 59] 
#[0 0 249 0 1] 
#[1 0 181 0 1 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 0 201 0 8 0 205 0 11 0 209 0 12 0 213 0 13 0 217 0 14 0 221 0 15 0 225 0 16 0 229 0 17 0 253 0 27] 
#[0 1 1 0 7] 
#[1 0 181 0 1 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 1 5 0 7 0 201 0 8 0 205 0 11 0 209 0 12 0 213 0 13 0 217 0 14 0 221 0 15 0 225 0 16 0 229 0 17] 
#[1 0 181 0 1 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 1 9 0 7 0 201 0 8 0 205 0 11 0 209 0 12 0 213 0 13 0 217 0 14 0 221 0 15 0 225 0 16 0 229 0 17] 
#[1 0 181 0 1 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 0 201 0 8 0 205 0 11 0 209 0 12 0 213 0 13 0 217 0 14 0 221 0 15 0 225 0 16 0 229 0 17 1 13 0 19] 
#[1 0 86 0 1 0 90 0 2 0 86 0 29 0 86 0 32 0 86 0 33 1 17 0 56 1 21 0 58] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 25 0 51 1 25 0 52 1 25 0 53 1 25 0 54 1 25 0 55 1 25 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 29 0 51 1 29 0 52 1 29 0 53 1 29 0 54 1 29 0 55 1 29 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 33 0 51 1 33 0 52 1 33 0 53 1 33 0 54 1 33 0 55 1 33 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 37 0 51 1 37 0 52 1 37 0 53 1 37 0 54 1 37 0 55 1 37 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 41 0 51 1 41 0 52 1 41 0 53 1 41 0 54 1 41 0 55 1 41 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 45 0 51 1 45 0 52 1 45 0 53 1 45 0 54 1 45 0 55 1 45 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 49 0 51 1 49 0 52 1 49 0 53 1 49 0 54 1 49 0 55 1 49 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 53 0 51 1 53 0 52 1 53 0 53 1 53 0 54 1 53 0 55 1 53 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 57 0 51 1 57 0 52 1 57 0 53 1 57 0 54 1 57 0 55 1 57 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 61 0 51 1 61 0 52 1 61 0 53 1 61 0 54 1 61 0 55 1 61 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 65 0 51 1 65 0 52 1 65 0 53 1 65 0 54 1 65 0 55 1 65 0 59] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 69 0 51 1 69 0 52 1 69 0 53 1 69 0 54 1 69 0 55 1 69 0 59] 
#[0 0 94 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 73 0 51 1 73 0 52 1 73 0 53 1 73 0 54 1 73 0 55 1 73 0 59] 
#[0 0 98 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 19 0 27 0 60] 
#[0 0 102 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[1 0 106 0 2 0 110 0 29 1 77 0 43 1 81 0 45] 
#[1 0 25 0 1 0 29 0 18 0 33 0 22 0 37 0 23 0 41 0 24 0 45 0 25 0 49 0 26 0 53 0 28 0 57 0 29 0 61 0 32 0 65 0 33 1 85 0 38 1 85 0 39 1 85 0 40 1 85 0 41 1 85 0 42 1 85 0 46 1 85 0 47 1 85 0 48 1 85 0 49 1 85 0 50 0 109 0 51 0 113 0 52 0 109 0 53 0 109 0 54 0 109 0 55 0 129 0 59] 
#[0 0 114 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[0 0 118 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[0 0 122 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[1 0 25 0 1 0 29 0 18 0 33 0 22 0 37 0 23 0 41 0 24 0 45 0 25 0 49 0 26 0 53 0 28 0 57 0 29 0 61 0 32 0 65 0 33 1 89 0 38 1 89 0 39 1 89 0 40 1 89 0 41 1 89 0 42 1 89 0 46 1 89 0 47 1 89 0 48 1 89 0 49 1 89 0 50 0 109 0 51 0 113 0 52 0 109 0 53 0 109 0 54 0 109 0 55 0 129 0 59] 
#[0 1 93 0 2] 
#[1 0 25 0 1 0 57 0 29 0 61 0 32 0 65 0 33 1 97 0 51 1 97 0 52 1 97 0 53 1 97 0 54 1 97 0 55 1 101 0 57 1 97 0 59] 
#[1 0 181 0 1 0 126 0 2 0 126 0 3 0 126 0 4 0 126 0 5 0 126 0 6 0 126 0 7 0 126 0 8 0 126 0 10 0 126 0 11 0 126 0 12 0 126 0 13 0 126 0 14 0 126 0 15 0 126 0 16 0 229 0 17 0 126 0 19 0 126 0 27 0 126 0 60] 
#[1 0 181 0 1 0 130 0 2 0 185 0 3 0 130 0 4 0 130 0 5 0 130 0 6 0 130 0 7 0 201 0 8 0 130 0 10 0 130 0 11 0 130 0 12 0 130 0 13 0 130 0 14 0 130 0 15 0 130 0 16 0 229 0 17 0 130 0 19 0 130 0 27 0 130 0 60] 
#[1 0 181 0 1 0 134 0 2 0 185 0 3 0 134 0 4 0 134 0 5 0 134 0 6 0 134 0 7 0 201 0 8 0 134 0 10 0 134 0 11 0 134 0 12 0 134 0 13 0 134 0 14 0 134 0 15 0 134 0 16 0 229 0 17 0 134 0 19 0 134 0 27 0 134 0 60] 
#[1 0 181 0 1 0 138 0 2 0 185 0 3 0 138 0 4 0 138 0 5 0 138 0 6 0 138 0 7 0 201 0 8 0 138 0 10 0 138 0 11 0 138 0 12 0 138 0 13 0 138 0 14 0 138 0 15 0 138 0 16 0 229 0 17 0 138 0 19 0 138 0 27 0 138 0 60] 
#[1 0 181 0 1 0 142 0 2 0 142 0 3 0 142 0 4 0 142 0 5 0 142 0 6 0 142 0 7 0 142 0 8 0 142 0 10 0 142 0 11 0 142 0 12 0 142 0 13 0 142 0 14 0 142 0 15 0 142 0 16 0 229 0 17 0 142 0 19 0 142 0 27 0 142 0 60] 
#[1 0 181 0 1 0 146 0 2 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 0 146 0 7 0 201 0 8 0 146 0 10 0 229 0 17 0 146 0 19 0 146 0 27 0 146 0 60] 
#[1 0 181 0 1 0 150 0 2 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 0 150 0 7 0 201 0 8 0 150 0 10 0 229 0 17 0 150 0 19 0 150 0 27 0 150 0 60] 
#[1 0 181 0 1 0 154 0 2 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 0 154 0 7 0 201 0 8 0 154 0 10 0 229 0 17 0 154 0 19 0 154 0 27 0 154 0 60] 
#[1 0 181 0 1 0 158 0 2 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 0 158 0 7 0 201 0 8 0 158 0 10 0 229 0 17 0 158 0 19 0 158 0 27 0 158 0 60] 
#[1 0 181 0 1 0 162 0 2 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 0 162 0 7 0 201 0 8 0 162 0 10 0 229 0 17 0 162 0 19 0 162 0 27 0 162 0 60] 
#[1 0 181 0 1 0 166 0 2 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 0 166 0 7 0 201 0 8 0 166 0 10 0 229 0 17 0 166 0 19 0 166 0 27 0 166 0 60] 
#[1 0 181 0 1 0 170 0 2 0 170 0 3 0 170 0 4 0 170 0 5 0 170 0 6 0 170 0 7 0 170 0 8 0 170 0 10 0 170 0 11 0 170 0 12 0 170 0 13 0 170 0 14 0 170 0 15 0 170 0 16 0 229 0 17 0 170 0 19 0 170 0 27 0 170 0 60] 
#[1 0 181 0 1 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 1 105 0 7 0 201 0 8 0 205 0 11 0 209 0 12 0 213 0 13 0 217 0 14 0 221 0 15 0 225 0 16 0 229 0 17] 
#[0 1 109 0 2] 
#[1 0 57 0 29 1 113 0 44 1 117 0 59] 
#[1 0 174 0 1 0 174 0 18 1 121 0 20 0 174 0 21 0 174 0 22 0 174 0 23 0 174 0 24 0 174 0 25 0 174 0 26 0 174 0 28 0 174 0 29 0 174 0 32 0 174 0 33 0 174 0 60] 
#[0 0 178 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[0 0 182 0 1 0 2 0 3 0 4 0 5 0 6 0 7 0 8 0 10 0 11 0 12 0 13 0 14 0 15 0 16 0 17 0 19 0 27 0 60] 
#[1 0 181 0 1 0 186 0 2 0 185 0 3 0 189 0 4 0 193 0 5 0 197 0 6 0 201 0 8 1 125 0 10 0 205 0 11 0 209 0 12 0 213 0 13 0 217 0 14 0 221 0 15 0 225 0 16 0 229 0 17] 
#[0 0 190 0 1 0 29 0 32 0 33] 
#[0 0 194 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[1 0 29 0 18 1 129 0 41] 
#[0 0 198 0 29] 
#[1 0 202 0 2 1 133 0 10] 
#[1 0 25 0 1 0 29 0 18 0 33 0 22 0 37 0 23 0 41 0 24 0 45 0 25 0 49 0 26 0 53 0 28 0 57 0 29 0 61 0 32 0 65 0 33 1 137 0 38 1 137 0 39 1 137 0 40 1 137 0 41 1 137 0 42 1 137 0 46 1 137 0 47 1 137 0 48 1 137 0 49 1 137 0 50 0 109 0 51 0 113 0 52 0 109 0 53 0 109 0 54 0 109 0 55 0 129 0 59] 
#[0 0 206 0 1 0 29 0 32 0 33] 
#[0 0 210 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60] 
#[0 0 214 0 29] 
#[0 0 218 0 1 0 18 0 20 0 21 0 22 0 23 0 24 0 25 0 26 0 28 0 29 0 32 0 33 0 60]
	).
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForArgs2: nodes [
	| result |
	result := nodes at: 1.
	self add: (nodes at: 2) to: (result at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForAssignment1: nodes [
	| result |
	result := GtSmaCCTransformationExampleAssignmentNode new.
	result variable: (nodes at: 1).
	result assignmentToken: (nodes at: 2).
	result value: (nodes at: 3).
	result period: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForBlock1: nodes [
	| result |
	result := GtSmaCCTransformationExampleBlockNode new.
	result beginToken: (nodes at: 1).
	result addNodes: (nodes at: 2) to: result statements.
	result endToken: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForCall1: nodes [
	| result |
	result := GtSmaCCTransformationExampleCallNode new.
	result call: (nodes at: 1).
	result period: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForCallExpression1: nodes [
	| result |
	result := GtSmaCCTransformationExampleCallExpressionNode new.
	result function: (nodes at: 1).
	result left: (nodes at: 2).
	result addNodes: ((nodes at: 3) at: 1) to: result args.
	result addTokens: ((nodes at: 3) at: 2) to: result semicolons.
	result right: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForExpression3: nodes [
	| result |
	result := nodes at: 2.
	result addFirstToken: (nodes at: 1) to: result leftParens.
	result addToken: (nodes at: 3) to: result rightParens.
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForExpression7: nodes [
	| result |
	result := GtSmaCCTransformationExampleBinaryExpressionNode new.
	result left: (nodes at: 1).
	result operator: (nodes at: 2).
	result right: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForFile1: nodes [
	| result |
	result := GtSmaCCTransformationExampleFileNode new.
	result addNodes: (nodes at: 1) to: result statements.
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForFunction1: nodes [
	| result |
	result := GtSmaCCTransformationExampleFunctionNode new.
	result functionToken: (nodes at: 1).
	result name: (nodes at: 2).
	result left: (nodes at: 3).
	result addNodes: ((nodes at: 4) at: 1) to: result parameters.
	result addTokens: ((nodes at: 4) at: 2) to: result semicolons.
	result right: (nodes at: 5).
	result body: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForIf1: nodes [
	| result |
	result := GtSmaCCTransformationExampleIfNode new.
	result ifToken: (nodes at: 1).
	result condition: (nodes at: 2).
	result thenToken: (nodes at: 3).
	result then: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForIf2: nodes [
	| result |
	result := GtSmaCCTransformationExampleIfNode new.
	result ifToken: (nodes at: 1).
	result condition: (nodes at: 2).
	result thenToken: (nodes at: 3).
	result then: (nodes at: 4).
	result elseToken: (nodes at: 5).
	result else: (nodes at: 6).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForInput1: nodes [
	| result |
	result := GtSmaCCTransformationExampleInputNode new.
	result inputToken: (nodes at: 1).
	result variable: (nodes at: 2).
	result period: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForNumber1: nodes [
	| result |
	result := GtSmaCCTransformationExampleNumberNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForPrint1: nodes [
	| result |
	result := GtSmaCCTransformationExamplePrintNode new.
	result printToken: (nodes at: 1).
	result value: (nodes at: 2).
	result period: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForReturn1: nodes [
	| result |
	result := GtSmaCCTransformationExampleReturnNode new.
	result returnToken: (nodes at: 1).
	result value: (nodes at: 2).
	result period: (nodes at: 3).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForStatement__statement__1: nodes [
	| result |
	result := OrderedCollection new: 2.
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForStatement__statement__2: nodes [
	| result |
	result := nodes at: 1.
	self add: (nodes at: 2) to: result.
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForString1: nodes [
	| result |
	result := GtSmaCCTransformationExampleStringNode new.
	result value: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForVariable1: nodes [
	| result |
	result := GtSmaCCTransformationExampleVariableNode new.
	result name: (nodes at: 1).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionForWhile1: nodes [
	| result |
	result := GtSmaCCTransformationExampleWhileNode new.
	result whileToken: (nodes at: 1).
	result condition: (nodes at: 2).
	result doToken: (nodes at: 3).
	result statement: (nodes at: 4).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionFor_Expression__arg_______semicolon__1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (nodes at: 1).
	result at: 2 put: (nodes at: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionFor_Expression__arg_______semicolon___1: nodes [
	| result |
	result := Array new: 2.
	result at: 1 put: (OrderedCollection new: 2).
	result at: 2 put: (OrderedCollection new: 2).
	^ result
]

{ #category : #'generated-reduction actions' }
GtSmaCCTransformationExampleParser >> reduceActionFor_Expression__arg_______semicolon___2: nodes [
	| result |
	result := nodes at: 1.
	self add: ((nodes at: 2) at: 1) to: (result at: 1).
	self add: ((nodes at: 2) at: 2) to: (result at: 2).
	^ result
]
