Class {
	#name : 'BaselineOfRadioGroupProject',
	#superclass : 'BaselineOf',
	#category : 'BaselineOfRadioGroupProject',
	#package : 'BaselineOfRadioGroupProject'
}

{ #category : 'baselines' }
BaselineOfRadioGroupProject >> baseline: spec [

	<baseline>
	spec for: #common do: [ spec package: 'RadioGroupProject' ]
]

{ #category : 'accessing' }
BaselineOfRadioGroupProject >> projectClass [
	^ MetacelloCypressBaselineProject
]
