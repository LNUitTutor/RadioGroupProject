Class {
	#name : 'SpRadioGroupPresenter',
	#superclass : 'SpPresenter',
	#instVars : [
		'names',
		'buttons',
		'index',
		'whenIndexChangedDo',
		'needsActivate'
	],
	#category : 'RadioGroupProject-Presenter',
	#package : 'RadioGroupProject',
	#tag : 'Presenter'
}

{ #category : 'private' }
SpRadioGroupPresenter >> buttonStateChanged [

	buttons withIndexDo: [ :btn :ind |
		btn state ifTrue: [ index := ind ] ].
	needsActivate ifTrue: [
		whenIndexChangedDo ifNotNil: [ whenIndexChangedDo value: index ] ].
	needsActivate := needsActivate not
]

{ #category : 'initialization' }
SpRadioGroupPresenter >> connectPresenters [

| block |
block := [ self buttonStateChanged ].
buttons do: [ :btn | btn whenChangedDo: block ]
]

{ #category : 'layout' }
SpRadioGroupPresenter >> defaultLayout [

	| boxLayout |
	boxLayout := SpBoxLayout newTopToBottom.
	buttons do: [ :btn | boxLayout add: btn ].
	^ boxLayout
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> index [

	^ index
]

{ #category : 'initialization' }
SpRadioGroupPresenter >> initializePresenters [

	| firstButton |
	index := 1.
	needsActivate := false.
	names := #('father' 'mother' 'sister' 'brother' 'cat' 'dog').
	firstButton := SpRadioButtonPresenter new label: names first.
	buttons := OrderedCollection with: firstButton.
	names allButFirstDo: [ :str |
		buttons add: (SpRadioButtonPresenter new label: str) ].
	firstButton associatedRadioButtons: buttons allButFirst
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> names: anOrderedCollection [

	names := anOrderedCollection
]

{ #category : 'accessing' }
SpRadioGroupPresenter >> whenIndexChangedDo: aBlock [

	whenIndexChangedDo := aBlock
]
