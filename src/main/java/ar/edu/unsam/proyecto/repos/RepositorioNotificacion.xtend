package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Notificacion
import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.webApi.jsonViews.AuxiliarDynamicJson
import io.github.cdimascio.dotenv.Dotenv
import java.util.ArrayList
import java.util.HashSet
import java.util.List
import java.util.Set
import org.apache.http.client.methods.HttpPost
import org.apache.http.entity.StringEntity
import org.apache.http.impl.client.HttpClients
import org.eclipse.xtend.lib.annotations.Accessors
import org.json.JSONObject
import org.apache.commons.lang.StringUtils

@Accessors
class RepositorioNotificacion {

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

	int idAutoIncremental = 0

	transient Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load()
	transient AuxiliarDynamicJson auxiliar = new AuxiliarDynamicJson
	transient val PROJECT_ID = dotenv.get("PROJECT_ID")
	transient val SERVER_KEY = dotenv.get("SERVER_KEY")
	transient RepositorioUsuario repoUsuario = RepositorioUsuario.instance
	transient RepositorioPartido repoPartido = RepositorioPartido.instance
	transient RepositorioEquipo repoEquipo = RepositorioEquipo.instance

	Set<Notificacion> coleccion = new HashSet()

	def searchById(Long idNotificacion) {

		val notificacion = coleccion.findFirst[it.idNotificacion == idNotificacion]

		if (notificacion === null) {
			throw new Exception('No se ha encontrado una notificacion con ese ID')
		}
		return notificacion
	}

	// TODO: Revisar si esta query hace las cosas bien
	def getPartidosDelUsuario(Usuario usuario) {

		var notificaciones = coleccion.filter [ noti |
			noti.fueAceptada() && noti.receptorEs(usuario)
		].toList
		
		notificaciones.forEach [ noti |
			noti.partido = repoPartido.searchById(noti.partido.idPartido)
			noti.partido.equipo1 = repoEquipo.searchByIdConIntegrantes(noti.partido.equipo1.idEquipo)
			noti.partido.equipo2 = repoEquipo.searchByIdConIntegrantes(noti.partido.equipo2.idEquipo)
		]

		notificaciones = notificaciones.filter[noti|noti.fueAceptada()].toList

		val partidosDelUsuario = new ArrayList
		partidosDelUsuario.addAll(notificaciones.map[partido])

		val partidosDeLaBase = new ArrayList
		partidosDeLaBase.addAll(repoPartido.coleccion)
		
		
		partidosDeLaBase.forEach[partido | 
			partido.equipo1 = repoEquipo.searchByIdConIntegrantes(Long.valueOf(partido.equipo1.idEquipo))
			partido.equipo2 = repoEquipo.searchByIdConIntegrantes(Long.valueOf(partido.equipo2.idEquipo))
		]
		
		partidosDeLaBase.forEach [ partido |

			if (partido.equipo1.esOwner(usuario) && !partidosDelUsuario.exists[it.idPartido == partido.idPartido]) {

				partidosDelUsuario.add(partido)
			}
		]

		return partidosDelUsuario

	}

	def getInvitacionesDelUsuario(Long idUsuario) {

		coleccion.filter [ noti |
			!noti.fueAceptada() && noti.receptorTieneId(idUsuario)
		].toList

	}

	def agregarNotificacion(Notificacion notificacion) {
		println("Se agrego el usuario con ID: " + notificacion.usuarioReceptor.idUsuario)
		coleccion.add(notificacion)
	}

	def usuarioAInvitarEsOwner(Notificacion notificacion, Usuario usuarioAInvitar) {
		notificacion.partido.equipo1.owner.idUsuario == usuarioAInvitar.idUsuario
	}

	def usuarioYaFueInvitadoAlPartido(Notificacion notificacion, Usuario usuarioAInvitar) {
		coleccion.exists [ noti |
			noti.receptorEs(usuarioAInvitar) && noti.partidoEs(notificacion.partido)

		]
	}

	def enviarUnaNotificacion(Notificacion notificacion) {

		if (notificacion.usuarioReceptor.token !== null) {
			postNotificacion(notificacion, "to", "normal", notificacion.usuarioReceptor.token)
		}

	}

	def enviarMultipleNotificacion(Notificacion notificacion, Set<Usuario> usuarios) {

		val List<String> deviceTokens = usuarios.map[repoUsuario.searchById(it.idUsuario).token].toList
		val List<String> listOfTokens = new ArrayList<String>()
		deviceTokens.forEach[listOfTokens.add(it)]

		postNotificacion(notificacion, "registration_ids","normal", deviceTokens)

	}
	
	def enviarUnaNotificacionInmediata(Notificacion notificacion) {
		if (notificacion.usuarioReceptor.token !== null) {
			postNotificacion(notificacion, "to", "high", notificacion.usuarioReceptor.token)
		}
	}

	// Object destinatario es un String o un JSONArray, IMPORTANTE!!
	def postNotificacion(Notificacion notificacion, String tipoDestinatario, String priority, Object destinatario) {

		val httpClient = HttpClients.createDefault()
		val httpPost = new HttpPost("https://fcm.googleapis.com/fcm/send")

		val jsonNotificacion = new JSONObject()
		jsonNotificacion.put("title", notificacion.titulo)
		jsonNotificacion.put("text", notificacion.descripcion)
		
		val jsonAndroid = new JSONObject()
		jsonAndroid.put("priority", priority)

		val jsonPetition = new JSONObject()

		jsonPetition.put("notification", jsonNotificacion)
		jsonPetition.put("project_id", PROJECT_ID)
		jsonPetition.put("android", jsonAndroid)

		jsonPetition.put(tipoDestinatario, destinatario)

		val entity = new StringEntity(jsonPetition.toString)

		httpPost.setEntity(entity)
		httpPost.setHeader("Content-type", "application/json")
		httpPost.setHeader("Authorization", "key=" + SERVER_KEY)

		if(StringUtils.isBlank(SERVER_KEY)){
			throw new Exception('SERVER_KEY es null, probablemente falta el SERVER_KEY en el archivo .env')
		}
		

		httpClient.execute(httpPost)
	}

	def getIdNotificacion() {
		idAutoIncremental++
		return Long.valueOf(idAutoIncremental)
	}
	
	def eliminarNoitificacion(Notificacion notificacion) {
		coleccion.remove(notificacion)
	}
	
	def eliminarNotificacioneDePartidoById(Long idPartido) {
		val partidoABorrar = repoPartido.searchById(idPartido)
		coleccion.removeIf[noti | noti.partido.idPartido == partidoABorrar.idPartido]
	}
	
	//Trae todas las notificaciones, incluso las que ya han sido aceptadas
	def getTodasLasNotificacionesDelUsuario(Long idUsuario){
		coleccion.filter [ noti |
			noti.receptorTieneId(idUsuario)
		].toList
	}

}
