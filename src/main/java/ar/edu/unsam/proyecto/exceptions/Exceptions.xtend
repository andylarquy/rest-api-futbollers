package ar.edu.unsam.proyecto.exceptions

class Exceptions {}

class IncorrectCredentials extends Exception{
	
	new(String errorMessage){
		super(errorMessage)
	}
}