package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Cancha
import java.util.List

class RepositorioCancha extends Repositorio<Cancha> {

	public static RepositorioCancha repoCancha

	static def RepositorioCancha getInstance() {
		if (repoCancha === null) {
			repoCancha = new RepositorioCancha()
		}
		repoCancha
	}

	def reset() {
		repoCancha = null
	}

	override entityId(Cancha cancha){
		cancha.idCancha
	}
	private new() {}

	def coleccion() {

		queryTemplate(
			[criteria, query, from |],
			[query | query.resultList ]
			) as List<Cancha>
	}

	def searchById(Long equipoId) {
		return coleccion.filter[equipo|equipo.getIdCancha == equipoId].head
	}

	def noExisteCanchaConId(String idCancha) {
		!coleccion.exists[it.getIdCancha.equals(idCancha)]
	}

	def searchEquipoById(String idBuscado) {
		coleccion.filter[it.getIdCancha.equals(idBuscado)].head
	}

	override entityType() {
		Cancha
	}

}
