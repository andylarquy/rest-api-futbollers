package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Notificacion
import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.webApi.jsonViews.AuxiliarDynamicJson
import io.github.cdimascio.dotenv.Dotenv
import java.util.ArrayList
import java.util.List
import java.util.Set
import org.apache.http.client.methods.HttpPost
import org.apache.http.entity.StringEntity
import org.apache.http.impl.client.HttpClients
import org.eclipse.xtend.lib.annotations.Accessors
import org.json.JSONObject

@Accessors
class RepositorioNotificacion extends Repositorio<Notificacion> {

	public static RepositorioNotificacion repoNotificacion

	static def RepositorioNotificacion getInstance() {
		if (repoNotificacion === null) {
			repoNotificacion = new RepositorioNotificacion()
		}
		repoNotificacion
	}

	def reset() {
		repoNotificacion = null
	}

	transient Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load()
	transient AuxiliarDynamicJson auxiliar = new AuxiliarDynamicJson
	transient val PROJECT_ID = dotenv.get("PROJECT_ID")
	transient val SERVER_KEY = dotenv.get("SERVER_KEY")
	transient RepositorioUsuario repoUsuario = RepositorioUsuario.instance
	transient RepositorioPartido repoPartido = RepositorioPartido.instance
	transient RepositorioEquipo repoEquipo = RepositorioEquipo.instance

	override entityId(Notificacion notificacion){
		notificacion.idNotificacion
	}

	def searchById(Long idNotificacion) {
		queryTemplate([ criteria, query, from |
			
			query.where(criteria.equal(from.get("idNotificacion"), idNotificacion))
			
		],
		[query|query.singleResult]) as Notificacion
	}

		// TODO: Revisar si esta query hace las cosas bien
	def getPartidosDelUsuario(Usuario usuario){	
		var notificaciones = queryTemplate(
			[criteria, query, from |
				
				val criterio1 = criteria.equal(from.get("aceptado"), true)
				val criterio2 = criteria.equal(from.get("usuarioReceptor"), usuario.idUsuario)
				
				query.where(criteria.and(criterio1, criterio2))

				return query
			],
		
		[query | query.resultList]) as List<Notificacion>
		
		notificaciones.forEach[noti | 
			noti.partido.equipo1 = repoEquipo.searchByIdConIntegrantes(noti.partido.equipo1.idEquipo)
			noti.partido.equipo2 = repoEquipo.searchByIdConIntegrantes(noti.partido.equipo2.idEquipo)
		]
		
		println(notificaciones.map[partido.equipo1.integrantes])
		
		notificaciones = notificaciones.filter[noti | noti.invitacionFueAceptada()].toList
		
		val partidosDelUsuario = new ArrayList
		partidosDelUsuario.addAll(notificaciones.map[partido])
	
		repoPartido.coleccion.forEach[ partido |
			
			if(partido.equipo1.esOwner(usuario) && !partidosDelUsuario.exists[it.idPartido == partido.idPartido]){
				
				partido.equipo1 = repoEquipo.searchByIdConIntegrantes(partido.equipo1.idEquipo)
				partido.equipo2 = repoEquipo.searchByIdConIntegrantes(partido.equipo2.idEquipo)
				
				partidosDelUsuario.add(partido)
			}
		]
		
		
		return partidosDelUsuario
		
	}

	def getInvitacionesDelUsuario(Long idUsuario){
		queryTemplate([ criteria, query, from |

			val criterio1 = criteria.equal(from.get("usuarioReceptor"), idUsuario)
			val criterio2 = criteria.equal(from.get("aceptado"), false)
			
			query.where(criteria.and(criterio1, criterio2))
			
			return query
		], [query|query.resultList]) as List<Notificacion>
	}

/* 
	def getNotificacionesCandidatosByIdUsuario(Long idUsuario) {
		val notificaciones = queryTemplate([ criteria, query, from |

			val criterio1 = criteria.equal(from.get("usuario"), idUsuario)
			val criterio2 = criteria.equal(from.get("aceptado"), true)

			query.where(criteria.and(criterio1, criterio2))

			return query
		], [query|query.resultList]) as List<Notificacion>
		
		notificaciones.forEach[noti | 
			noti.partido.equipo1 = repoEquipo.searchByIdConIntegrantes(noti.partido.equipo1.idEquipo)
			noti.partido.equipo2 = repoEquipo.searchByIdConIntegrantes(noti.partido.equipo2.idEquipo)
		]
		
		notificaciones.forEach[ noti|
			noti.usuarioReceptor = repoUsuario.searchByIdConAmigos(noti.usuarioReceptor.idUsuario)
		]
		
		return notificaciones.filter[notificacion | !notificacion.usuarioReceptor.esAmigoDe(notificacion.partido.equipo1.owner) && !notificacion.receptorFueAdmitido].toList

		
	}
*/

	def agregarNotificacionAUsuario(Notificacion notificacion, Usuario usuario) {
		if (!usuarioYaFueInvitadoAlPartido(notificacion, usuario) && !usuarioAInvitarEsOwner(notificacion, usuario)) {
			usuario.agregarNotificacion(notificacion)
			create(notificacion)
			repoUsuario.update(usuario)
		}
	}

	def usuarioAInvitarEsOwner(Notificacion notificacion, Usuario usuarioAInvitar) {
		notificacion.partido.equipo1.owner.idUsuario == usuarioAInvitar.idUsuario
	}

	def usuarioYaFueInvitadoAlPartido(Notificacion notificacion, Usuario usuarioAInvitar) {

		val notis = repoUsuario.notificacionesDelUsuario(usuarioAInvitar.idUsuario)
		notis.exists [ invitacion |
			invitacion.partidoTieneId(notificacion.partido.idPartido)
		]
	}

	def enviarUnaNotificacion(Notificacion notificacion) {

		if (notificacion.usuario.token !== null) {
			postNotificacion(notificacion, "to", notificacion.usuario.token)
		}

	}

	def enviarMultipleNotificacion(Notificacion notificacion, Set<Usuario> usuarios) {

		val List<String> deviceTokens = usuarios.map[repoUsuario.searchById(it.idUsuario).token].toList
		val List<String> listOfTokens = new ArrayList<String>()
		deviceTokens.forEach[listOfTokens.add(it)]

		postNotificacion(notificacion, "registration_ids", deviceTokens)

	}

	// Object destinatario es un String o un JSONArray, IMPORTANTE!!
	def postNotificacion(Notificacion notificacion, String tipoDestinatario, Object destinatario) {

		val httpClient = HttpClients.createDefault()
		val httpPost = new HttpPost("https://fcm.googleapis.com/fcm/send")

		val jsonNotificacion = new JSONObject()
		jsonNotificacion.put("title", notificacion.titulo)
		jsonNotificacion.put("text", notificacion.descripcion);

		val jsonPetition = new JSONObject()

		jsonPetition.put("notification", jsonNotificacion)
		jsonPetition.put("project_id", PROJECT_ID)

		jsonPetition.put(tipoDestinatario, destinatario)

		val entity = new StringEntity(jsonPetition.toString)

		httpPost.setEntity(entity)
		httpPost.setHeader("Content-type", "application/json")
		httpPost.setHeader("Authorization", "key=" + SERVER_KEY)

		httpClient.execute(httpPost)
	}

	override entityType() {
		Notificacion
	}
	
	

}
