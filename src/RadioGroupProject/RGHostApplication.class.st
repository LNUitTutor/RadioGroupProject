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

	question1 := self instantiate: SpRadioGroupPresenter on: #( 13 5 100 1024 ).
	question2 := self instantiate: SpRadioGroupPresenter on: #( 'Peace' 'Earth' 'Pharo' 'Mind' ).
	question3 := self instantiate: SpRadioGroupPresenter 
	                  on: { true . #(2 3 5 7 11) . Float pi . 'Hello, World!' }.
	buttonCheck := self newButton.
	buttonClear := self newButton.
	buttonQuit := self newButton.
	output := self newText.

	question1
		title: 'Check a number';
		beDoubleColumn.
	question2
		title: 'Check a word';
		beDoubleColumn.
	question3
		title: 'Check an object';
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
		initialExtent: 380 @ 375
]
