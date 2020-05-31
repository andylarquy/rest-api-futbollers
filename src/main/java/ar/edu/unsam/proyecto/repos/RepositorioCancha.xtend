package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Cancha

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

	private new() {}

	def searchById(String equipoId) {
		return coleccion.filter[equipo|equipo.getIdCancha.equals(equipoId)].head
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
