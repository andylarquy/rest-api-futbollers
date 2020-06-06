package ar.edu.unsam.proyecto.exceptions

class Exceptions {}

class IncorrectCredentials extends Exception{
	new(String errorMessage){
		super(errorMessage)
	}
}

class ObjectDoesntExists extends Exception{
	new(String errorMessage){
		super(errorMessage)
	}
}

class ObjectAlreadyExists extends Exception{
	new(String errorMessage){
		super(errorMessage)
	}
}

class InsufficientCandidates extends Exception{
	new(String errorMessage){
		super(errorMessage)
	}
}