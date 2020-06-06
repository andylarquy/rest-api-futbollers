package ar.edu.unsam.proyecto.domain

import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Notificacion{
	
	Long idNotificacion
	
	String descripcion

	Partido partido
	
	transient Usuario usuario
	
	transient Equipo equipo
	
	def esDelUsuario(Long idUsuario) {
		usuario.idUsuario == idUsuario
	}
	
	def empresaTieneMail(String email) {
		partido.empresa.email.equals(email)
	}
	
}
