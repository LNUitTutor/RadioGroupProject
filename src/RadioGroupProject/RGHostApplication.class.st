"
I am a demonstration of `SpRadioGroupPresenter` using.

To run the application use `RGHostApplication class >> run`

```language=Pharo
 RGHostApplication run
```
"
Class {
	#name : 'RGHostApplication',
	#superclass : 'SpPresenter',
	#instVars : [
		'question1',
		'question2',
		'question3',
		'buttonCheck',
		'buttonClear',
		'buttonQuit',
		'output'
	],
	#category : 'RadioGroupProject-Application',
	#package : 'RadioGroupProject',
	#tag : 'Application'
}

{ #category : 'running' }
RGHostApplication class >> run [

	<script>
	self new open
]

{ #category : 'initialization' }
RGHostApplication >> connectPresenters [

	question1 whenIndexChangedDo: [ :index |
		output text: (String streamContents: [ :stream |
				 stream
					 nextPutAll: output text;
					 nextPutAll: 'first - ';
					 print: index;
					 cr ]) ].
	question2 whenIndexChangedDo: [ :index |
		output text: (String streamContents: [ :stream |
				 stream
					 nextPutAll: output text;
					 nextPutAll: 'second - ';
					 print: index;
					 cr ]) ].
	question3 whenIndexChangedDo: [ :index |
		output text: (String streamContents: [ :stream |
				 stream
					 nextPutAll: output text;
					 nextPutAll: 'third - ';
					 print: index;
					 cr ]) ].
	buttonCheck action: [ output text: (String streamContents: [ :stream |
				 stream
					 nextPutAll: output text;
					 nextPutAll: question1 title;
					 nextPutAll: ': '.
				 question1 itemSelected printOn: stream.
				 stream cr;
					 nextPutAll: question2 title;
					 nextPutAll: ': '.
				 question2 itemSelected printOn: stream.
				 stream cr;
					 nextPutAll: question3 title;
					 nextPutAll: ': '.
				 question3 itemSelected printOn: stream.
				 stream cr ] ) ].
	buttonClear action: [ output clearContent ].
	buttonQuit action: [ self delete ]
]

{ #category : 'layout' }
RGHostApplication >> defaultLayout [

	^ SpBoxLayout newTopToBottom
		  spacing: 20;
		  add: question1;
		  add: question2;
		  add: question3;
		  add: (SpBoxLayout newLeftToRight
				   spacing: 5;
				   add: (SpBoxLayout newTopToBottom
						    spacing: 5;
						    add: buttonCheck;
						    add: buttonClear;
						    add: buttonQuit;
						    yourself)
				   withConstraints: [ :constr | constr width: 100 ];
				   add: output);
		  yourself
]

{ #category : 'initialization' }
RGHostApplication >> initializePresenters [

	question1 := self instantiate: SpRadioGroupPresenter on: #( 10 14 16 18 20 22 ).
	question2 := self instantiate: SpRadioGroupPresenter on: #( 'Most of Spec in one example'
	   'A 10 min small example' 'A Mail application' 'A working example for managing windows' ).
	question3 := self instantiate: SpRadioGroupPresenter 
	                  on: { #useful . 'very interesting' . 'too complicated' . #MustHaveAndRead }.
	buttonCheck := self newButton.
	buttonClear := self newButton.
	buttonQuit := self newButton.
	output := self newText.

	question1
		title: 'How many chapters are in the "Application Building with Spec 2.0" book?';
		beTripleColumn.
	question2
		title: 'Check the first working example in the book:'.
	question3
		title: 'What do you think about the book? It is ...';
		beDoubleColumn.
	buttonCheck label: 'Check'.
	buttonClear label: 'Clear'.
	buttonQuit label: 'Quit'.
	output beNotEditable 
]

{ #category : 'initialization' }
RGHostApplication >> initializeWindow: aWindowPresenter [

	aWindowPresenter
		title: 'Three questions only';
		initialExtent: 445 @ 445
]
