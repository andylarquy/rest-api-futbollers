package ar.edu.unsam.proyecto.domain

import com.fasterxml.jackson.annotation.JsonIgnore
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class Notificacion{
	
	Long idNotificacion
	
	String descripcion

	@JsonIgnore Partido partido
	
	@JsonIgnore transient Usuario usuario
	
	@JsonIgnore transient Equipo equipo
	
	def esDelUsuario(Long idUsuario) {
		usuario.idUsuario == idUsuario
	}
	
	def empresaTieneMail(String email) {
		partido.empresa.email.equals(email)
	}
	
}
