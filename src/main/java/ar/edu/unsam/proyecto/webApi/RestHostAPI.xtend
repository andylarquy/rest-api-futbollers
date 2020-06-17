package ar.edu.unsam.proyecto.webApi

import ar.edu.unsam.proyecto.domain.Equipo
import ar.edu.unsam.proyecto.domain.Partido
import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.exceptions.IncorrectCredentials
import ar.edu.unsam.proyecto.exceptions.InsufficientCandidates
import ar.edu.unsam.proyecto.exceptions.ObjectAlreadyExists
import ar.edu.unsam.proyecto.exceptions.ObjectDoesntExists
import ar.edu.unsam.proyecto.webApi.jsonViews.AuxiliarDynamicJson
import ar.edu.unsam.proyecto.webApi.jsonViews.AuxiliarDynamicJson.LocalDateAdapter
import ar.edu.unsam.proyecto.webApi.jsonViews.AuxiliarDynamicJson.UsuarioAdapter
import ar.edu.unsam.proyecto.webApi.jsonViews.AuxiliarDynamicJson.UsuarioListAdapter
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsCancha
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEmpresa
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEquipo
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsNotificacion
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsUsuario
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import com.google.gson.reflect.TypeToken
import java.time.LocalDateTime
import java.util.List
import org.json.JSONObject
import org.uqbar.xtrest.api.annotation.Body
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.api.annotation.Post
import org.uqbar.xtrest.json.JSONUtils

@Controller
class RestHostAPI {
	extension JSONUtils = new JSONUtils
	RestHost restHost

	AuxiliarDynamicJson auxiliar = new AuxiliarDynamicJson()

	new(RestHost restHost) {
		this.restHost = restHost
	}

