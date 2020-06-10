package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Notificacion
import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.webApi.jsonViews.AuxiliarDynamicJson
import ar.edu.unsam.proyecto.webApi.jsonViews.AuxiliarDynamicJson.LocalDateAdapter
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsNotificacion.NotificacionView
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import io.github.cdimascio.dotenv.Dotenv
import java.time.LocalDateTime
import java.util.ArrayList
import java.util.List
import java.util.Set
import org.apache.http.client.methods.HttpPost
import org.apache.http.entity.StringEntity
import org.apache.http.impl.client.HttpClients
import org.eclipse.xtend.lib.annotations.Accessors
import org.json.JSONObject
import redis.clients.jedis.Jedis
import redis.clients.jedis.JedisPool
import redis.clients.jedis.JedisPoolConfig
import redis.clients.jedis.exceptions.JedisConnectionException

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

//	Set<Notificacion> coleccion = new HashSet()
	transient Dotenv dotenv = Dotenv.configure().ignoreIfMissing().load()
	transient AuxiliarDynamicJson auxiliar = new AuxiliarDynamicJson
	transient val PROJECT_ID = dotenv.get("PROJECT_ID")
	transient val SERVER_KEY = dotenv.get("SERVER_KEY")

	Long idAutoincremental = Long.valueOf(1)

	var JedisPool jedisPool

	private new() {
		jedisPool = new JedisPool(new JedisPoolConfig, "localhost")
	}

	def queryTemplate((Jedis)=>Object consulta) {
		var Jedis jedis
		try {
			jedis = jedisPool.resource
			consulta.apply(jedis)
		} catch (JedisConnectionException e) {
			throw new Exception("Error de conexión a Redis")
		} finally {
			if (jedis !== null)
				jedis.close()
		}
	}

	def asignarIdNotificacion(Notificacion noti) {
		noti.idNotificacion = idAutoincremental
		idAutoincremental++
	}

	def notificacionesDelUsuario(Long idUsuario) {
		queryTemplate(
			[ jedis |
			val notificacionesJSON = jedis.get(idUsuario.toString)
			if (notificacionesJSON !== null) {

				val listType = new TypeToken<List<Notificacion>>() {
				}.getType()

				val gson = new GsonBuilder().registerTypeAdapter(LocalDateTime, new LocalDateAdapter()).create()
				val List<Notificacion> notificaciones = gson.fromJson(notificacionesJSON, listType)
				return notificaciones
			}

			val List<Notificacion> notis = new ArrayList()
			return notis as List<Notificacion>
		])

	}

	//TODO: Do nothing... por favor, no
	def agregarNotificacion(Notificacion notificacion) {
		if (usuarioYaFueInvitadoAlPartido(notificacion) || usuarioAInvitarEsOwner(notificacion)) {
			// Do nothing
		} else {
			queryTemplate([ jedis |

				val List<Notificacion> notis = notificacionesDelUsuario(
					notificacion.usuario.idUsuario) as List<Notificacion>
				notis.add(notificacion)

				val notisJson = auxiliar.parsearObjeto(notis, NotificacionView)
				jedis.set(notificacion.usuario.idUsuario.toString, notisJson)
			])
		}
	}

	def usuarioAInvitarEsOwner(Notificacion notificacion) {
		notificacion.partido.equipo1.owner.idUsuario === notificacion.usuario.idUsuario
	}

	def usuarioYaFueInvitadoAlPartido(Notificacion notificacion) {

		val List<Notificacion> notis = notificacionesDelUsuario(notificacion.usuario.idUsuario) as List<Notificacion>
		notis.exists [ invitacion |
			invitacion.partidoTieneId(notificacion.partido.idPartido) &&
				invitacion.esDelUsuario(notificacion.usuario.idUsuario)
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

}
