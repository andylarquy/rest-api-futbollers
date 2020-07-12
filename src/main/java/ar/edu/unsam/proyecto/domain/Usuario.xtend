package ar.edu.unsam.proyecto.domain

import ar.edu.unsam.proyecto.repos.RepositorioUsuario

import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEquipo
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsNotificacion
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsUsuario
import com.fasterxml.jackson.annotation.JsonInclude
import com.fasterxml.jackson.annotation.JsonInclude.Include
import com.fasterxml.jackson.annotation.JsonView
import java.util.HashSet
import java.util.Set
import javax.persistence.CascadeType
import javax.persistence.Column
import javax.persistence.Entity
import javax.persistence.Id
import javax.persistence.JoinTable
import javax.persistence.ManyToMany
import javax.persistence.Transient
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.geodds.Point
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEncuesta
import org.apache.commons.lang.StringUtils
import ar.edu.unsam.proyecto.exceptions.IncorrectCredentials

@Accessors
@Entity
@JsonInclude(Include.NON_NULL)
class Usuario {

	@JsonView(ViewsUsuario.IdView, ViewsPartido.DefaultView, ViewsEquipo.ListView, ViewsNotificacion.NotificacionView, ViewsEncuesta.DefaultView)
	@Id
	Long idUsuario

	@JsonView(ViewsUsuario.DefaultView, ViewsNotificacion.NotificacionView, ViewsEquipo.DetalleView, ViewsEncuesta.DefaultView)
	@Column()
	String nombre = ""

	@Column()
	@JsonView(ViewsUsuario.CredencialesView)
	String password = ""

	@Column()
	@JsonView(ViewsUsuario.CredencialesView, ViewsUsuario.PerfilView, ViewsNotificacion.NotificacionView, ViewsEquipo.DetalleView, ViewsEncuesta.DefaultView)
	String foto

	@Column()
	@JsonView(ViewsUsuario.PerfilView)
	String sexo

	@Column()
	@JsonView(ViewsUsuario.PerfilView, ViewsNotificacion.NotificacionView)
	String posicion

	@Column()
	@JsonView(ViewsUsuario.DefaultView)
	String email

	@Column()
	@JsonView(ViewsUsuario.CredencialesView)
	String token

	@JsonView(ViewsUsuario.UbicacionView)
	Double lat

	@JsonView(ViewsUsuario.UbicacionView)
	Double lon

	@JoinTable(name="Amistades")
	@ManyToMany(cascade=CascadeType.REMOVE)
	Set<Usuario> amigos = new HashSet

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
		if (idUsuario === null) {
			throw new Exception('El usuario debe tener un ID')
		}

		if (nombre === null) {
			throw new Exception('El usuario debe tener un nombre')
		}

		if (idUsuario === null) {
			throw new Exception('El usuario debe tener un ID')
		}

		// TODO: Realizar distintos tipos de validacion
		if (password === null) {
			throw new Exception('El usuario debe tener una contraseña')
		}

		if (foto === null) {
			throw new Exception('El usuario debe tener una foto de perfil')
		}

		if (sexo === null) {
			throw new Exception('El usuario debe indicar su sexo')
		}

		if (posicion === null) {
			throw new Exception('El usuario debe indicar su posicion preferida')
		}

		if (email === null) {
			throw new Exception('El usuario debe tener un email')
		}

	}

	def agregarAmigo(Usuario usuario) {
		amigos.add(usuario)
	}

	def crearAmistad(Usuario usuario) {
		usuario.agregarAmigo(this)
		this.agregarAmigo(usuario)
	}
	
	def eliminarAmistadById(Long idAmigo){
		amigos.removeIf[it.idUsuario == idAmigo]
	}

	def esIntegranteDesconocido() {
		idUsuario == ID_INTEGRANTE_DESCONOCIDO
	}

	def esIntegranteConocido() {
		idUsuario > ID_INTEGRANTE_DESCONOCIDO
	}

	def estaDentroDelRango(Point ubicacionBuscada, int rango) {
		val ubicacionUsuario = getUbicacion
		ubicacionUsuario.distance(ubicacionBuscada) <= rango
	}

	def getUbicacion() {
		new Point(lat, lon)
	}

	def tieneSexo(String sexo_) {
		sexo.equals(sexo_)
	}

	def getIdDeSusAmigos() {
		amigos.map[idUsuario]
	}

	def esJugadorReservado() {
		nombre.equals("RESERVA JUGADOR") || idUsuario < -1
	}

	def jugadorReservadoAdmite(Usuario usuario) {

		var admite = true

		if (sexo !== null) {
			if (!sexo.equals("Mixto") && !sexo.equals(usuario.sexo)) {
				admite = false
			}
		}
		
		if (posicion !== null) {
			if (!sexo.equals("Cualquiera") && !posicion.equals(usuario.posicion)) {
				admite = false
			}
		}

		return admite

	}

	def esUnJugadorReservado() {
		return nombre.equals("RESERVA JUGADOR")
	}

	def esAmigoDe(Usuario usuarioBuscado) {
		amigos.exists[usuarioBuscado.idUsuario == idUsuario]
	}

	def validarCreacion() {
		if (idUsuario === null) {
			throw new Exception('El usuario debe tener un ID')
		}
	}

	def tienePosicion(String posicionBuscada) {
		posicion.equals(posicionBuscada)
	}

	def tieneId(Long idBuscado) {
		idUsuario == idBuscado
	}
	
	def esAmigoDeById(Long idBuscado) {
		amigos.exists[it.idUsuario == idBuscado]
	}
	
	def validarSignUp() {
		
		if (StringUtils.isBlank(password)){
			throw new Exception('Debe ingresar una contraseña')
		}
		
		if (StringUtils.isBlank(nombre)){
			throw new Exception('Debe ingresar un nombre')
		}
		
		if (StringUtils.isBlank(email)){
			throw new Exception('Debe ingresar un email')
		}
		
		if (StringUtils.isBlank(sexo)){
			throw new Exception('Debe indicar su sexo')
		}
		
		if (StringUtils.isBlank(posicion)){
			throw new Exception('Debe ingresar una posicion deseada')
		}
		
		if (password.length < 8){
			throw new Exception('La contraseña debe tener un minimo de 8 caracteres')
		}

	}
	
	def validarPerfil() {
		
		if(StringUtils.isBlank(nombre)){
			throw new IncorrectCredentials('Debe ingresar un nombre')
		}
		
		/* DEBUG
		 
		if (StringUtils.isBlank(password)){
			throw new IncorrectCredentials('Debe ingresar una contraseña')
		}
		
		if (StringUtils.isBlank(foto)){
			throw new IncorrectCredentials('Debe ingresar una foto')
		}
		
		if (password.length < 8){
			throw new IncorrectCredentials('La contraseña debe tener un minimo de 8 caracteres')
		}
		 
		
		*/
		
	}
	
}
