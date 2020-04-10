package ar.edu.unsam.proyecto.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Usuario {

	String id
	String nombre
	String sexo
	String posicion
	String email
	Double lat
	Double lon

	def validar() {
		true
	}

}
