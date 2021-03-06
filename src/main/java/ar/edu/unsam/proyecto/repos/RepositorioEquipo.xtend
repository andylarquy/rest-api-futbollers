package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Equipo
import ar.edu.unsam.proyecto.domain.Usuario
import java.util.List
import javax.persistence.NoResultException
import javax.persistence.criteria.JoinType
import ar.edu.unsam.proyecto.exceptions.ObjectDoesntExists

class RepositorioEquipo extends Repositorio<Equipo> {
	public static RepositorioEquipo repoEquipo

	static def RepositorioEquipo getInstance() {
		if (repoEquipo === null) {
			repoEquipo = new RepositorioEquipo()
		}
		repoEquipo
	}

	def reset() {
		repoEquipo = null
	}

	private new() {
	}

	def coleccion() {

		queryTemplate(
			[ criteria, query, from |
			from.fetch("integrantes", JoinType.LEFT)
			return query
		], [query|query.resultList]) as List<Equipo>
	}

	def searchById(Long equipoId) {
		try {
			queryTemplate(
			[ criteria, query, from |
				query.where(
					criteria.and(criteria.equal(from.get("idEquipo"), equipoId),
						criteria.equal(from.get("estado"), true))
				)
				return query
			], [query|query.singleResult]) as Equipo
		} catch (NoResultException e) {
			throw new ObjectDoesntExists("Se ha intentado obtener un equipo con un ID que no existe o que no esta activo")
		}
	}

	def searchByIdConIntegrantes(Long equipoId) {
		try {

			queryTemplate(
			[ criteria, query, from |

				from.fetch("integrantes")
				from.fetch("owner")

				query.where(
					criteria.and(criteria.equal(from.get("idEquipo"), equipoId),
						criteria.equal(from.get("estado"), true))
				)

				return query
			], [query|query.singleResult]) as Equipo
		} catch (NoResultException e) {
			throw new ObjectDoesntExists("Se ha intentado obtener un equipo con un ID que no existe o que no esta activo")
		}
	}

	def getEquiposDelUsuario(Usuario usuario) {
		queryTemplate(
			[ criteria, query, from |

			from.fetch("integrantes", JoinType.LEFT)
			from.fetch("owner", JoinType.LEFT)

			val tablaIntegrantes = from.join("integrantes", JoinType.LEFT)

			val criterio1 = criteria.equal(tablaIntegrantes.get("idUsuario"), usuario.idUsuario)
			val criterio2 = criteria.equal(from.get("owner"), usuario.idUsuario)

			val criterio3 = criteria.or(criterio1, criterio2)

			val criterio4 = criteria.notLike(from.get("nombre"), "%equipo temporal%")

			val criterio5 = criteria.equal(from.get("estado"), true)

			query.where(criteria.and(criterio3, criterio4, criterio5))
			return query
		], [query|query.resultList]) as List<Equipo>

	}

	def getEquiposAdministradosPorElUsuario(Usuario usuario) {
		queryTemplate(
			[ criteria, query, from |

			from.fetch("integrantes", JoinType.LEFT)
			from.fetch("owner", JoinType.LEFT)
			val criterio1 = criteria.equal(from.get("owner"), usuario.idUsuario)
			val criterio2 = criteria.notLike(from.get("nombre"), "%equipo temporal%")
			val criterio3 = criteria.equal(from.get("estado"), true)

			query.where(criteria.and(criterio1, criterio2, criterio3))

			return query
		], [query|query.resultList]) as List<Equipo>
	}

	def noExisteEquipoConId(String idEquipo) {
		!coleccion.exists[it.getIdEquipo.equals(idEquipo)]
	}

	def searchEquipoById(String idBuscado) {
		coleccion.filter[it.getIdEquipo.equals(idBuscado)].head
	}

	override entityType() {
		Equipo
	}

	override entityId(Equipo equipo) {
		equipo.idEquipo
	}

	// TODO: Un Try catch quizas no es lo mas adecuado
	def createIfNotExists(Equipo equipo) {
		try {
			repoEquipo.searchById(equipo.idEquipo)
		} catch (NoResultException e) {
			repoEquipo.create(equipo)
		}

	}

}
