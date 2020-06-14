package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.repos.RepositorioPartido
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsNotificacion
import com.fasterxml.jackson.annotation.JsonInclude
import com.fasterxml.jackson.annotation.JsonInclude.Include
import com.fasterxml.jackson.annotation.JsonView
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.OneToOne
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
@JsonInclude(Include.NON_NULL)//En teoria si un campo es null no lo parsea 
@Entity
class Notificacion{
	
	
	@Id @GeneratedValue
	@JsonView(ViewsNotificacion.NotificacionView)
	Long idNotificacion
	
	@Column()
	@JsonView(ViewsNotificacion.NotificacionView)
	String titulo
	
	@Column()
	@JsonView(ViewsNotificacion.NotificacionView)
	String descripcion

	@OneToOne
	@JsonView(ViewsNotificacion.NotificacionView)
	Partido partido
	
	@OneToOne
	@JsonView(ViewsNotificacion.NotificacionView)
	Usuario usuario
	
	@OneToOne
	@JsonView(ViewsNotificacion.NotificacionView)
	Usuario usuarioReceptor
	
	@Column
	Boolean aceptado = false
	
	@Transient
	transient RepositorioPartido repoPartido = RepositorioPartido.instance
	
	//TODO: Discutir si esto aca siquiera tiene sentido
	//@JsonView() @JsonIgnore Equipo equipo
	
	def esDelUsuario(Long idUsuario) {
		usuario.idUsuario == idUsuario
	}
	
	def empresaTieneMail(String email) {
		partido.empresa.email.equals(email)
	}
	
	def partidoTieneId(Long idPartido) {
		partido.idPartido == idPartido
	}
	
	def agregarIntegranteAlPartido() {
		partido.agregarIntegrante(usuarioReceptor)
		repoPartido.update(partido)
	}
	
	def receptorFueAdmitido() {
		partido.participaUsuario(usuarioReceptor)
	}
	
	def esOwnerDelPartido(Usuario usuario) {
		partido.equipo1.esOwner(usuario)
	}
	
}
