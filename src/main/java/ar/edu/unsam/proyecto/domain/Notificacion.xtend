package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsNotificacion
import com.fasterxml.jackson.annotation.JsonIgnore
import com.fasterxml.jackson.annotation.JsonInclude
import com.fasterxml.jackson.annotation.JsonInclude.Include
import com.fasterxml.jackson.annotation.JsonView
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@JsonInclude(Include.NON_NULL)//En teoria si un campo es null no lo parsea 
class Notificacion{
	
	@JsonView(ViewsNotificacion.NotificacionView)
	Long idNotificacion
	
	@JsonView(ViewsNotificacion.NotificacionView)
	String descripcion

	@JsonView(ViewsNotificacion.NotificacionView)
	Partido partido
	
	@JsonView(ViewsNotificacion.NotificacionView) Usuario usuario
	
	//TODO: Discutir si esto aca siquiera tiene sentido
	@JsonView() @JsonIgnore Equipo equipo
	
	def esDelUsuario(Long idUsuario) {
		usuario.idUsuario == idUsuario
	}
	
	def empresaTieneMail(String email) {
		partido.empresa.email.equals(email)
	}
	
	def partidoTieneId(Long idPartido) {
		partido.idPartido == idPartido
	}
	
}
