package ar.edu.unsam.proyecto.webApi

import ar.edu.unsam.proyecto.domain.Equipo
import ar.edu.unsam.proyecto.domain.Notificacion
import ar.edu.unsam.proyecto.domain.Partido
import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.exceptions.IncorrectCredentials
import ar.edu.unsam.proyecto.exceptions.ObjectDoesntExists
import ar.edu.unsam.proyecto.repos.RepositorioCancha
import ar.edu.unsam.proyecto.repos.RepositorioEmpresa
import ar.edu.unsam.proyecto.repos.RepositorioEquipo
import ar.edu.unsam.proyecto.repos.RepositorioNotificacion
import ar.edu.unsam.proyecto.repos.RepositorioPartido
import ar.edu.unsam.proyecto.repos.RepositorioPromocion
import ar.edu.unsam.proyecto.repos.RepositorioUsuario
import java.time.LocalDateTime
import java.util.HashSet
import java.util.List
import java.util.Set
import javax.persistence.NoResultException
import org.eclipse.xtend.lib.annotations.Accessors

@Accessors
class RestHost {
	RepositorioUsuario repoUsuario = RepositorioUsuario.instance
	RepositorioEquipo repoEquipo = RepositorioEquipo.instance
	RepositorioPartido repoPartido = RepositorioPartido.instance
	RepositorioCancha repoCancha = RepositorioCancha.instance
	RepositorioEmpresa repoEmpresa = RepositorioEmpresa.instance
	RepositorioPromocion repoPromociones = RepositorioPromocion.instance
	RepositorioNotificacion repoNotificacion = RepositorioNotificacion.instance
	
	def getPeticionDePrueba() {
		return '{ "message": "La API Rest esta funcionando!! :)" }'
	}
	
	def loguearUsuario(Usuario usuario){
		try{
		val usuarioPosta = repoUsuario.getUsuarioConCredenciales(usuario.email, usuario.password)
		
		if(usuario.token !== null){
			val deviceToken = usuario.token	
			usuarioPosta.token = deviceToken
			repoUsuario.update(usuarioPosta)
		}		
		return usuarioPosta

		}catch(NoResultException e){
			throw new IncorrectCredentials("Credenciales Invalidas")
		}
		
	}
	
	def signUpUsuario(Usuario usuario) {

		if (!repoUsuario.existeUsuarioConMail(usuario.email)){
				repoUsuario.create(usuario)
		} else {
				throw new IncorrectCredentials("Este mail ya pertenece a un usuario")
		}
	}
	
	def getPartidosDelUsuario(Long idUsuario) {
		val usuarioPosta = repoUsuario.searchById(idUsuario)
		repoPartido.getPartidosDelUsuario(usuarioPosta)
	}
	
	def getEquiposDelUsuario(Long idUsuario) {
		val usuarioPosta = repoUsuario.searchById(idUsuario)
		repoEquipo.getEquiposDelUsuario(usuarioPosta)
	}
	
	def crearNuevoEquipo(Equipo equipo) {
		equipo.validar()
		repoEquipo.create(equipo)
	}
	
	//https://i.imgur.com/j6UGUXn.jpg
	def crearNuevoPartido(Partido partido) {

		repoPartido.asignarIdPartido(partido)
	
		partido.mapearEmpresa()
		
		val Set<Usuario> destinatariosConocidos = new HashSet
		val Set<Usuario> destinatariosDesconocidos = new HashSet
		
		partido.mapearJugadoresConocidos

		destinatariosConocidos.addAll(partido.jugadoresConocidos)
		
		destinatariosConocidos.forEach[jugador |
			if(!destinatariosConocidos.exists[user | user.idUsuario == jugador.idUsuario]){
				destinatariosDesconocidos.add(jugador)
			}
		]
		
		println(destinatariosConocidos.map[idUsuario])
		println(destinatariosDesconocidos.map[idUsuario])
		
		partido.enviarNotifiacionesAConocidos(destinatariosConocidos)
		partido.enviarNotifiacionesADesconocidos(destinatariosDesconocidos)
		
		
		partido.prepararParaPersistir()
		
		partido.validar()
		
		repoEquipo.createIfNotExists(partido.equipo1)
		repoEquipo.createIfNotExists(partido.equipo2)
		
		println("SE CREO UN PARTIDO: "+partido)
		//repoPartido.create(partido)
	}
	
	def getCanchas(){
		repoCancha.coleccion
	}
	
	def getEmpresas(){
		repoEmpresa.coleccion
	}

	//ESTO PARECE QUE ESTA REPETIDO, PERO ES SOLO QUE ESTAN MAL LOS NOMBRES
	def getEmpresaById(Long idEmpresa){
		repoEmpresa.getEmpresaById(idEmpresa)
	}
	
	def getCanchasDeLaEmpresaById(Long idEmpresa){
		getEmpresaById(idEmpresa).canchas
	}	
	//////////////////////////////////
	
	def getPromocionByCodigo(String codigo){
		
		val promocion = repoPromociones.searchByCodigo(codigo)
		promocion !== null ? return promocion : throw new ObjectDoesntExists('No existe ese codigo promocional')	
	}
	
	def validarFechaCancha(LocalDateTime fecha){
		repoPartido.validarFechaCancha(fecha)
	}
	
	def getAmigosDelUsuario(Long idUsuario) {
		repoUsuario.getAmigosDelUsuario(idUsuario)
	}
	
	def getNotificacionesDelUsuario(Long idUsuario) {
		repoNotificacion.notificacionesDelUsuario(idUsuario)
	}
	
	def confirmarPartidoDeId(Long idPartido) {
		val partidoPosta = repoPartido.searchById(idPartido)
		partidoPosta.confirmarPartido()
	}
	
	def updateUbicacion(Usuario usuario) {
		
		val usuarioPosta = repoUsuario.searchById(usuario.idUsuario)
		
		usuarioPosta.lat = usuario.lat
		usuarioPosta.lon = usuario.lon

		repoUsuario.update(usuarioPosta)	
	}
	
	def debugNotificacion(Long idUsuario) {
	
		val usuarioPosta = repoUsuario.searchById(idUsuario)
		val notificacion = new Notificacion
		notificacion.titulo = "[DEBUG]"
		notificacion.descripcion = "Esta notificacion es una prueba"
		notificacion.usuario = usuarioPosta
		
		repoNotificacion.enviarUnaNotificacion(notificacion)
		
	}
	
	def debugNotificacionMultiple(List<Long> ids) {
		
		val usuariosPosta = new HashSet()
		
		ids.forEach[id | usuariosPosta.add(repoUsuario.searchById(id))]
		
		val notificacion = new Notificacion
		notificacion.titulo = "[DEBUG]"
		notificacion.descripcion = "Esta notificacion es una prueba"
		
		repoNotificacion.enviarMultipleNotificacion(notificacion, usuariosPosta)
		
	}
	

}
