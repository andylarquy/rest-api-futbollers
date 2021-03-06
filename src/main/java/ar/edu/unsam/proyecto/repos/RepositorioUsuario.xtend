package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Usuario
import java.util.ArrayList
import java.util.List
import javax.persistence.criteria.JoinType
import org.eclipse.xtend.lib.annotations.Accessors
import org.uqbar.commons.model.annotations.Observable

@Observable
@Accessors
class RepositorioUsuario extends Repositorio<Usuario> {

	public static RepositorioUsuario repoUsuario

	static def RepositorioUsuario getInstance() {
		if (repoUsuario === null) {
			repoUsuario = new RepositorioUsuario()
		}
		repoUsuario
	}

	def reset() {
		repoUsuario = null
	}

	int idAutoDecremental = -2
	int idAutoIncremental = 1

	def crearUsuarioTemporal(Usuario usuario) {
		asignarIdTemporal(usuario)
		create(usuario)
	}

	def asignarIdTemporal(Usuario usuario) {
		usuario.idUsuario = Long.valueOf(idAutoDecremental)
		idAutoDecremental--
	}

	def crearUsuario(Usuario usuario) {
		usuario.idUsuario = Long.valueOf(idAutoIncremental)
		idAutoIncremental++
		create(usuario)
	}

	private new() {
	}

	override entityId(Usuario usuario) {
		usuario.idUsuario
	}

	def coleccion() {

		queryTemplate(
			
			[ criteria, query, from |
			return query
		], [query|query.resultList]) as List<Usuario>
	}

	def existeUsuarioConMail(String email) {
		coleccion.exists[usuario|usuario.tieneEsteMail(email)]
	}

	def searchById(Long idUsuario) {
		queryTemplate(
			[ criteria, query, from |
			query.where(criteria.equal(from.get("idUsuario"), idUsuario))
			return query
		], [query|query.singleResult]) as Usuario
	}

	def getUsuarioConCredenciales(String email, String password) {

		queryTemplate([ criteria, query, from |

			query.where(
				criteria.equal(from.get("email"), email),
				criteria.equal(from.get("password"), password)
			)
		], [query|query.singleResult]) as Usuario

	}

	override entityType() {
		Usuario
	}

	def getAmigosDelUsuario(Long idUsuario) {
		val usuario = queryTemplate([ criteria, query, from |
			from.fetch("amigos", JoinType.LEFT)
			query.where(criteria.equal(from.get("idUsuario"), idUsuario))
			return query
		], [query|query.singleResult]) as Usuario

		usuario.amigos
	}

	def getCandidatosDelUsuario(Usuario usuario) {
		queryTemplate([ criteria, query, from |

			val criteriosWhere = new ArrayList()

			if (!usuario.amigos.empty) {
				criteriosWhere.add(criteria.not(from.get("idUsuario").in(usuario.idDeSusAmigos.toSet)))
			}

			criteriosWhere.add(criteria.notEqual(from.get("idUsuario"), usuario.idUsuario))
			
			criteriosWhere.add(criteria.notLike(from.get("nombre"), "%reserva jugador%"))

			query.where(criteriosWhere)
		], [query|query.resultList.toSet])

	}

	// TODO: Mejorar el formato de esta query	
	def getUsuariosEnElRangoDe(Usuario usuarioBuscado, int rangoDeBusqueda, String sexoBuscado,
		String posicionBuscada) {

		var candidatosFiltrados = coleccion.filter [ usuario |
			!usuario.esUnJugadorReservado && usuario.estaDentroDelRango(usuarioBuscado.getUbicacion, rangoDeBusqueda)
		]
		
		if (posicionBuscada !== null) {
			if (!posicionBuscada.equals("Cualquiera")) {
				candidatosFiltrados = candidatosFiltrados.filter[usuario|usuario.tienePosicion(posicionBuscada)]
			}
		}
		
		if (sexoBuscado !== null) {
			if (!sexoBuscado.equals("Mixto")) {
				candidatosFiltrados = candidatosFiltrados.filter[usuario|usuario.tieneSexo(sexoBuscado)]

			}
		}

		return candidatosFiltrados

	}

	def searchByIdConAmigos(Long idUsuario) {
		queryTemplate(
			[ criteria, query, from |
			from.fetch("amigos", JoinType.LEFT)
			query.where(criteria.equal(from.get("idUsuario"), idUsuario))
			return query
		], [query|query.singleResult]) as Usuario
	}

}
