package ar.edu.unsam.proyecto.repos

import ar.edu.unsam.proyecto.domain.Usuario
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

	private new() {}
	
	def coleccion(){
		
		queryTemplate(
			
			[criteria, query, from |
				
				return query
			], 
			[query | query.resultList]) as List<Usuario>
	}
	
	def existeUsuarioConMail(String email){
		coleccion.exists[usuario | usuario.tieneEsteMail(email)]
	}

	def searchById(Long idUsuario) {
		queryTemplate(
			[criteria, query, from |
				
				query.where(criteria.equal(from.get("idUsuario"), idUsuario))
				return query
			], 
			[query | query.singleResult]) as Usuario
	}
	
	def getUsuarioConCredenciales(String email, String password){
	
	queryTemplate([criteria, query, from |

			query.where(
				criteria.equal(from.get("email"), email),
				criteria.equal(from.get("password"), password)
			)
		], [query | query.singleResult]) as Usuario
		
	}
	
	override entityType() {
		Usuario
	}
	
	def getAmigosDelUsuario(Long idUsuario){
		val usuario = queryTemplate([criteria, query, from |
			from.fetch("amigos", JoinType.LEFT)	
			query.where(criteria.equal(from.get("idUsuario"), idUsuario))
			return query
		], 
		
		[query | query.singleResult]) as Usuario
		
		usuario.amigos
	}

	//TODO: Hacer en formato de query	
	def getUsuariosEnElRangoDe(Usuario usuarioBuscado, int rangoDeBusqueda, String sexoBuscado, String posicionBuscada) {
		coleccion.filter[usuario | usuario.estaDentroDelRango(usuarioBuscado.getUbicacion, rangoDeBusqueda * 100)]
	}
	
}