	@Get("/index")
	def getPeticionDePrueba() {

		try {
			ok(restHost.getPeticionDePrueba())
		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	@Post("/login")
	def loguearUsuario(@Body String body) {

		try {

			val Usuario usuario = body.fromJson(Usuario)
			val usuarioParseado = auxiliar.parsearObjeto(restHost.loguearUsuario(usuario),
				ViewsUsuario.CredencialesView)

			ok(usuarioParseado)
		} catch (IncorrectCredentials e) {
			forbidden('{"status":401, "message":"' + e.message + '"}')
		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	@Post("/usuario")
	def signUpUsuario(@Body String body) {

		val Usuario usuario = body.fromJson(Usuario)

		try {
			restHost.signUpUsuario(usuario)
			ok('{"status": 200}')
		} catch (IncorrectCredentials e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	@Get("/usuario/:idUsuario/amigos")
	def amigosDelUsuarioById() {

		try {
			val amigosDelUsuarioParseados = auxiliar.parsearObjeto(
				restHost.getAmigosDelUsuario(Long.valueOf(idUsuario)), ViewsUsuario.PerfilView)

			ok(amigosDelUsuarioParseados)
		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}

	}

	@Post("/usuario/:idUsuario/amigo/:idAmigo")
	def agregarAmigoAUsuario() {

		try {
			restHost.agregarAmigoAUsuario(Long.valueOf(idUsuario), Long.valueOf(idAmigo))

			ok('{"status": 200}')
		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}

	}

	@Get("/partidos/:idUsuario")
	def getPartidosByIdDelUsuario() {

		try {
			var partidoParseado = auxiliar.parsearObjeto(restHost.getPartidosDelUsuario(Long.valueOf(idUsuario)),
				ViewsPartido.ListView)
			ok(partidoParseado)
		} catch (ObjectDoesntExists e) {
			notFound('{"status":404, "message":"' + e.message + '"}')
		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	@Post("/partidos")
	def postPartidos(@Body String body) {
		try {
			// Seteo los adapter de ID a javaObject
			val gson = new GsonBuilder().registerTypeAdapter(LocalDateTime, new LocalDateAdapter()).create()

			val partido = gson.fromJson(body.toString, Partido)

			restHost.crearNuevoPartido(partido)

			ok('{"status":200, "message":"ok"}')
		} catch (InsufficientCandidates e) {
			notFound('{"status":404, "message":"' + e.message + '"}')
		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
			throw e
		}
	}

	@Get("/equipos/:idUsuario")
	def getEquiposDelUsuarioById() {

		try {
			var partidoParseado = auxiliar.parsearObjeto(restHost.getEquiposDelUsuario(Long.valueOf(idUsuario)),
				ViewsEquipo.ListView)
			ok(partidoParseado)
		} catch (ObjectDoesntExists e) {
			notFound('{"status":404, "message":"' + e.message + '"}')
		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}

	}

	@Get("/equipos-owner/:idUsuario")
	def getEquiposAdministradosPorElUsuarioById() {
		try {
			var partidoParseado = auxiliar.parsearObjeto(
				restHost.getEquiposAdministradosPorElUsuario(Long.valueOf(idUsuario)), ViewsEquipo.ListView)
			ok(partidoParseado)
		} catch (ObjectDoesntExists e) {
			notFound('{"status":404, "message":"' + e.message + '"}')
		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}

	}

	@Post("/equipos")
	def postEquipos(@Body String body) {

		try {
			val gson = new GsonBuilder().registerTypeAdapter(Usuario, new UsuarioAdapter).registerTypeAdapter(List,
				new UsuarioListAdapter()).create()

			val equipo = body.fromJson(Equipo)

			restHost.crearNuevoEquipo(equipo)
			ok('{"status":200, "message":"ok"}')
		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}

	}

	// TODO: Testear GET /canchas
	@Get("/canchas")
	def getCanchas() {
		try {
			var canchasParseadas = restHost.getCanchas().toJson
			ok(canchasParseadas)
		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	// TODO: Testear GET /empresas
	@Get("/empresas")
	def getEmpresas() {
		try {
			var empresaParseada = auxiliar.parsearObjeto(restHost.getEmpresas(), ViewsEquipo.ListView)
			ok(empresaParseada)
		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	// TODO: Testear GET /empresas/:idEmpresa
	@Get("/empresas/:idEmpresa")
	def getEmpresaById() {
		try {
			var empresaParseada = auxiliar.parsearObjeto(restHost.getEmpresaById(Long.valueOf(idEmpresa)),
				ViewsEmpresa.SetupView)
			ok(empresaParseada)

		} catch (ObjectDoesntExists e) {
			notFound('{"status":404, "message":"' + e.message + '"}')

		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}

	}

	// TODO: Testear GET /empresas-canchas/:idEmpresa
	@Get("/empresas-canchas/:idEmpresa")
	def getCanchasDeLaEmpresaById() {
		try {
			var canchasParseadas = auxiliar.parsearObjeto(restHost.getCanchasDeLaEmpresaById(Long.valueOf(idEmpresa)),
				ViewsCancha.DefaultView)
			ok(canchasParseadas)

		} catch (ObjectDoesntExists e) {
			notFound('{"status":404, "message":"' + e.message + '"}')

		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	// TODO: Testear GET /promocion/:codigo
	@Get("/promocion/:codigo")
	def getPromocionByCodigo() {
		try {

			val promocion = restHost.getPromocionByCodigo(codigo)
			val promocionParseada = promocion.toJson

			ok(promocionParseada)

		} catch (ObjectDoesntExists e) {
			notFound('{"status":404, "message":"' + e.message + '"}')

		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	@Post("/validar-fecha")
	def validarFechaCancha(@Body String body) {
		try {
			val jsonBody = new JSONObject(body)
			val fecha = jsonBody.getString("fecha")
			val fechaPosta = LocalDateTime.parse(fecha)
			
			val idCanchaReservada = jsonBody.getLong("idCanchaReservada")
			restHost.validarFechaCancha(fechaPosta, idCanchaReservada)
			
			ok('{"status":200, "message":"ok"}')

		} catch (ObjectAlreadyExists e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')

		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	@Post("/confirmar-partido/:idPartido")
	def confirmarPartido() {
		try {
			restHost.confirmarPartidoDeId(Long.valueOf(idPartido))
			ok('{"status":200, "message":"ok"}')

		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}

	}

/*
 * 
 * 
 
	TODO: REVISAR
	@Get("/notificaciones/:idUsuario")
	def getNotificacionesDelUsuarioById() {
		try {
			// Si precisas mostrar mas cosas agregales ViewsNotificacion.NotificacionView
			var notificacionesParseadas = auxiliar.parsearObjeto(
				restHost.getNotificacionesDelUsuario(Long.valueOf(idUsuario)), ViewsNotificacion.NotificacionView)
			ok(notificacionesParseadas)

		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}
*/





	/* 
	 * 	@Get("/notificaciones-candidatos/:idUsuario")
	 * 	def getNotificacionesCandidatosDelUsuarioById(){
	 * 		try{
	 * 			//Si precisas mostrar mas cosas agregales ViewsNotificacion.NotificacionView
	 * 			var notificacionesParseadas = auxiliar.parsearObjeto(restHost.getNotificacionesCandidatosDelUsuario(Long.valueOf(idUsuario)), ViewsNotificacion.NotificacionView)
	 * 			ok(notificacionesParseadas)
	 * 		
	 * 		} catch (Exception e) {
	 * 			badRequest('{"status":400, "message":"' + e.message + '"}')
	 * 		}
	 * 	}
	 */
	 
	@Get("/notificaciones-invitaciones/:idUsuario")
	def getInvitacionesDelUsuarioById() {
		try {


			println("NOTIS: "+restHost.getInvitacionesDelUsuario(Long.valueOf(idUsuario)))
			

			var notificacionesParseadas = auxiliar.parsearObjeto(
				restHost.getInvitacionesDelUsuario(Long.valueOf(idUsuario)), ViewsNotificacion.NotificacionView)
			
			println("NPTIS PARSEADAS: "+notificacionesParseadas)
			
			ok(notificacionesParseadas)

		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	@Post("/invitaciones-aceptar/:idNotificacion")
	def aceptarInvitacionById() {
		try {

			restHost.aceptarInvitacion(Long.valueOf(idNotificacion))

			ok('{"status":200, "message":"ok"}')

		} catch (Exception e) {
		
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}

	}

	/* 
	 * @Post("/candidato-aceptar/:idNotificacion")
	 * def aceptarCandidatoById(){
	 * 	try{
	 * 		
	 * 		restHost.aceptarCandidato(Long.valueOf(idNotificacion))
	 * 		
	 * 		ok('{"status":200, "message":"ok"}')
	 * 	}catch(Exception e){
	 * 		badRequest('{"status":400, "message":"'+e.message+'"}')
	 * 	}
	 * }
	 */
	 
	@Post("/ubicacion")
	def updateUbicacionUsuarioById(@Body String body) {
		try {

			val usuarioParseado = new Gson().fromJson(body, Usuario)

			println("ping ubicacion del usuario: " + usuarioParseado.idUsuario)

			restHost.updateUbicacion(usuarioParseado)
			ok('{"status":200, "message":"ok"}')

		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	@Get("/candidatos/:idUsuario")
	def getCandidatosByIdUsuario() {

		try {
			val candidatosParseados = auxiliar.parsearObjeto(restHost.getCandidatosDelUsuario(Long.valueOf(idUsuario)),
				ViewsUsuario.PerfilView)
			ok(candidatosParseados)
		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	@Post("/debug/notificacion/:id1")
	def postDebugNotificacion(@Body String body) {
		try {

			// val idUsuario2 = bodyJSON.getString("id1")
			restHost.debugNotificacion(Long.valueOf(id1))

			ok('{"status":200, "message":"ok"}')

		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	@Post("/debug/notificacion-multiple")
	def postDebugNotificacion(@Body String body) {
		try {

			val bodyJSON = new JSONObject(body)
			val ids = bodyJSON.getJSONArray("ids")

			val List<Long> idsPosta = new Gson().fromJson(ids.toString, new TypeToken<List<Long>>() {
			}.getType())

			restHost.debugNotificacionMultiple(idsPosta)

			ok('{"status":200, "message":"ok"}')

		} catch (Exception e) {
			badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

}
