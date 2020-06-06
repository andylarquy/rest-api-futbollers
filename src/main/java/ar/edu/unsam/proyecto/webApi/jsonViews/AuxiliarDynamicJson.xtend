package ar.edu.unsam.proyecto.webApi.jsonViews

import ar.edu.unsam.proyecto.domain.Cancha
import ar.edu.unsam.proyecto.domain.Empresa
import ar.edu.unsam.proyecto.domain.Equipo
import ar.edu.unsam.proyecto.domain.Usuario
import ar.edu.unsam.proyecto.repos.RepositorioCancha
import ar.edu.unsam.proyecto.repos.RepositorioEmpresa
import ar.edu.unsam.proyecto.repos.RepositorioEquipo
import ar.edu.unsam.proyecto.repos.RepositorioUsuario
import com.fasterxml.jackson.databind.MapperFeature
import com.fasterxml.jackson.databind.ObjectMapper
import com.google.gson.JsonDeserializationContext
import com.google.gson.JsonDeserializer
import com.google.gson.JsonElement
import java.lang.reflect.Type
import java.time.LocalDateTime
import java.util.List

/*
 * La biblioteca de Jackson tiene un sistema para elegir cuales propiedades mostrar y cuales no 
 * dependiendo de la situacion al serializar un JSON. Ademas tenemos adapters para que la bilbioteca
 * de Gson pueda traducir de JSON a Java, lo separamos en un archivo auxiliar para no ensuciar la logica
 *  
 * (<3 Gracias Java, sos malisimo)
 * 
 */

class AuxiliarDynamicJson {
	/* "JsonIgnore Dinamico" con Jackson*/
	def <ViewGeneric> parsearObjeto(Object elementoAParsear, Class<ViewGeneric> customView) {

		var mapper = new ObjectMapper();
		mapper.disable(MapperFeature.DEFAULT_VIEW_INCLUSION);

		var result = mapper.writerWithView(customView).writeValueAsString(elementoAParsear);
		return result
	}

	// GSON ADAPTERS SARASA
	static class LocalDateAdapter implements JsonDeserializer<LocalDateTime> {
		override deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) {
			LocalDateTime.parse(json.getAsJsonPrimitive().getAsString())
		}
	}

	static class UsuarioAdapter implements JsonDeserializer<Usuario> {
		val repoUsuario = RepositorioUsuario.instance

		override deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) {
			val idUsuario = json.getAsJsonPrimitive().getAsLong()
			repoUsuario.searchById(idUsuario)
		}
	}

	static class UsuarioListAdapter implements JsonDeserializer<List<Usuario>> {
		val repoUsuario = RepositorioUsuario.instance

		override deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) {
			val idUsuarios = json.getAsJsonArray()
			val idUsuariosSinQuotes = idUsuarios.map[it.getAsJsonPrimitive().getAsLong()]
			idUsuariosSinQuotes.map[repoUsuario.searchById(it)].toList
		}
	}

	static class EquiposAdapter implements JsonDeserializer<Equipo> {
		val repoEquipo = RepositorioEquipo.instance

		override deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) {
			val idEquipo = json.getAsJsonPrimitive().getAsLong()
			return repoEquipo.searchById(idEquipo)
		}
	}

	static class EmpresaAdapter implements JsonDeserializer<Empresa> {
		val repoEmpresa = RepositorioEmpresa.instance

		override deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) {
			val idEmpresa = json.getAsJsonPrimitive().getAsLong()
			return repoEmpresa.searchById(idEmpresa)
		}
	}

	static class CanchaAdapter implements JsonDeserializer<Cancha> {
		val repoCancha = RepositorioCancha.instance

		override deserialize(JsonElement json, Type typeOfT, JsonDeserializationContext context) {
			val idCancha = json.getAsJsonPrimitive().getAsLong()
			return repoCancha.searchById(idCancha)
		}
	}






	
}