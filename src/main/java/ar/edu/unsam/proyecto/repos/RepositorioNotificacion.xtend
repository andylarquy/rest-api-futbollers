package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Notificacion
import ar.edu.unsam.proyecto.webApi.jsonViews.AuxiliarDynamicJson
import ar.edu.unsam.proyecto.webApi.jsonViews.AuxiliarDynamicJson.LocalDateAdapter
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsNotificacion.NotificacionView
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import java.time.LocalDateTime
import java.util.ArrayList
import java.util.List
import org.eclipse.xtend.lib.annotations.Accessors
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
	transient AuxiliarDynamicJson auxiliar = new AuxiliarDynamicJson
	
	Long idAutoincremental = Long.valueOf(1)
	
	var JedisPool jedisPool
	
	private new() {
		jedisPool = new JedisPool(new JedisPoolConfig, "localhost")
	}
	
	def queryTemplate((Jedis) => Object consulta){
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
			[jedis |
				val notificacionesJSON = jedis.get(idUsuario.toString)
				if (notificacionesJSON !== null) {
					
					val listType = new TypeToken<List<Notificacion>>() {}.getType()
					println(notificacionesJSON)
					
					val gson = new GsonBuilder()
					.registerTypeAdapter(LocalDateTime, new LocalDateAdapter())
					.create()
					val List<Notificacion> notificaciones = gson.fromJson(notificacionesJSON, listType)
					//notificaciones.mapearVuelosDePasajes
				return notificaciones
			}
		
		val List<Notificacion> notis = new ArrayList()
		return notis as List<Notificacion>
		])
			
	}

	def agregarNotificacion(Notificacion notificacion) {
		if (usuarioYaFueInvitadoAlPartido(notificacion) || usuarioAInvitarEsOwner(notificacion)) {
		//Do nothing
		} else {
		queryTemplate([jedis |
			
			val List<Notificacion> notis = notificacionesDelUsuario(notificacion.usuario.idUsuario) as List<Notificacion>
			notis.add(notificacion)
			
			val notisJson = auxiliar.parsearObjeto(notis, NotificacionView)
			println(notisJson)
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
}
