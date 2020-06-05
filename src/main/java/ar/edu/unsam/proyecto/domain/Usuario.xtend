package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.repos.RepositorioUsuario
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEquipo
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsUsuario
import com.fasterxml.jackson.annotation.JsonView
import java.util.HashSet
import java.util.List
import java.util.Set
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.GeneratedValue
import javax.persistence.Id
import javax.persistence.JoinTable
import javax.persistence.ManyToMany
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point

@Accessors
@Entity
class Usuario {

	@JsonView(ViewsUsuario.IdView, ViewsPartido.DefaultView, ViewsEquipo.ListView)
	@Id @GeneratedValue
	Long idUsuario

	@JsonView(ViewsUsuario.DefaultView)
	@Column()
	String nombre = ""
	
	@Column()
	@JsonView(ViewsUsuario.CredencialesView)
	String password = ""

	@Column()
	@JsonView(ViewsUsuario.PerfilView)
	String foto

	@Column()
	@JsonView(ViewsUsuario.PerfilView)
	String sexo

	@Column()
	@JsonView(ViewsUsuario.PerfilView)
	String posicion

	@Column()
	@JsonView(ViewsUsuario.DefaultView)
	String email

	@JsonView(ViewsUsuario.UbicacionView)
	@Column()
	Double lat

	@JsonView(ViewsUsuario.UbicacionView)
	@Column()
	Double lon
	
	@JoinTable(name="Amistades")
	@ManyToMany
	Set <Usuario> amigos = new HashSet
	
	@Transient
	transient Set<NotificacionInvitacion> invitaciones = new HashSet()
	
	@Transient
	transient Set<NotificacionCandidato> candidatos = new HashSet()
	
	@Transient
	transient RepositorioUsuario repoUsuario = RepositorioUsuario.instance
	
	transient static val ID_INTEGRANTE_DESCONOCIDO = -1
	
	def tieneCredenciales(String email_, String password_) {
		email.equals(email_) && password.equals(password_)
	}

	def tieneEsteMail(String email) {
		this.email.equals(email)
	}

	def validar() {
		if (idUsuario === null){
			throw new Exception('El usuario debe tener un ID')
		}
		
		if (nombre === null){
			throw new Exception('El usuario debe tener un nombre')
		}
		
		if (idUsuario === null){
			throw new Exception('El usuario debe tener un ID')
		}
		
		//TODO: Validar password no trivial
		if (password === null){
			throw new Exception('El usuario debe tener una contraseña')
		}
		
		if (foto === null){
			throw new Exception('El usuario debe tener una foto de perfil')
		}
		
		if (sexo === null){
			throw new Exception('El usuario debe indicar su sexo')
		}
		
		if (posicion === null){
			throw new Exception('El usuario debe indicar su posicion preferida')
		}
		
		if (email === null){
			throw new Exception('El usuario debe tener un email')
		}
		
	}
	
	def agregarAmigo(Usuario usuario){		
			amigos.add(usuario)
	}
	
	def crearAmistad(Usuario usuario){
		usuario.agregarAmigo(this)
		this.agregarAmigo(usuario)
	}
	
	def esIntegranteDesconocido() {
		idUsuario == ID_INTEGRANTE_DESCONOCIDO
	}
	
	def estaDentroDelRango(Point ubicacionBuscada, int rango) {
		val ubicacionUsuario = getUbicacion
		ubicacionUsuario.distance(ubicacionBuscada) <= rango
	}
	
	def getUbicacion(){
		new Point(lat, lon)
	}
	
	def agregarNotificacion(NotificacionInvitacion notificacion){
		invitaciones.add(notificacion)
	}

}
