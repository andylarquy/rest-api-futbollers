package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Promocion

class RepositorioPromocion extends Repositorio<Promocion> {

	public static RepositorioPromocion repoPromocion

	static def RepositorioPromocion getInstance() {
		if (repoPromocion === null) {
			repoPromocion = new RepositorioPromocion()
		}
		repoPromocion
	}

	def reset() {
		repoPromocion = null
	}

	private new() {
	}

	def searchById(String promocionId) {
		return coleccion.filter[promocion|promocion.idPromocion.equals(promocionId)].head
	}

	def searchByCodigo(String codigo) {
		return coleccion.filter[promocion|promocion.codigo.equals(codigo)].head
	}

	override entityType() {
		Promocion
	}

}
