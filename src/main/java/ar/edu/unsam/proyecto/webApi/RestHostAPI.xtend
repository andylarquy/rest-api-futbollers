package ar.edu.unsam.proyecto.webApi

import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.exceptions.IncorrectCredentials
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsEquipo
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsPartido
import ar.edu.unsam.proyecto.webApi.jsonViews.ViewsUsuario
import com.fasterxml.jackson.databind.MapperFeature
import com.fasterxml.jackson.databind.ObjectMapper
import org.uqbar.xtrest.api.annotation.Body
import org.uqbar.xtrest.api.annotation.Controller
import org.uqbar.xtrest.api.annotation.Get
import org.uqbar.xtrest.api.annotation.Post
import org.uqbar.xtrest.json.JSONUtils

@Controller
class RestHostAPI {
	extension JSONUtils = new JSONUtils
	RestHost restHost

	new(RestHost restHost) {
		this.restHost = restHost
	}

	@Get("/index")
	def getPeticionDePrueba() {

		return ok(restHost.getPeticionDePrueba())
	}

	@Post("/usuario/login")
	def loguearUsuario(@Body String body) {

		val Usuario usuario = body.fromJson(Usuario)
		// println(usuario.email)
		try {
			val usuarioParseado = this.parsearObjeto(restHost.loguearUsuario(usuario.email, usuario.password),
				ViewsUsuario.CredencialesView)

			// println("Json del usuario recien logueado: " + usuarioParseado + "\n")
			return ok(usuarioParseado)
		} catch (IncorrectCredentials e) {
			return forbidden('{"status":401, "message":"' + e.message + '"}')
		}
	}

	@Post("/usuario")
	def signUpUsuario(@Body String body) {

		val Usuario usuario = body.fromJson(Usuario)

		println(body)
		try {
			restHost.signUpUsuario(usuario)

			return ok('{"status": 200}')

		} catch (IncorrectCredentials e) {
			return badRequest('{"status":400, "message":"' + e.message + '"}')
		}
	}

	@Get("/partidos/:idUsuario")
	def getPartidos() {

		try {
			println(restHost.getPartidosDelUsuario(idUsuario).map[it.equipo1].map[nombre])
			var partidoParseado = this.parsearObjeto(restHost.getPartidosDelUsuario(idUsuario),
				ViewsPartido.ListView)
			return ok(partidoParseado)
		} catch (Exception e) {
			return badRequest('{"status":400, "message":"' + e.message + '"}')
		}

	}
	
	@Get("/equipos/:idUsuario")
	def getEquipos() {

		try {
			println(restHost.getPartidosDelUsuario(idUsuario).map[it.equipo1].map[nombre])
			var partidoParseado = this.parsearObjeto(restHost.getEquiposDelUsuario(idUsuario),
				ViewsEquipo.ListView)
			return ok(partidoParseado)
		} catch (Exception e) {
			return badRequest('{"status":400, "message":"' + e.message + '"}')
		}

	}

	/* Cosas del "JsonIgnore Dinamico" */
	def <ViewGeneric> parsearObjeto(Object elementoAParsear, Class<ViewGeneric> customView) {

		var mapper = new ObjectMapper();
		mapper.disable(MapperFeature.DEFAULT_VIEW_INCLUSION);

		var result = mapper.writerWithView(customView).writeValueAsString(elementoAParsear);
		return result
	}

}
