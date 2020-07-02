package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Encuesta
import java.util.List
import ar.edu.unsam.proyecto.domain.Notificacion

//No hay codigo repetido en ba sing se
class RepositorioEncuesta extends Repositorio<Encuesta> {

	public static RepositorioEncuesta repoEncuesta

	static def RepositorioEncuesta getInstance() {
		if (repoEncuesta === null) {
			repoEncuesta = new RepositorioEncuesta()
		}
		repoEncuesta
	}

	RepositorioNotificacion repoNotificacion = RepositorioNotificacion.instance

	override entityId(Encuesta repoEncuesta) {
		repoEncuesta.idEncuesta
	}

	private new() {
	}

	def coleccion() {
		queryTemplate(
			[criteria, query, from |],
			[query|query.resultList]
		) as List<Encuesta>
	}

	def searchById(Long equipoId) {
		return coleccion.filter[equipo|equipo.idEncuesta == equipoId].head
	}

	def noExisteEncuestaConId(String idEncuesta) {
		!coleccion.exists[it.idEncuesta.equals(idEncuesta)]
	}

	def searchEncuestaById(String idBuscado) {
		coleccion.filter[it.getIdEncuesta.equals(idBuscado)].head
	}

	override entityType() {
		Encuesta
	}

	def agregarEncuesta(Encuesta encuesta) {
		create(encuesta)

		//TODO: Intentar enviar notificaciones (firebase se puso la gorra)
	}
	
	//TODO: Hay una cosa que se llama SQL...
	def getEncuestasDelUsuario(Long idUsuario) {
		coleccion.filter[encuesta | encuesta.usuarioEncuestado.idUsuario == idUsuario].toList
	}

}
